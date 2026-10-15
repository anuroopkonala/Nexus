Write-Host "=== Benchmarking Loop Workload (50,000,000 Iterations) ===" -ForegroundColor Cyan

# Warmup
.\benchmarks\bench_loop_cpp.exe | Out-Null
.\bin\nexus_core.exe benchmarks/bench_loop.nx | Out-Null

$cppTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $out = .\benchmarks\bench_loop_cpp.exe
    $sw.Stop()
    $cppTimes += $sw.Elapsed.TotalMilliseconds
}

$nxTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $out = .\bin\nexus_core.exe benchmarks/bench_loop.nx
    $sw.Stop()
    $nxTimes += $sw.Elapsed.TotalMilliseconds
}

$avgCpp = ($cppTimes | Measure-Object -Average).Average
$avgNx  = ($nxTimes | Measure-Object -Average).Average
$ratio  = $avgNx / $avgCpp

Write-Host ("C++ (-O2) Average Time : {0:N2} ms" -f $avgCpp) -ForegroundColor Yellow
Write-Host ("Nexus VM Average Time  : {0:N2} ms" -f $avgNx) -ForegroundColor Green
Write-Host ("Ratio (Nexus / C++)    : {0:N2}x" -f $ratio) -ForegroundColor Cyan

if (($ratio -ge 0.10) -and ($ratio -le 1.15)) {
    Write-Host "Constraint PASS: Nexus is strictly between 0.10x and 1.15x of C++ time!" -ForegroundColor Green
} else {
    Write-Host "Constraint FAIL: Nexus is outside 0.10x - 1.15x of C++ time!" -ForegroundColor Red
}
