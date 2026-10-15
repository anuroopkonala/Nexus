# ==============================================================================
# Nexus Baremetal - Developer CLI Toolkit & AOT Compiler
# ==============================================================================

param(
    [Parameter(Position = 0)]
    [string]$Action,

    [Parameter(Position = 1)]
    [string]$File,

    [Parameter(Position = 2)]
    [string]$OutputFile,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ExtraArgs
)

if ($Action -eq "build") {
    Write-Host "Building Nexus Baremetal VM..." -ForegroundColor Cyan
    if (-not (Test-Path "bin")) {
        New-Item -ItemType Directory -Path "bin" | Out-Null
    }
    gcc -O3 -o bin/nexus_core.exe src/vm/nexus_core.s src/vm/nexus_gpu.s -lws2_32
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Assembly Compilation failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Build Successful: bin/nexus_core.exe" -ForegroundColor Green
}
elseif ($Action -eq "run") {
    if (-not $File) {
        Write-Host "Error: No file specified." -ForegroundColor Red
        Write-Host "Usage: .\nexus.ps1 run <file.nx>"
        exit 1
    }
    if (-not (Test-Path "bin/nexus_core.exe")) {
        Write-Host "Error: VM not built. Run '.\nexus.ps1 build' first." -ForegroundColor Red
        exit 1
    }

    Write-Host "Running $File..." -ForegroundColor Cyan
    $runArgs = @($File)
    if ($OutputFile) { $runArgs += $OutputFile }
    if ($ExtraArgs)  { $runArgs += $ExtraArgs }
    & .\bin\nexus_core.exe @runArgs
}
elseif ($Action -eq "test") {
    if (-not (Test-Path "bin/nexus_core.exe")) {
        Write-Host "VM binary not found. Triggering automated build..." -ForegroundColor Yellow
        if (-not (Test-Path "bin")) {
            New-Item -ItemType Directory -Path "bin" | Out-Null
        }
        gcc -O3 -o bin/nexus_core.exe src/vm/nexus_core.s src/vm/nexus_gpu.s -lws2_32
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Assembly Compilation failed!" -ForegroundColor Red
            exit 1
        }
    }
    Write-Host "Executing Nexus Regression Test Suite..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File .\run_all_tests.ps1
    $testExit = $LASTEXITCODE
    if ($testExit -eq 0) {
        Write-Host "All Regression Tests Passed." -ForegroundColor Green
    } else {
        Write-Host "Regression Test Suite Encountered Failures." -ForegroundColor Red
    }
    exit $testExit
}
elseif ($Action -eq "bench") {
    if (-not (Test-Path "bin/nexus_core.exe")) {
        Write-Host "VM binary not found. Triggering automated build..." -ForegroundColor Yellow
        if (-not (Test-Path "bin")) {
            New-Item -ItemType Directory -Path "bin" | Out-Null
        }
        gcc -O3 -o bin/nexus_core.exe src/vm/nexus_core.s src/vm/nexus_gpu.s -lws2_32
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Assembly Compilation failed!" -ForegroundColor Red
            exit 1
        }
    }
    Write-Host "Executing Continuous Multi-Workload Benchmarks..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File .\benchmarks\run_multi_benchmark.ps1
    exit $LASTEXITCODE
}
elseif ($Action -eq "aot") {
    if (-not $File) {
        Write-Host "Error: No source file specified for AOT compilation." -ForegroundColor Red
        Write-Host "Usage: .\nexus.ps1 aot <file.nx> [out.exe]"
        exit 1
    }

    if (-not (Test-Path $File)) {
        Write-Host "Error: Source file '$File' not found." -ForegroundColor Red
        exit 1
    }

    $outTarget = $OutputFile
    if (-not $outTarget) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($File)
        $outTarget = "$baseName.exe"
    }

    # Ensure VM is built
    if (-not (Test-Path "bin/nexus_core.exe")) {
        Write-Host "Building Nexus Baremetal VM..." -ForegroundColor Yellow
        if (-not (Test-Path "bin")) {
            New-Item -ItemType Directory -Path "bin" | Out-Null
        }
        gcc -O3 -o bin/nexus_core.exe src/vm/nexus_core.s src/vm/nexus_gpu.s -lws2_32
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Assembly Compilation failed!" -ForegroundColor Red
            exit 1
        }
    }

    if (-not (Test-Path "src/compiler/compiler_full.nxasm")) {
        Write-Host "Error: Compiler assembly 'src/compiler/compiler_full.nxasm' not found." -ForegroundColor Red
        exit 1
    }

    Write-Host "AOT Compiling $File -> $outTarget..." -ForegroundColor Cyan

    $fullVmPath = (Resolve-Path "bin/nexus_core.exe").Path -replace '\\', '/'
    $fullCompilerPath = (Resolve-Path "src/compiler/compiler_full.nxasm").Path -replace '\\', '/'
    $fullSourcePath = (Resolve-Path $File).Path -replace '\\', '/'
    $hasStdlib = Test-Path "lib/stdlib.nx"
    $fullStdlibPath = if ($hasStdlib) { (Resolve-Path "lib/stdlib.nx").Path -replace '\\', '/' } else { "" }

    $tempId = [System.Guid]::NewGuid().ToString("N").Substring(0, 8)
    $rcPath = "$env:TEMP\nexus_aot_$tempId.rc"
    $resObjPath = "$env:TEMP\nexus_aot_$tempId.res.o"

    $rcLines = @(
        "101 RCDATA `"$fullVmPath`"",
        "102 RCDATA `"$fullCompilerPath`"",
        "103 RCDATA `"$fullSourcePath`""
    )
    if ($hasStdlib) {
        $rcLines += "104 RCDATA `"$fullStdlibPath`""
    }

    [System.IO.File]::WriteAllLines($rcPath, $rcLines)

    # Compile resource script with windres
    windres $rcPath -O coff -o $resObjPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "AOT Error: Resource compilation failed with windres." -ForegroundColor Red
        Remove-Item -Force -ErrorAction SilentlyContinue $rcPath, $resObjPath
        exit 1
    }

    # Compile and link standalone executable with launcher
    $launcherSource = "src/aot/nexus_launcher.c"
    gcc -O2 -o $outTarget $launcherSource $resObjPath
    $gccCode = $LASTEXITCODE

    Remove-Item -Force -ErrorAction SilentlyContinue $rcPath, $resObjPath

    if ($gccCode -ne 0) {
        Write-Host "AOT Error: Failed to compile standalone executable." -ForegroundColor Red
        exit 1
    }

    Write-Host "AOT Compilation Successful: $outTarget" -ForegroundColor Green
}
else {
    Write-Host "Nexus Baremetal Developer CLI Toolkit" -ForegroundColor Cyan
    Write-Host "Usage:"
    Write-Host "  .\nexus.ps1 build                 - Builds bin/nexus_core.exe"
    Write-Host "  .\nexus.ps1 run <file.nx>         - Executes a .nx or .nxasm program"
    Write-Host "  .\nexus.ps1 test                  - Runs full regression test suite"
    Write-Host "  .\nexus.ps1 bench                 - Runs continuous performance benchmark suite"
    Write-Host "  .\nexus.ps1 aot <file.nx> [out]   - Ahead-Of-Time standalone zero-dependency .exe compiler"
}
