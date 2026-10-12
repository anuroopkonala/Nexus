Write-Host "Running All Nexus Baremetal Tests..." -ForegroundColor Cyan

$tests = @(
    "tests/nx/test_simple.nx",
    "tests/nx/test_let.nx",
    "tests/nx/test_if.nx",
    "tests/nx/test_if2.nx",
    "tests/nx/test_math.nx",
    "tests/nx/test_dict.nx",
    "tests/nx/test_fn_params.nx",
    "tests/nx/test_classes.nx",
    "tests/nx/test_class_fields.nx",
    "tests/nx/test_stdlib.nx",
    "tests/nx/lexer_test.nx",
    "tests/nx/test_array_mutation.nx",
    "tests/nx/test_string_concat.nx",
    "tests/nx/test_stdlib_expanded.nx"
)

$passed = 0
$failed = 0

foreach ($t in $tests) {
    Write-Host "Running $t..." -NoNewline
    $out = .\bin\nexus_core.exe $t 2>&1
    if ($LASTEXITCODE -eq 0 -and $out -match "VM execution complete") {
        Write-Host " [PASS]" -ForegroundColor Green
        $passed++
    } else {
        Write-Host " [FAIL]" -ForegroundColor Red
        Write-Host $out
        $failed++
    }
}

Write-Host "Results: $passed Passed, $failed Failed." -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
if ($failed -gt 0) { exit 1 }
