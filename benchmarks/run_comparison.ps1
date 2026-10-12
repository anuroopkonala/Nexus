Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  NEXUS BAREMETAL vs C++ vs PYTHON LOOP SPEED BENCHMARK  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

function Measure-CmdMs($ScriptBlock, $Runs = 3) {
    $times = @()
    for ($r = 0; $r -lt $Runs; $r++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $ScriptBlock | Out-Null
        $sw.Stop()
        $times += $sw.Elapsed.TotalMilliseconds
    }
    # Return average of runs
    $avg = ($times | Measure-Object -Average).Average
    return [Math]::Round($avg, 2)
}

$tests = @(
    @{ Name = "100,000 Iterations";   N = 100000;  NxFile = "benchmarks/bench_loop.nx" },
    @{ Name = "1,000,000 Iterations"; N = 1000000; NxFile = "benchmarks/bench_loop_1m.nx" },
    @{ Name = "5,000,000 Iterations"; N = 5000000; NxFile = "benchmarks/bench_loop_5m.nx" }
)

$results = @()

foreach ($t in $tests) {
    Write-Host "`nBenchmarking $($t.Name)..." -ForegroundColor Yellow
    $n = $t.N
    $nxFile = $t.NxFile

    # 1. C++ -O2
    $cpp_O2_ms = Measure-CmdMs { .\benchmarks\bench_cpp_O2.exe $n }
    Write-Host "  C++ (-O2):         $cpp_O2_ms ms" -ForegroundColor Green

    # 2. C++ -O0
    $cpp_O0_ms = Measure-CmdMs { .\benchmarks\bench_cpp_O0.exe $n }
    Write-Host "  C++ (-O0):         $cpp_O0_ms ms" -ForegroundColor Gray

    # 3. Nexus Baremetal (including lex/parse/compile/execute)
    $nexus_ms = Measure-CmdMs { .\bin\nexus_core.exe $nxFile }
    Write-Host "  Nexus Baremetal:   $nexus_ms ms" -ForegroundColor Cyan

    # 4. Python 3.13
    $py_ms = Measure-CmdMs { python benchmarks/bench_loop.py $n }
    Write-Host "  Python 3.13:       $py_ms ms" -ForegroundColor Magenta

    $results += [PSCustomObject]@{
        Workload         = $t.Name
        "C++ (-O2)"      = "$cpp_O2_ms ms"
        "C++ (-O0)"      = "$cpp_O0_ms ms"
        "Nexus VM"       = "$nexus_ms ms"
        "Python 3.13"    = "$py_ms ms"
        "Nexus vs Python"= "$([Math]::Round($py_ms / [Math]::Max($nexus_ms, 0.001), 2))x"
        "C++ vs Nexus"   = "$([Math]::Round($nexus_ms / [Math]::Max($cpp_O2_ms, 0.001), 1))x"
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "                    FINAL COMPARISON RESULTS              " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
$results | Format-Table -AutoSize
