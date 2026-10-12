param(
    [string]$Action,
    [string]$File
)

if ($Action -eq "build") {
    Write-Host "Building Nexus Baremetal VM..."
    gcc -o bin/nexus_core.exe src/vm/nexus_core.s
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Assembly Compilation failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Build Successful." -ForegroundColor Green
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
    .\bin\nexus_core.exe $File
}
else {
    Write-Host "Usage:"
    Write-Host "  .\nexus.ps1 build"
    Write-Host "  .\nexus.ps1 run <file.nx>"
}
