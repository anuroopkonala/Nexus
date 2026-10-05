$c = Get-Content "nexus_core.s" -Raw -Encoding UTF8
$c = $c -replace '(?s)fmt_dict_set:.*?\n\.dict_set_loop:', "op_dict_set:`n    mov r12, [rsi]`n    mov r8,  [rsi+8]`n    mov r9,  [rsi+16]`n    add rsi, 24`n    movsd xmm0, [rdi + r12 * 8]`n    cvttsd2si r10, xmm0`n    mov r11, [rbx + r8 * 8]`n    movsd xmm0, [rdi + r9 * 8]`n    mov r13, [r10+8]`n.dict_set_loop:"
$c = $c -replace '(?s)\.dict_get_found:.*?\n    NEXT', ".dict_get_found:`n    movsd xmm0, [r13+16]`n    movsd [rdi + r12 * 8], xmm0`n    NEXT"
$c = $c -replace '(?s)fmt_dict_get:.*?cmp r10, 0', "op_dict_get:`n    mov r12, [rsi]`n    mov r8,  [rsi+8]`n    mov r9,  [rsi+16]`n    add rsi, 24`n    movsd xmm0, [rdi + r8 * 8]`n    cvttsd2si r10, xmm0`n    cmp r10, 0"
$c = $c -replace '(?s)    mov r11, \[rbx \+ r9 \* 8\].*?\n\.dict_get_loop:', "    mov r11, [rbx + r9 * 8]`n    mov r13, [r10+8]`n.dict_get_loop:"
[IO.File]::WriteAllText("nexus_core.s", $c, [System.Text.Encoding]::UTF8)
