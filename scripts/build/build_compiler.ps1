$content = Get-Content src/compiler/parser_lexer.nxasm, src/compiler/parser_utils.nxasm, src/compiler/parser_expr.nxasm, src/compiler/parser_stmt.nxasm, src/compiler/compiler_expr.nxasm, src/compiler/compiler_stmt.nxasm, src/compiler/compiler_main.nxasm
[IO.File]::WriteAllLines("src/compiler/compiler_full.nxasm", $content, [Text.Encoding]::ASCII)
Write-Host 'Compiler built successfully.'
