# ==============================================================================
# Comprehensive Benchmark: C++ (-O3) .exe vs Nexus .nx vs Python .py
# ==============================================================================

Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "   BENCHMARK SHOWDOWN: C++ (-O3) .exe  vs  Nexus Baremetal .nx  vs  Python .py" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host ""

$workloads = @(
    @{
        Name     = "Loop Arithmetic (50,000,000 iters)"
        CppCmd   = ".\benchmarks\bench_loop_var_cpp_O3.exe"
        NxCmd    = ".\bin\nexus_core.exe benchmarks/bench_loop_var.nx"
        PyCmd    = "python benchmarks/bench_loop.py 50000000"
        Runs     = 5
    },
    @{
        Name     = "Recursion Call Stack (Fibonacci 35)"
        CppCmd   = ".\benchmarks\bench_fib_cpp_O3.exe"
        NxCmd    = ".\bin\nexus_core.exe benchmarks/bench_fib.nx"
        PyCmd    = "python benchmarks/bench_fib.py"
        Runs     = 5
    },
    @{
        Name     = "Array Mutation & Traversal (1,000,000 elems)"
        CppCmd   = ".\benchmarks\bench_array_cpp_O3.exe"
        NxCmd    = ".\bin\nexus_core.exe benchmarks/bench_array.nx"
        PyCmd    = "python benchmarks/bench_array.py"
        Runs     = 5
    },
    @{
        Name     = "Cryptographic HMAC-SHA256 (25,000 ops)"
        CppCmd   = ".\benchmarks\bench_hmac_cpp_O3.exe"
        NxCmd    = ".\bin\nexus_core.exe benchmarks/bench_hmac.nx"
        PyCmd    = "python benchmarks/bench_hmac.py"
        Runs     = 5
    },
    @{
        Name     = "String SHA-256 Hashing (50,000 hashes)"
        CppCmd   = ".\benchmarks\bench_string_cpp_O3.exe"
        NxCmd    = ".\bin\nexus_core.exe benchmarks/bench_string.nx"
        PyCmd    = "python benchmarks/bench_string.py"
        Runs     = 5
    },
    @{
        Name     = "Mathematical FMA Loop (20,000,000 iters)"
        CppCmd   = ".\benchmarks\bench_math_cpp_O3.exe"
        NxCmd    = ".\bin\nexus_core.exe benchmarks/bench_math.nx"
        PyCmd    = "python benchmarks/bench_math.py"
        Runs     = 3
    },
    @{
        Name     = "OOP Polymorphic Dispatch (5,000,000 calls)"
        CppCmd   = ".\benchmarks\bench_oop_cpp_O3.exe"
        NxCmd    = ".\bin\nexus_core.exe benchmarks/bench_oop.nx"
        PyCmd    = "python benchmarks/bench_oop.py"
        Runs     = 3
    }
)

function Measure-ExecTime([string]$cmd, [int]$runs) {
    # Warmup run
    Invoke-Expression "$cmd" 2>&1 | Out-Null
    $samples = @()
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Invoke-Expression "$cmd" 2>&1 | Out-Null
        $sw.Stop()
        $samples += $sw.Elapsed.TotalMilliseconds
    }
    return [Math]::Round(($samples | Measure-Object -Average).Average, 2)
}

$results = @()

foreach ($w in $workloads) {
    Write-Host ("--> Benchmarking: {0} (averaging {1} runs)..." -f $w.Name, $w.Runs) -ForegroundColor Yellow
    $tCpp = Measure-ExecTime $w.CppCmd $w.Runs
    $tNx  = Measure-ExecTime $w.NxCmd $w.Runs
    $tPy  = Measure-ExecTime $w.PyCmd $w.Runs

    $speedupVsCpp = [Math]::Round(($tCpp / $tNx), 2)
    $speedupVsPy  = [Math]::Round(($tPy / $tNx), 2)

    $results += [PSCustomObject]@{
        Workload       = $w.Name
        Cpp_O3_ms      = $tCpp
        Nexus_nx_ms    = $tNx
        Python_py_ms   = $tPy
        Nexus_vs_Cpp   = ("{0}x" -f $speedupVsCpp)
        Nexus_vs_Py    = ("{0}x faster" -f $speedupVsPy)
    }
}

Write-Host ""
Write-Host "================================== BENCHMARK RESULTS SUMMARY ==================================" -ForegroundColor Cyan
$results | Format-Table -AutoSize Workload, Cpp_O3_ms, Nexus_nx_ms, Python_py_ms, Nexus_vs_Cpp, Nexus_vs_Py

# Export as JSON or CSV for artifact creation
$results | Export-Clixml -Path "benchmarks/benchmark_results.xml"
