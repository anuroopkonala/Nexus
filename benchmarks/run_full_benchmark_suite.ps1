# ==============================================================================
# Nexus Baremetal - Master Benchmark Suite: Nexus vs C++ (-O2) vs Python 3 vs CUDA
# ==============================================================================

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "   NEXUS BAREMETAL COMPREHENSIVE BENCHMARK SUITE                     " -ForegroundColor Cyan
Write-Host "   Benchmarking Nexus vs Native C++ (-O2) vs Python 3 vs Native CUDA  " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$benchmarks = @(
    @{
        Category = "CPU Compute"
        Name     = "Loop Arithmetic (50,000,000 iters)"
        NexusCmd = ".\bin\nexus_core.exe benchmarks/bench_loop_var.nx"
        CppCmd   = ".\benchmarks\bench_loop_var_cpp.exe"
        PyCmd    = "python benchmarks/bench_loop.py 50000000"
        Runs     = 3
    },
    @{
        Category = "CPU Compute"
        Name     = "Recursive Call Stack (Fibonacci 35)"
        NexusCmd = ".\bin\nexus_core.exe benchmarks/bench_fib.nx"
        CppCmd   = ".\benchmarks\bench_fib_cpp.exe"
        PyCmd    = "python benchmarks/bench_fib.py"
        Runs     = 3
    },
    @{
        Category = "Memory & Collections"
        Name     = "Array Mutation & Traversal (1,000,000 elems)"
        NexusCmd = ".\bin\nexus_core.exe benchmarks/bench_array.nx"
        CppCmd   = ".\benchmarks\bench_array_cpp.exe"
        PyCmd    = "python benchmarks/bench_array.py"
        Runs     = 3
    },
    @{
        Category = "Cryptography"
        Name     = "HMAC-SHA256 (25,000 operations)"
        NexusCmd = ".\bin\nexus_core.exe benchmarks/bench_hmac.nx"
        CppCmd   = ".\benchmarks\bench_hmac_cpp.exe"
        PyCmd    = "python benchmarks/bench_hmac.py"
        Runs     = 3
    },
    @{
        Category = "String & Hash"
        Name     = "String SHA-256 (50,000 hashes)"
        NexusCmd = ".\bin\nexus_core.exe benchmarks/bench_string.nx"
        CppCmd   = ".\benchmarks\bench_string_cpp.exe"
        PyCmd    = "python benchmarks/bench_string.py"
        Runs     = 3
    }
)

function Measure-CommandTime([string]$cmd, [int]$runs) {
    # Warmup
    Invoke-Expression "$cmd" 2>&1 | Out-Null
    $times = @()
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Invoke-Expression "$cmd" 2>&1 | Out-Null
        $sw.Stop()
        $times += $sw.Elapsed.TotalMilliseconds
    }
    return [Math]::Round(($times | Measure-Object -Average).Average, 2)
}

$results = @()

foreach ($b in $benchmarks) {
    Write-Host ("--> Running: {0}..." -f $b.Name) -ForegroundColor Yellow
    $tNx  = Measure-CommandTime $b.NexusCmd $b.Runs
    $tCpp = Measure-CommandTime $b.CppCmd $b.Runs
    $tPy  = Measure-CommandTime $b.PyCmd $b.Runs

    $speedupVsCpp = [Math]::Round(($tCpp / $tNx), 2)
    $speedupVsPy  = [Math]::Round(($tPy / $tNx), 2)

    $results += [PSCustomObject]@{
        Category      = $b.Category
        Workload      = $b.Name
        NexusMs       = $tNx
        CppMs         = $tCpp
        PyMs          = $tPy
        VsCppSpeedup  = ("{0}x" -f $speedupVsCpp)
        VsPySpeedup   = ("{0}x" -f $speedupVsPy)
    }
}

Write-Host ""
Write-Host "============================= CPU BENCHMARK RESULTS =============================" -ForegroundColor Cyan
$results | Format-Table -AutoSize Workload, NexusMs, CppMs, PyMs, VsCppSpeedup, VsPySpeedup

# GPU Hardware Benchmarks
Write-Host "============================= GPU BENCHMARK RESULTS =============================" -ForegroundColor Cyan
Write-Host "--> Running GPU Subsystem Benchmarks..." -ForegroundColor Yellow
& .\bin\nexus_core.exe benchmarks/bench_stdgpu_performance.nx

Write-Host ""
Write-Host "--> Running Native CUDA C Baseline..." -ForegroundColor Yellow
& .\benchmarks\cuda_baseline.exe

Write-Host ""
Write-Host "Master Benchmark Suite Complete!" -ForegroundColor Green
