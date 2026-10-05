Write-Host "Running All Tests..."
.\nexus.ps1 build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed. Tests aborted." -ForegroundColor Red
    exit 1
}

Write-Host "--- Testing Math ---"
$outMath = .\nexus.ps1 run tests/nx/test_math.nx
Write-Host $outMath

Write-Host "--- Testing Stdlib ---"
$outStdlib = .\nexus.ps1 run tests/nx/test_stdlib.nx
Write-Host $outStdlib

Write-Host "All tests passed successfully!" -ForegroundColor Green
