# Continuous Multi-Workload Benchmarking Suite: Nexus Baremetal vs C++ (-O2)
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "   NEXUS BAREMETAL CONTINUOUS MULTI-WORKLOAD BENCHMARKING SUITE      " -ForegroundColor Cyan
Write-Host "   Comparing Nexus Direct-Threaded VM against Native C++ (-O2)        " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$workloads = @(
    @{
        Name = "Loop Arithmetic (Constant Bound: 50,000,000)"
        CppExe = ".\benchmarks\bench_loop_const_cpp.exe"
        NxFile = "benchmarks/bench_loop_const.nx"
        MinRatio = 0.10
        MaxRatio = 1.15
    },
    @{
        Name = "Loop Arithmetic (Variable Bound: 50,000,000)"
        CppExe = ".\benchmarks\bench_loop_var_cpp.exe"
        NxFile = "benchmarks/bench_loop_var.nx"
        MinRatio = 0.10
        MaxRatio = 1.15
    },
    @{
        Name = "Recursion (Fibonacci 35)"
        CppExe = ".\benchmarks\bench_fib_cpp.exe"
        NxFile = "benchmarks/bench_fib.nx"
        MinRatio = 0.10
        MaxRatio = 1.15
    },
    @{
        Name = "Cryptographic HMAC-SHA256 (25,000 ops)"
        CppExe = ".\benchmarks\bench_hmac_cpp.exe"
        NxFile = "benchmarks/bench_hmac.nx"
        MinRatio = 0.10
        MaxRatio = 1.15
    },
    @{
        Name = "String Processing & SHA-256 (50,000 hashes)"
        CppExe = ".\benchmarks\bench_string_cpp.exe"
        NxFile = "benchmarks/bench_string.nx"
        MinRatio = 0.10
        MaxRatio = 1.15
    },
    @{
        Name = "TCP Network Loopback (10,000 round-trips)"
        CppExe = ".\benchmarks\bench_net_cpp.exe"
        NxFile = "benchmarks/bench_net.nx"
        MinRatio = 0.05
        MaxRatio = 1.15
    },
    @{
        Name = "Array Mutation & Traversal (1,000,000 elements)"
        CppExe = ".\benchmarks\bench_array_cpp.exe"
        NxFile = "benchmarks/bench_array.nx"
        MinRatio = 0.10
        MaxRatio = 1.15
    }
)

$results = @()
$allPass = $true

foreach ($w in $workloads) {
    Write-Host ("--> Benchmarking: {0}..." -f $w.Name) -ForegroundColor Yellow
    
    # Warmup
    & $w.CppExe | Out-Null
    & .\bin\nexus_core.exe $w.NxFile | Out-Null
    
    # Measure C++ (-O2)
    $cppTimes = @()
    for ($i = 0; $i -lt 5; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $w.CppExe | Out-Null
        $sw.Stop()
        $cppTimes += $sw.Elapsed.TotalMilliseconds
    }
    
    # Measure Nexus VM
    $nxTimes = @()
    for ($i = 0; $i -lt 5; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & .\bin\nexus_core.exe $w.NxFile | Out-Null
        $sw.Stop()
        $nxTimes += $sw.Elapsed.TotalMilliseconds
    }
    
    $avgCpp = ($cppTimes | Measure-Object -Average).Average
    $avgNx  = ($nxTimes | Measure-Object -Average).Average
    $ratio  = [Math]::Round(($avgNx / $avgCpp), 2)
    $status = if (($ratio -ge $w.MinRatio) -and ($ratio -le $w.MaxRatio)) { "PASS" } else { "FAIL" }
    if ($status -eq "FAIL") { $allPass = $false }
    
    $results += [PSCustomObject]@{
        Workload   = $w.Name
        CppAvgMs   = [Math]::Round($avgCpp, 2)
        NexusAvgMs = [Math]::Round($avgNx, 2)
        Ratio      = [Math]::Round($ratio, 2)
        Target     = ("{0:N2}x - {1:N2}x" -f $w.MinRatio, $w.MaxRatio)
        Status     = $status
    }
}

Write-Host ""
Write-Host "========================== BENCHMARK RESULTS ==========================" -ForegroundColor Cyan
$results | Format-Table -AutoSize

if ($allPass) {
    Write-Host "ALL BENCHMARK WORKLOAD CONSTRAINTS PASSED: Nexus is strictly between 0.10x and 1.15x of C++ time!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "SOME BENCHMARK CONSTRAINTS FAILED!" -ForegroundColor Red
    exit 1
}
