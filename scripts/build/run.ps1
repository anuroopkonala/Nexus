$c = Get-Content "nexus_core.s" -Raw -Encoding UTF8
$c = $c -replace 'op_dict_set:', "fmt_dict_set: .asciz `"DEBUG: DICT_SET key='%s' val=%f\n`"`nop_dict_set:"
$d = @"
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    sub rsp, 40
    lea rcx, [rip + fmt_dict_set]
    mov rdx, r11
    movq r8, xmm0
    movsd [rsp+32], xmm0
    call printf
    add rsp, 40
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
"@
$c = $c -replace 'movsd xmm0, \[rdi \+ r9 \* 8\]\r?\n    mov r13, \[r10\+8\]', "movsd xmm0, [rdi + r9 * 8]`n$d`n    mov r13, [r10+8]"

$c = $c -replace 'op_dict_get:', "fmt_dict_get: .asciz `"DEBUG: DICT_GET key='%s' res=%f\n`"`nop_dict_get:"
$d2 = @"
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    sub rsp, 40
    lea rcx, [rip + fmt_dict_get]
    mov rdx, r11
    movq r8, xmm0
    movsd [rsp+32], xmm0
    call printf
    add rsp, 40
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
"@
$c = $c -replace 'movsd xmm0, \[r13\+16\]\r?\n    movsd \[rdi \+ r12 \* 8\], xmm0\r?\n    NEXT\r?\n\.dict_get_not_found', "movsd xmm0, [r13+16]`n$d2`n    movsd [rdi + r12 * 8], xmm0`n    NEXT`n.dict_get_not_found"

[IO.File]::WriteAllText("nexus_core.s", $c, [System.Text.Encoding]::UTF8)
