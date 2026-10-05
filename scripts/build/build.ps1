Write-Host "Building Nexus Baremetal VM..."
gcc -o nexus_core.exe nexus_core.s

if ($LASTEXITCODE -ne 0) {
    Write-Host "Assembly Compilation failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build Successful. Booting VM..." -ForegroundColor Green
.\nexus_core.exe
