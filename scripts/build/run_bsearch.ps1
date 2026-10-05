param([int]$lines)
$content = Get-Content compiler_full.nxasm | Select-Object -First $lines
[IO.File]::WriteAllLines("temp.nxasm", $content, [Text.Encoding]::ASCII)
[IO.File]::AppendAllText("temp.nxasm", "HALT
", [Text.Encoding]::ASCII)
.\nexus_core.exe temp.nxasm
echo "Exit code: $LASTEXITCODE"
