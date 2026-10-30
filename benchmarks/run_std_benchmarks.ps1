# ==============================================================================
# Nexus Baremetal - Standard Library Unified Benchmark Runner
# Executes and verifies all 8 dedicated standard module benchmark suites:
# 1. bench_std_stdlib.nx   (stdlib.nx: Math, String, Array, Crypto, Channel, System)
# 2. bench_std_data.nx     (stddata.nx: NDArray, Series, DataFrame)
# 3. bench_std_gpu.nx      (stdgpu.nx: Direct PTX Driver, GEMM, Memory, Transfer)
# 4. bench_std_tensor.nx   (stdtensor.nx: TensorOps, TensorMath, TensorNN)
# 5. bench_std_torch.nx    (stdtorch.nx: Autograd DAG, Linear, FlashAttention, QuantGEMM)
# 6. bench_std_lsp.nx      (stdlsp.nx: Protocol, Diagnostics, Completions, Hover/Def)
# 7. bench_std_pkg.nx      (stdpkg.nx: PackageManifest, PackageLockfile, Verification)
# 8. bench_std_profile.nx  (stdprofile.nx: ProfileRecord, Profiler.benchmark, Summary)
# ==============================================================================

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "NEXUS BAREMETAL STANDARD LIBRARY BENCHMARK SUITE RUNNER" -ForegroundColor Cyan
Write-Host "Rule: Every function execution time < native reference runtime" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

$benchmarks = @(
    @{ Name = "stdlib";   File = "benchmarks/bench_std_stdlib.nx" },
    @{ Name = "stddata";  File = "benchmarks/bench_std_data.nx" },
    @{ Name = "stdgpu";   File = "benchmarks/bench_std_gpu.nx" },
    @{ Name = "stdtensor";File = "benchmarks/bench_std_tensor.nx" },
    @{ Name = "stdtorch"; File = "benchmarks/bench_std_torch.nx" },
    @{ Name = "stdlsp";   File = "benchmarks/bench_std_lsp.nx" },
    @{ Name = "stdpkg";   File = "benchmarks/bench_std_pkg.nx" },
    @{ Name = "stdprofile";File = "benchmarks/bench_std_profile.nx" },
    @{ Name = "stddl";    File = "benchmarks/bench_std_dl.nx" },
    @{ Name = "stdllm";   File = "benchmarks/bench_std_llm.nx" },
    @{ Name = "stdllm_p4";File = "benchmarks/bench_std_llm_phase4.nx" },
    @{ Name = "stdllm_p5";File = "benchmarks/bench_std_llm_phase5.nx" },
    @{ Name = "stdgfx";   File = "benchmarks/bench_std_gfx.nx" }
)

$passed = 0
$failed = 0
$totalDuration = 0.0

foreach ($b in $benchmarks) {
    Write-Host "`n>>> Running $($b.Name) Benchmark ($($b.File))..." -ForegroundColor Yellow
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $out = .\bin\nexus_core.exe $b.File 2>&1
    $sw.Stop()
    $code = $LASTEXITCODE
    $outStr = $out -join "`n"

    $durationMs = [math]::Round($sw.Elapsed.TotalMilliseconds, 2)
    $totalDuration += $durationMs

    Write-Host $outStr

    if ($code -eq 0 -and $outStr -match "EXCEED NATIVE") {
        Write-Host ">>> RESULT: $($b.Name) [PASS < NATIVE REFERENCE] (Elapsed: $durationMs ms)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host ">>> RESULT: $($b.Name) [FAIL] (Elapsed: $durationMs ms)" -ForegroundColor Red
        $failed++
    }
}

Write-Host "`n==================================================================" -ForegroundColor Cyan
Write-Host "BENCHMARK SUITE SUMMARY" -ForegroundColor Cyan
Write-Host "Total Suites Run: $($benchmarks.Count)"
Write-Host "Passed:           $passed" -ForegroundColor Green
Write-Host "Failed:           $failed" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
Write-Host "Total Wall Time:  $([math]::Round($totalDuration, 2)) ms"
Write-Host "==================================================================" -ForegroundColor Cyan

if ($failed -gt 0) {
    exit 1
}
