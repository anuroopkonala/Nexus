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
    "tests/nx/test_stdlib_expanded.nx",
    "tests/nx/test_modulo.nx",
    "tests/nx/test_string_compare.nx",
    "tests/nx/test_builtins_expanded.nx",
    "tests/nx/test_logical_compound.nx",
    "tests/nx/test_array_methods.nx",
    "tests/nx/test_for_in.nx",
    "tests/nx/test_file_io.nx",
    "tests/nx/test_step1_methods.nx",
    "tests/nx/test_step2_control_flow.nx",
    "tests/nx/test_step3_cybersec.nx",
    "tests/nx/test_step4_optimizations.nx",
    "tests/nx/test_optionA_system.nx",
    "tests/nx/test_optionB_crypto.nx",
    "tests/nx/test_optionC_network.nx",
    "tests/nx/test_memory_safety.nx",
    "tests/nx/test_print_all.nx",
    "tests/nx/test_stdlib_complete.nx",
    "tests/nx/test_oop_model3.nx",
    "tests/nx/test_gpu.nx",
    "tests/nx/test_class_gpu.nx",
    "tests/nx/test_stdgpu_phase1.nx",
    "tests/nx/test_stdgpu_phase2.nx",
    "tests/nx/test_stdgpu_phase3.nx",
    "tests/nx/test_stdgpu_phase4.nx",
    "tests/nx/test_universal_dot_syntax.nx",
    "tests/nx/test_limits_args.nx",
    "tests/nx/test_limits_recursion.nx",
    "tests/nx/test_limits_literals.nx",
    "tests/nx/test_limits_class.nx",
    "tests/nx/test_limits_gpu.nx",
    "tests/nx/test_stdtensor.nx",
    "tests/nx/test_stddata.nx",
    "tests/nx/test_stdtorch.nx"
)

$passed = 0
$failed = 0

foreach ($t in $tests) {
    Write-Host "Running $t..." -NoNewline
    $out = .\bin\nexus_core.exe $t 2>&1
    $code = $LASTEXITCODE
    $outStr = $out -join "`n"
    if ($code -eq 0 -and $outStr -match "VM execution complete") {
        Write-Host " [PASS]" -ForegroundColor Green
        $passed++
    } else {
        Write-Host " [FAIL]" -ForegroundColor Red
        Write-Host $out
        $failed++
    }
}

Write-Host "`nRunning Nexus Diagnostic Error Reporting Suite..." -ForegroundColor Cyan

# Test E0001: Syntax Error
Write-Host "Running tests/nx/test_err_syntax.nx (expecting error[E0001])..." -NoNewline
$errOut1 = .\bin\nexus_core.exe tests/nx/test_err_syntax.nx 2>&1
$errCode1 = $LASTEXITCODE
$errStr1 = $errOut1 -join "`n"
if ($errCode1 -ne 0 -and $errStr1 -match "error\[E0001\]") {
    Write-Host " [PASS]" -ForegroundColor Green
    $passed++
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host $errStr1
    $failed++
}

# Test E0502: Unresolved Method / Null Function Call
Write-Host "Running tests/nx/test_err_unresolved.nx (expecting error[E0502])..." -NoNewline
$errOut2 = .\bin\nexus_core.exe tests/nx/test_err_unresolved.nx 2>&1
$errCode2 = $LASTEXITCODE
$errStr2 = $errOut2 -join "`n"
if ($errCode2 -ne 0 -and $errStr2 -match "error\[E0502\]") {
    Write-Host " [PASS]" -ForegroundColor Green
    $passed++
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host $errStr2
    $failed++
}

# Test E0002: Unclosed String Literal
Write-Host "Running tests/nx/test_err_string.nx (expecting error[E0002])..." -NoNewline
$errOut3 = .\bin\nexus_core.exe tests/nx/test_err_string.nx 2>&1
$errCode3 = $LASTEXITCODE
$errStr3 = $errOut3 -join "`n"
if ($errCode3 -ne 0 -and $errStr3 -match "error\[E0002\]") {
    Write-Host " [PASS]" -ForegroundColor Green
    $passed++
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host $errStr3
    $failed++
}

# Test E0003: Unrecognized Character
Write-Host "Running tests/nx/test_err_char.nx (expecting error[E0003])..." -NoNewline
$errOut4 = .\bin\nexus_core.exe tests/nx/test_err_char.nx 2>&1
$errCode4 = $LASTEXITCODE
$errStr4 = $errOut4 -join "`n"
if ($errCode4 -ne 0 -and $errStr4 -match "error\[E0003\]") {
    Write-Host " [PASS]" -ForegroundColor Green
    $passed++
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host $errStr4
    $failed++
}

# Test E0102: Unclosed Delimiter
Write-Host "Running tests/nx/test_err_delim.nx (expecting error[E0102])..." -NoNewline
$errOut5 = .\bin\nexus_core.exe tests/nx/test_err_delim.nx 2>&1
$errCode5 = $LASTEXITCODE
$errStr5 = $errOut5 -join "`n"
if ($errCode5 -ne 0 -and $errStr5 -match "error\[E0102\]") {
    Write-Host " [PASS]" -ForegroundColor Green
    $passed++
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host $errStr5
    $failed++
}

# Test E0503: Division by Zero
Write-Host "Running tests/nx/test_err_divzero.nx (expecting error[E0503])..." -NoNewline
$errOut6 = .\bin\nexus_core.exe tests/nx/test_err_divzero.nx 2>&1
$errCode6 = $LASTEXITCODE
$errStr6 = $errOut6 -join "`n"
if ($errCode6 -ne 0 -and $errStr6 -match "error\[E0503\]") {
    Write-Host " [PASS]" -ForegroundColor Green
    $passed++
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host $errStr6
    $failed++
}

# Test W0001: Unreachable Dead Code Warning
Write-Host "Running tests/nx/test_warn_deadcode.nx (expecting warning[W0001])..." -NoNewline
$warnOut = .\bin\nexus_core.exe tests/nx/test_warn_deadcode.nx 2>&1
$warnCode = $LASTEXITCODE
$warnStr = $warnOut -join "`n"
if ($warnCode -eq 0 -and $warnStr -match "warning\[W0001\]") {
    Write-Host " [PASS]" -ForegroundColor Green
    $passed++
} else {
    Write-Host " [FAIL]" -ForegroundColor Red
    Write-Host $warnStr
    $failed++
}

Write-Host "`nResults: $passed Passed, $failed Failed." -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
if ($failed -gt 0) { exit 1 }
