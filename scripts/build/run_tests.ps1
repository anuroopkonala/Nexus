$ErrorActionPreference = "Stop"

if (-not (Test-Path "nexus_core.exe")) {
    Write-Host "Compiling nexus_core.s..."
    gcc -g -O0 -no-pie nexus_core.s -o nexus_core.exe
}

# Backup boot.nxasm
$backupExists = $false
if (Test-Path "boot.nxasm") {
    Copy-Item "boot.nxasm" "boot.nxasm.bak" -Force
    $backupExists = $true
}

$tests = @(
    @{
        name = "test_math.nxasm"
        expected = "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...`n[Nexus Baremetal] Register output: 15.000000`n[Nexus Baremetal] Register output: 5.000000`n[Nexus Baremetal] Register output: 50.000000`n[Nexus Baremetal] Register output: 2.000000`n[Nexus Baremetal] Register output: 0.000000`n[Nexus Baremetal] Register output: 1.000000`n[Nexus Baremetal] Register output: 0.000000`n[Nexus Baremetal] Register output: 1.000000`n[Nexus Baremetal] VM execution complete."
    },
    @{
        name = "test_control_flow.nxasm"
        expected = "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...`n[Nexus Baremetal] Register output: 1.000000`n[Nexus Baremetal] Register output: 2.000000`n[Nexus Baremetal] VM execution complete."
    },
    @{
        name = "test_call_ret.nxasm"
        expected = "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...`n[Nexus Baremetal] Register output: 1.000000`n[Nexus Baremetal] Register output: 42.000000`n[Nexus Baremetal] Register output: 2.000000`n[Nexus Baremetal] VM execution complete."
    },
    @{
        name = "test_heap.nxasm"
        expected = "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...`n[Nexus Baremetal] Register output: 42.000000`n[Nexus Baremetal] VM execution complete."
    },
    @{
        name = "test_io.nxasm"
        expected = "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...`nA`nhello`nworld`n[Nexus Baremetal] VM execution complete."
    }
)

$allPassed = $true

foreach ($t in $tests) {
    Write-Host "Running $($t.name) ... " -NoNewline
    Copy-Item "tests\vm\$($t.name)" "boot.nxasm" -Force
    
    $output = .\nexus_core.exe
    $output = $output | Out-String
    $output = $output.Trim() -replace "`r`n", "`n"

    $expected = $t.expected.Trim() -replace "`r`n", "`n"

    if ($output -eq $expected) {
        Write-Host "PASS" -ForegroundColor Green
    } else {
        Write-Host "FAIL" -ForegroundColor Red
        Write-Host "--- Expected ---"
        Write-Host $expected
        Write-Host "--- Got ---"
        Write-Host $output
        $allPassed = $false
    }
}

if ($backupExists) {
    Copy-Item "boot.nxasm.bak" "boot.nxasm" -Force
    Remove-Item "boot.nxasm.bak" -Force
}

if ($allPassed) {
    Write-Host "`nAll tests passed successfully!" -ForegroundColor Green
} else {
    Write-Host "`nSome tests failed." -ForegroundColor Red
    exit 1
}
