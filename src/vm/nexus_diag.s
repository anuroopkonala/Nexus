	.file	"nexus_diag.c"
	.intel_syntax noprefix
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "\33[1;33m\0"
.LC1:
	.ascii "\33[1;31m\0"
.LC2:
	.ascii "\12%s%s\33[0m: \33[1m%s\33[0m\12\0"
	.align 8
.LC3:
	.ascii "  \33[1;34m-->\33[0m \33[1;37m%s:%d:%d\33[0m\12\0"
.LC4:
	.ascii "   \33[1;34m|\33[0m\0"
.LC5:
	.ascii " \33[1;34m%3d |\33[0m %s\12\0"
.LC6:
	.ascii "   \33[1;34m|\33[0m %s%s%s\33[0m\12\0"
	.align 8
.LC7:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: %s\12\0"
	.align 8
.LC8:
	.ascii "   \33[1;34m=\33[0m \33[1mhelp\33[0m: %s\12\12\0"
	.text
	.p2align 4
	.globl	"print_diagnostic"
	.def	"print_diagnostic";	.scl	2;	.type	32;	.endef
"print_diagnostic":
	push	r15
	push	r14
	mov	r14d, ecx
	push	r13
	push	r12
	push	rbp
	mov	rbp, r8
	push	rdi
	mov	rdi, rdx
	push	rsi
	mov	rsi, r9
	push	rbx
	sub	rsp, 1576
	mov	rcx, QWORD PTR 1696[rsp]
	mov	ebx, DWORD PTR 1688[rsp]
	movzx	eax, BYTE PTR [rcx]
	test	al, al
	je	.L14
	cmp	al, 13
	je	.L14
	lea	r12, 32[rsp]
	add	rcx, 1
	xor	edx, edx
	mov	r8, r12
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L41:
	cmp	edx, 500
	je	.L2
	mov	BYTE PTR [r8], al
	movzx	eax, BYTE PTR [rcx]
	add	edx, 1
	add	r8, 1
	add	rcx, 1
	test	al, al
	je	.L2
	cmp	al, 13
	je	.L2
.L3:
	cmp	al, 10
	jne	.L41
.L2:
	test	ebx, ebx
	mov	r8d, 1
	mov	eax, 480
	mov	BYTE PTR 32[rsp+rdx], 0
	cmovg	r8d, ebx
	lea	r13, 544[rsp]
	sub	r8d, 1
	cmp	r8d, eax
	cmovg	r8d, eax
	mov	r15d, r8d
	cmp	ebx, 1
	jle	.L7
	mov	r8, r15
	mov	edx, 32
	mov	rcx, r13
	call	"memset"
.L7:
	mov	eax, DWORD PTR 1704[rsp]
	lea	rdx, 1056[rsp]
	mov	BYTE PTR 544[rsp+r15], 0
	test	eax, eax
	mov	eax, 1
	cmovg	eax, DWORD PTR 1704[rsp]
	mov	ecx, eax
	xor	eax, eax
	.p2align 5
	.p2align 4
	.p2align 3
.L8:
	mov	r9d, eax
	add	eax, 1
	mov	BYTE PTR [rdx], 94
	add	rdx, 1
	cmp	ecx, eax
	jle	.L16
	cmp	eax, 450
	jne	.L8
.L16:
	mov	BYTE PTR 1056[rsp+rax], 32
	mov	rax, QWORD PTR 1712[rsp]
	lea	ecx, 2[r9]
	movzx	edx, BYTE PTR [rax]
	test	dl, dl
	je	.L10
	mov	r8d, 498
	lea	eax, 3[r9]
	lea	rcx, 1056[rsp+rcx]
	sub	r8d, r9d
	mov	r9, QWORD PTR 1712[rsp]
	sub	rcx, rax
	add	r8, rax
	sub	r9, rax
	.p2align 5
	.p2align 4
	.p2align 3
.L12:
	mov	BYTE PTR [rcx+rax], dl
	movzx	edx, BYTE PTR 1[r9+rax]
	test	dl, dl
	je	.L42
	add	rax, 1
	cmp	rax, r8
	jne	.L12
	mov	ecx, 500
.L10:
	test	r14d, r14d
	lea	rax, .LC0[rip]
	mov	r9, rbp
	mov	r8, rdi
	lea	r15, .LC1[rip]
	mov	BYTE PTR 1056[rsp+rcx], 0
	lea	rcx, .LC2[rip]
	cmovne	r15, rax
	mov	rdx, r15
	call	"printf"
	mov	r8d, DWORD PTR 1680[rsp]
	mov	r9d, ebx
	mov	rdx, rsi
	lea	rcx, .LC3[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	mov	edx, DWORD PTR 1680[rsp]
	mov	r8, r12
	lea	rcx, .LC5[rip]
	call	"printf"
	lea	r9, 1056[rsp]
	mov	r8, r15
	mov	rdx, r13
	lea	rcx, .LC6[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	mov	rdx, QWORD PTR 1720[rsp]
	lea	rcx, .LC7[rip]
	call	"printf"
	mov	rdx, QWORD PTR 1728[rsp]
	lea	rcx, .LC8[rip]
	call	"printf"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rcx, rax
	call	"fflush"
	add	rsp, 1576
	pop	rbx
	pop	rsi
	pop	rdi
	pop	rbp
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	ret
	.p2align 4,,10
	.p2align 3
.L42:
	mov	ecx, eax
	jmp	.L10
.L14:
	xor	edx, edx
	lea	r12, 32[rsp]
	jmp	.L2
	.section .rdata,"dr"
.LC9:
	.ascii "error[E0101]\0"
	.align 8
.LC10:
	.ascii "syntax error: unmatched parenthesis\0"
.LC11:
	.ascii "error[E0102]\0"
	.align 8
.LC12:
	.ascii "syntax error: unclosed delimiter\0"
.LC13:
	.ascii "rb\0"
	.align 8
.LC14:
	.ascii "lexical error: unclosed string literal\0"
.LC15:
	.ascii "error[E0002]\0"
	.align 8
.LC16:
	.ascii "add a matching double quote '\"' before the end of the line\0"
	.align 8
.LC17:
	.ascii "string literal was opened with '\"' but never terminated before newline or EOF\0"
	.align 8
.LC18:
	.ascii "string literal is missing closing quote\0"
	.align 8
.LC19:
	.ascii "syntax error: expected expression after '='\0"
.LC20:
	.ascii "error[E0001]\0"
	.align 8
.LC21:
	.ascii "provide a value or expression, e.g., 'let x = 0;'\0"
	.align 8
.LC22:
	.ascii "assignment operator '=' requires a right-hand side expression\0"
.LC23:
	.ascii "expected expression here\0"
	.align 8
.LC24:
	.ascii "unexpected closing delimiter '%c'\0"
	.align 8
.LC25:
	.ascii "check delimiter matching and remove unmatched '%c'\0"
	.align 8
.LC26:
	.ascii "syntax error: mismatched closing delimiter\0"
	.align 8
.LC27:
	.ascii "delimiter closing does not match any open delimiter\0"
	.align 8
.LC28:
	.ascii "lexical error: malformed number literal\0"
.LC29:
	.ascii "error[E0004]\0"
	.align 8
.LC30:
	.ascii "format as a valid integer or floating-point number, e.g., '12.34'\0"
	.align 8
.LC31:
	.ascii "numbers may only contain a single decimal point\0"
	.align 8
.LC32:
	.ascii "invalid floating-point literal with multiple decimal points\0"
	.align 8
.LC33:
	.ascii "character '%c' is not recognized in Nexus syntax\0"
	.align 8
.LC34:
	.ascii "lexical error: unrecognized character\0"
.LC35:
	.ascii "error[E0003]\0"
	.align 8
.LC36:
	.ascii "remove the invalid character or replace with a supported operator\0"
	.align 8
.LC37:
	.ascii "character is not a valid identifier or operator in Nexus\0"
.LC38:
	.ascii "return\0"
	.align 8
.LC39:
	.ascii "unreachable statement detected\0"
.LC40:
	.ascii "warning[W0001]\0"
	.align 8
.LC41:
	.ascii "remove the unreachable statement or move it before 'return'\0"
	.align 8
.LC42:
	.ascii "statement follows a 'return' statement in the same block\0"
	.align 8
.LC43:
	.ascii "this code will never be executed\0"
	.align 8
.LC44:
	.ascii "delimiter was opened here but never closed before end of file\0"
	.align 8
.LC45:
	.ascii "unclosed '%c', expected matching '%c'\0"
	.align 8
.LC46:
	.ascii "add matching closing delimiter '%c'\0"
	.text
	.p2align 4
	.globl	"scan_and_diagnose_preflight"
	.def	"scan_and_diagnose_preflight";	.scl	2;	.type	32;	.endef
"scan_and_diagnose_preflight":
	test	rcx, rcx
	je	.L222
	sub	rsp, 312
	lea	rdx, .LC13[rip]
	mov	QWORD PTR 264[rsp], rbx
	mov	rbx, rcx
	mov	QWORD PTR 280[rsp], rdi
	call	"fopen"
	mov	rdi, rax
	test	rax, rax
	je	.L44
	mov	r8d, 2
	xor	edx, edx
	mov	rcx, rax
	mov	QWORD PTR 288[rsp], rbp
	call	"fseek"
	mov	rcx, rdi
	call	"ftell"
	xor	r8d, r8d
	xor	edx, edx
	mov	rcx, rdi
	mov	ebp, eax
	call	"fseek"
	lea	eax, -1[rbp]
	cmp	eax, 33554431
	ja	.L235
	lea	ecx, 16[rbp]
	mov	QWORD PTR 272[rsp], rsi
	call	"malloc"
	mov	rsi, rax
	test	rax, rax
	je	.L236
	mov	r8, rbp
	mov	r9, rdi
	mov	edx, 1
	mov	rcx, rax
	call	"fread"
	mov	rcx, rdi
	call	"fclose"
	mov	BYTE PTR [rsi+rbp], 0
	movsx	r8d, BYTE PTR [rsi]
	mov	DWORD PTR "delim_top"[rip], 0
	test	r8b, r8b
	je	.L49
	mov	QWORD PTR 304[rsp], r15
	mov	r10, rsi
	mov	rdi, rsi
	mov	r11d, 1
	lea	rbp, .L52[rip]
	.p2align 4
	.p2align 3
.L120:
	lea	eax, -9[r8]
	cmp	al, 38
	ja	.L188
	movzx	eax, al
	movsxd	rax, DWORD PTR 0[rbp+rax*4]
	add	rax, rbp
	jmp	rax
	.section .rdata,"dr"
	.align 4
.L52:
	.long	.L125-.L52
	.long	.L55-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L125-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L125-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L58-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L188-.L52
	.long	.L51-.L52
	.text
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L58:
	movsx	r8d, BYTE PTR 1[r10]
	add	r10, 1
	test	r8b, r8b
	je	.L60
	cmp	r8b, 10
	jne	.L58
.L56:
	test	r8b, r8b
	jne	.L120
	.p2align 4
	.p2align 3
.L60:
	mov	eax, DWORD PTR "delim_top"[rip]
	test	eax, eax
	jle	.L228
	sub	eax, 1
	mov	QWORD PTR 296[rsp], r14
	lea	rdx, [rax+rax*2]
	lea	rax, "delim_stack"[rip]
	lea	rax, [rax+rdx*8]
	movsx	r8d, BYTE PTR [rax]
	mov	r15d, DWORD PTR 4[rax]
	mov	r11d, DWORD PTR 8[rax]
	mov	r14, QWORD PTR 16[rax]
	cmp	r8b, 40
	je	.L121
	cmp	r8b, 91
	mov	edi, 93
	mov	eax, 125
	mov	DWORD PTR 112[rsp], r11d
	cmove	eax, edi
	lea	rdi, 128[rsp]
	lea	rdx, .LC45[rip]
	mov	rcx, rdi
	lea	rbp, 192[rsp]
	mov	r9d, eax
	mov	DWORD PTR 104[rsp], eax
	call	"sprintf"
	mov	r8d, DWORD PTR 104[rsp]
	lea	rdx, .LC46[rip]
	mov	rcx, rbp
	call	"sprintf"
	mov	r11d, DWORD PTR 112[rsp]
	lea	rdx, .LC11[rip]
	lea	r8, .LC12[rip]
.L124:
	lea	rax, .LC44[rip]
	mov	QWORD PTR 48[rsp], r14
	mov	r9, rbx
	xor	ecx, ecx
	mov	QWORD PTR 72[rsp], rax
	mov	DWORD PTR 40[rsp], r11d
	mov	QWORD PTR 80[rsp], rbp
	mov	QWORD PTR 64[rsp], rdi
	mov	DWORD PTR 56[rsp], 1
	mov	DWORD PTR 32[rsp], r15d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	mov	r14, QWORD PTR 296[rsp]
	jmp	.L72
	.p2align 4,,10
	.p2align 3
.L188:
	cmp	r8b, 34
	je	.L237
	cmp	r8b, 61
	je	.L217
	cmp	r8b, 91
	je	.L81
	jg	.L82
	cmp	r8b, 57
	jg	.L80
	cmp	r8b, 47
	jle	.L238
	cmp	rdi, r10
	jnb	.L89
	movzx	edx, BYTE PTR -1[r10]
	mov	eax, edx
	and	eax, -33
	sub	eax, 65
	cmp	al, 25
	jbe	.L134
	cmp	dl, 95
	jne	.L89
.L134:
	movsx	r8d, BYTE PTR 1[r10]
	add	r10, 1
.L241:
	test	r8b, r8b
	jne	.L120
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L235:
	mov	rcx, rdi
	call	"fclose"
	mov	rbp, QWORD PTR 288[rsp]
.L44:
	xor	eax, eax
.L43:
	mov	rbx, QWORD PTR 264[rsp]
	mov	rdi, QWORD PTR 280[rsp]
	add	rsp, 312
	ret
	.p2align 4,,10
	.p2align 3
.L125:
	mov	rax, r10
	lea	r15, 1[r10]
.L54:
	movsx	r8d, BYTE PTR 1[rax]
	mov	r10, r15
	test	r8b, r8b
	jne	.L120
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L55:
	movsx	r8d, BYTE PTR 1[r10]
	lea	rdi, 1[r10]
	add	r11d, 1
	mov	r10, rdi
	test	r8b, r8b
	jne	.L120
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L222:
	xor	eax, eax
	ret
.L216:
	mov	r10, r15
	mov	r8d, 61
	.p2align 4
	.p2align 3
.L217:
	lea	rax, 1[r10]
	movzx	ecx, BYTE PTR 1[r10]
	mov	r15, rax
	cmp	rdi, r10
	jb	.L239
.L74:
	cmp	cl, 61
	je	.L216
	mov	r9d, 8388625
	jmp	.L75
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L240:
	bt	r9, rdx
	jnc	.L78
	add	rax, 1
.L75:
	movzx	ecx, BYTE PTR [rax]
	lea	edx, -9[rcx]
	cmp	dl, 23
	jbe	.L240
	cmp	cl, 59
	jbe	.L78
	.p2align 4
	.p2align 3
.L79:
	mov	rax, r10
	jmp	.L54
	.p2align 4,,10
	.p2align 3
.L81:
	mov	eax, DWORD PTR "delim_top"[rip]
	cmp	eax, 1999
	jg	.L134
	movsxd	rdx, eax
	add	eax, 1
	lea	rcx, [rdx+rdx*2]
	lea	rdx, "delim_stack"[rip]
	lea	rdx, [rdx+rcx*8]
	mov	rcx, r10
	sub	rcx, rdi
	mov	BYTE PTR [rdx], r8b
	add	ecx, 1
	mov	DWORD PTR 4[rdx], r11d
	mov	DWORD PTR 8[rdx], ecx
	mov	QWORD PTR 16[rdx], rdi
.L233:
	movsx	r8d, BYTE PTR 1[r10]
	mov	DWORD PTR "delim_top"[rip], eax
	add	r10, 1
	jmp	.L241
	.p2align 4,,10
	.p2align 3
.L237:
	movzx	eax, BYTE PTR 1[r10]
	test	al, al
	je	.L67
	cmp	al, 10
	je	.L67
	lea	rdx, 1[r10]
	movsx	r8d, BYTE PTR 1[rdx]
	cmp	al, 92
	je	.L242
.L68:
	add	rdx, 1
	cmp	al, 34
	je	.L127
	mov	eax, r8d
.L69:
	test	al, al
	je	.L67
	cmp	al, 10
	je	.L67
	movsx	r8d, BYTE PTR 1[rdx]
	cmp	al, 92
	jne	.L68
.L242:
	test	r8b, r8b
	jne	.L243
.L67:
	lea	rax, .LC16[rip]
	sub	r10, rdi
	xor	ecx, ecx
	mov	r9, rbx
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC17[rip]
	lea	r8, .LC14[rip]
	mov	QWORD PTR 72[rsp], rax
	lea	rax, .LC18[rip]
	lea	rdx, .LC15[rip]
	mov	QWORD PTR 64[rsp], rax
	lea	eax, 1[r10]
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], eax
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	.p2align 4
	.p2align 3
.L72:
	mov	rsi, QWORD PTR 272[rsp]
	mov	rbp, QWORD PTR 288[rsp]
	mov	eax, 1
	mov	r15, QWORD PTR 304[rsp]
	jmp	.L43
	.p2align 4,,10
	.p2align 3
.L239:
	movzx	edx, BYTE PTR -1[r10]
	lea	r9d, -60[rdx]
	cmp	r9b, 2
	jbe	.L129
	cmp	dl, 33
	jne	.L244
.L129:
	movsx	r8d, cl
	mov	r10, r15
	test	r8b, r8b
	jne	.L120
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L82:
	mov	r9d, 123
	cmp	r8b, 125
	jne	.L245
.L84:
	mov	eax, DWORD PTR "delim_top"[rip]
	test	eax, eax
	jle	.L88
	lea	edx, -1[rax]
	mov	rax, rdx
	lea	rcx, [rdx+rdx*2]
	lea	rdx, "delim_stack"[rip]
	cmp	BYTE PTR [rdx+rcx*8], r9b
	je	.L233
.L88:
	lea	rbp, 128[rsp]
	lea	rdx, .LC24[rip]
	mov	QWORD PTR 120[rsp], r10
	mov	rcx, rbp
	mov	DWORD PTR 112[rsp], r11d
	mov	DWORD PTR 104[rsp], r8d
	call	"sprintf"
	mov	r8d, DWORD PTR 104[rsp]
	lea	rcx, 192[rsp]
	lea	rdx, .LC25[rip]
	call	"sprintf"
	mov	r10, QWORD PTR 120[rsp]
	mov	r9, rbx
	mov	r11d, DWORD PTR 112[rsp]
	lea	rcx, 192[rsp]
	lea	rax, .LC27[rip]
	mov	QWORD PTR 64[rsp], rbp
	sub	r10, rdi
	mov	QWORD PTR 80[rsp], rcx
	xor	ecx, ecx
	lea	r8, .LC26[rip]
	add	r10d, 1
	mov	QWORD PTR 72[rsp], rax
	lea	rdx, .LC11[rip]
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], r10d
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	jmp	.L72
	.p2align 4,,10
	.p2align 3
.L127:
	mov	r10, rdx
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L89:
	lea	rax, 1[r10]
	xor	r9d, r9d
.L189:
	cmp	r8b, 46
	je	.L214
.L91:
	movzx	r8d, BYTE PTR [rax]
	mov	rcx, rax
	add	rax, 1
	lea	edx, -48[r8]
	cmp	dl, 9
	jbe	.L189
	cmp	r8b, 46
	jne	.L94
.L214:
	lea	rcx, -1[rax]
.L92:
	movzx	edx, BYTE PTR [rax]
	lea	r8d, -48[rdx]
	cmp	r8b, 9
	jbe	.L246
	cmp	dl, 46
	jne	.L94
	mov	rcx, rax
	add	r9d, 2
	add	rax, 1
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L243:
	movzx	eax, BYTE PTR 2[rdx]
	add	rdx, 2
	jmp	.L69
	.p2align 4,,10
	.p2align 3
.L246:
	add	r9d, 1
	add	rax, 1
	jmp	.L91
	.p2align 4,,10
	.p2align 3
.L51:
	movsx	r8d, BYTE PTR 1[r10]
	cmp	r8b, 47
	je	.L58
	cmp	r8b, 42
	je	.L57
	add	r10, 1
	test	r8b, r8b
	jne	.L120
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L238:
	cmp	r8b, 40
	je	.L81
	cmp	r8b, 41
	jne	.L247
	mov	r9d, 40
	jmp	.L84
	.p2align 4,,10
	.p2align 3
.L245:
	jg	.L232
	mov	r9d, 91
	cmp	r8b, 93
	je	.L84
	cmp	r8b, 123
	je	.L81
	cmp	r8b, 96
	jg	.L248
.L80:
	movabs	rdx, 1224979098913210369
	lea	eax, -36[r8]
	bt	rdx, rax
	jnc	.L232
	lea	rbp, 192[rsp]
	lea	rdx, .LC33[rip]
	mov	QWORD PTR 112[rsp], r10
	mov	rcx, rbp
	mov	DWORD PTR 104[rsp], r11d
	call	"sprintf"
	mov	r10, QWORD PTR 112[rsp]
	xor	ecx, ecx
	mov	r9, rbx
	mov	r11d, DWORD PTR 104[rsp]
	lea	rax, .LC36[rip]
	mov	QWORD PTR 64[rsp], rbp
	lea	r8, .LC34[rip]
	sub	r10, rdi
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC37[rip]
	lea	rdx, .LC35[rip]
	add	r10d, 1
	mov	QWORD PTR 72[rsp], rax
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], r10d
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	jmp	.L72
.L57:
	movzx	edx, BYTE PTR 2[r10]
	test	dl, dl
	je	.L60
	lea	rax, 3[r10]
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L64:
	movzx	ecx, BYTE PTR [rax]
	cmp	dl, 10
	jne	.L126
	add	r11d, 1
	mov	edx, ecx
	mov	rdi, rax
.L62:
	add	rax, 1
	test	dl, dl
	je	.L63
.L61:
	mov	r10, rax
	cmp	dl, 42
	jne	.L64
	movzx	edx, BYTE PTR [rax]
	cmp	dl, 47
	jne	.L62
	movsx	r8d, BYTE PTR 1[rax]
	add	r10, 1
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L126:
	mov	edx, ecx
	jmp	.L62
.L94:
	cmp	r9d, 1
	jg	.L96
	movsx	r8d, BYTE PTR [rcx]
	mov	r10, rcx
	jmp	.L56
.L228:
	mov	r15, QWORD PTR 304[rsp]
.L49:
	mov	rcx, rsi
	call	"free"
	mov	rsi, QWORD PTR 272[rsp]
	mov	rbp, QWORD PTR 288[rsp]
	jmp	.L44
.L63:
	movsx	r8d, BYTE PTR [r10]
	jmp	.L56
.L96:
	lea	rax, .LC30[rip]
	sub	rcx, r10
	sub	r10, rdi
	mov	QWORD PTR 48[rsp], rdi
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC31[rip]
	mov	r9, rbx
	lea	r8, .LC28[rip]
	mov	QWORD PTR 72[rsp], rax
	lea	rax, .LC32[rip]
	lea	rdx, .LC29[rip]
	mov	QWORD PTR 64[rsp], rax
	lea	eax, 1[r10]
	mov	DWORD PTR 56[rsp], ecx
	xor	ecx, ecx
	mov	DWORD PTR 40[rsp], eax
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	jmp	.L72
.L121:
	lea	rdi, 128[rsp]
	mov	r9d, 41
	mov	r8d, 40
	mov	DWORD PTR 104[rsp], r11d
	lea	rdx, .LC45[rip]
	mov	rcx, rdi
	lea	rbp, 192[rsp]
	call	"sprintf"
	mov	r8d, 41
	lea	rdx, .LC46[rip]
	mov	rcx, rbp
	call	"sprintf"
	mov	r11d, DWORD PTR 104[rsp]
	lea	rdx, .LC9[rip]
	lea	r8, .LC10[rip]
	jmp	.L124
.L78:
	movabs	rdx, 576460752303424513
	bt	rdx, rcx
	jnc	.L80
	lea	rdx, .LC21[rip]
	sub	rax, rdi
	xor	ecx, ecx
	mov	r9, rbx
	mov	QWORD PTR 80[rsp], rdx
	lea	rdx, .LC22[rip]
	add	eax, 1
	lea	r8, .LC19[rip]
	mov	QWORD PTR 72[rsp], rdx
	lea	rdx, .LC23[rip]
	mov	QWORD PTR 64[rsp], rdx
	lea	rdx, .LC20[rip]
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], eax
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	jmp	.L72
.L247:
	cmp	r8b, 35
	jg	.L80
.L232:
	lea	r15, 1[r10]
	jmp	.L79
.L236:
	mov	rcx, rdi
	call	"fclose"
	mov	rsi, QWORD PTR 272[rsp]
	mov	rbp, QWORD PTR 288[rsp]
	jmp	.L44
.L248:
	mov	QWORD PTR 296[rsp], r14
	cmp	r8b, 114
	jne	.L230
	cmp	rdi, r10
	je	.L100
	movzx	eax, BYTE PTR -1[r10]
	cmp	al, 59
	jg	.L101
	cmp	al, 8
	jle	.L230
	movabs	rdx, 576460756598391296
	bt	rdx, rax
	jnc	.L230
.L100:
	mov	rcx, r10
	mov	r8d, 6
	lea	rdx, .LC38[rip]
	mov	DWORD PTR 112[rsp], r11d
	lea	r14, 1[r10]
	mov	QWORD PTR 104[rsp], r10
	call	"strncmp"
	mov	r15, r14
	mov	r10, QWORD PTR 104[rsp]
	mov	r11d, DWORD PTR 112[rsp]
	test	eax, eax
	je	.L102
	movsx	r8d, BYTE PTR 1[r10]
	mov	r10, r14
	mov	r14, QWORD PTR 296[rsp]
	jmp	.L56
.L102:
	movzx	edx, BYTE PTR 6[r10]
	cmp	dl, 59
	jg	.L103
	cmp	dl, 8
	jg	.L249
.L227:
	mov	r14, QWORD PTR 296[rsp]
	jmp	.L79
.L230:
	mov	r14, QWORD PTR 296[rsp]
	lea	r15, 1[r10]
	jmp	.L79
.L101:
	lea	r15, 1[r10]
	cmp	al, 123
	jne	.L227
	jmp	.L100
.L249:
	movabs	rax, 576460756598400512
	bt	rax, rdx
	jc	.L104
	mov	r14, QWORD PTR 296[rsp]
	mov	rax, r10
	jmp	.L54
.L103:
	lea	rax, 6[r10]
	cmp	dl, 125
	jne	.L227
	jmp	.L107
	.p2align 4,,10
	.p2align 3
.L250:
	cmp	dl, 125
	je	.L111
	movzx	edx, BYTE PTR 1[rax]
	add	rax, 1
	test	dl, dl
	je	.L108
	cmp	dl, 59
	je	.L106
.L107:
	cmp	dl, 10
	jne	.L250
.L111:
	mov	r9, rdi
	mov	r8d, r11d
	jmp	.L112
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L251:
	mov	r14d, 8388627
	bt	r14, rcx
	jnc	.L116
	add	rax, 1
	lea	ecx, 1[r8]
	cmp	dl, 10
	cmove	r8d, ecx
	cmove	r9, rax
.L112:
	movzx	edx, BYTE PTR [rax]
	lea	ecx, -9[rdx]
	cmp	cl, 23
	jbe	.L251
	cmp	dl, 47
	jbe	.L116
	mov	ecx, 1
.L117:
	cmp	dl, 125
	je	.L135
	test	cl, cl
	jne	.L118
.L135:
	movsx	r8d, BYTE PTR 1[r10]
	mov	r14, QWORD PTR 296[rsp]
	mov	r10, r15
	jmp	.L56
.L104:
	lea	rax, 6[r10]
	cmp	dl, 59
	jne	.L107
.L106:
	add	rax, 1
	jmp	.L111
.L116:
	movabs	rcx, -140771848093698
	bt	rcx, rdx
	setc	cl
	jmp	.L117
.L118:
	lea	rdx, .LC41[rip]
	sub	rax, r9
	mov	QWORD PTR 48[rsp], r9
	mov	r9, rbx
	mov	QWORD PTR 80[rsp], rdx
	add	eax, 1
	lea	rdx, .LC42[rip]
	mov	ecx, 1
	mov	QWORD PTR 72[rsp], rdx
	lea	rdx, .LC43[rip]
	mov	QWORD PTR 64[rsp], rdx
	lea	rdx, .LC40[rip]
	mov	DWORD PTR 32[rsp], r8d
	lea	r8, .LC39[rip]
	mov	DWORD PTR 56[rsp], 19
	mov	DWORD PTR 40[rsp], eax
	mov	QWORD PTR 112[rsp], r10
	mov	DWORD PTR 104[rsp], r11d
	call	"print_diagnostic"
	mov	r10, QWORD PTR 112[rsp]
	mov	r11d, DWORD PTR 104[rsp]
	mov	r14, QWORD PTR 296[rsp]
	movsx	r8d, BYTE PTR 1[r10]
	mov	r10, r15
	jmp	.L56
.L108:
	cmp	dl, 59
	je	.L106
	jmp	.L111
.L244:
	mov	r9d, edx
	and	r9d, -3
	cmp	r9b, 45
	je	.L129
	sub	edx, 42
	cmp	dl, 1
	jbe	.L129
	jmp	.L74
	.section .rdata,"dr"
	.align 8
.LC47:
	.ascii "\12\33[1;31merror[E0502]\33[0m: \33[1mruntime exception: unresolved method or function call\33[0m\0"
	.align 8
.LC48:
	.ascii "  \33[1;34m-->\33[0m \33[1;37m%s\33[0m\12\0"
	.align 8
.LC49:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: attempted to call an undefined function or null method pointer\0"
	.align 8
.LC50:
	.ascii "   \33[1;34m=\33[0m \33[1mhelp\33[0m: verify method spelling or ensure the target object supports this method\12\0"
	.align 8
.LC51:
	.ascii "method '%s' is not defined on target object\0"
	.align 8
.LC52:
	.ascii "runtime exception: unresolved method or function call\0"
.LC53:
	.ascii "error[E0502]\0"
	.align 8
.LC54:
	.ascii "verify method spelling or ensure the target object implements this method\0"
	.align 8
.LC55:
	.ascii "attempted to call an undefined function or null method pointer\0"
	.text
	.p2align 4
	.globl	"report_runtime_unresolved"
	.def	"report_runtime_unresolved";	.scl	2;	.type	32;	.endef
"report_runtime_unresolved":
	test	rcx, rcx
	je	.L252
	sub	rsp, 600
	mov	QWORD PTR 552[rsp], rdi
	mov	rdi, rdx
	lea	rdx, .LC13[rip]
	mov	QWORD PTR 536[rsp], rbx
	mov	rbx, rcx
	mov	QWORD PTR 544[rsp], rsi
	call	"fopen"
	mov	rsi, rax
	test	rax, rax
	je	.L298
	mov	r8d, 2
	xor	edx, edx
	mov	rcx, rax
	mov	QWORD PTR 560[rsp], rbp
	mov	QWORD PTR 568[rsp], r12
	call	"fseek"
	mov	rcx, rsi
	call	"ftell"
	xor	r8d, r8d
	xor	edx, edx
	mov	rcx, rsi
	movsxd	r12, eax
	call	"fseek"
	lea	ecx, 16[r12]
	movsxd	rcx, ecx
	call	"malloc"
	mov	rbp, rax
	test	rax, rax
	je	.L299
	mov	r9, rsi
	mov	r8, r12
	mov	edx, 1
	mov	rcx, rax
	call	"fread"
	mov	rcx, rsi
	call	"fclose"
	movdqu	xmm0, XMMWORD PTR .LC56[rip]
	mov	BYTE PTR 0[rbp+r12], 0
	movzx	eax, BYTE PTR 0[rbp]
	movups	XMMWORD PTR 144[rsp], xmm0
	pxor	xmm0, xmm0
	movups	XMMWORD PTR 160[rsp], xmm0
	movups	XMMWORD PTR 176[rsp], xmm0
	movups	XMMWORD PTR 192[rsp], xmm0
	movups	XMMWORD PTR 208[rsp], xmm0
	movups	XMMWORD PTR 224[rsp], xmm0
	movups	XMMWORD PTR 240[rsp], xmm0
	movups	XMMWORD PTR 256[rsp], xmm0
	test	al, al
	je	.L256
	mov	r11, rbx
	mov	rbx, rdi
	mov	rdi, rbp
	mov	r10, rbp
	add	rdi, 1
	xor	ebp, ebp
	mov	QWORD PTR 576[rsp], r13
	movabs	r9, 149533581247487
	mov	QWORD PTR 592[rsp], r15
	mov	r13, r10
	movzx	esi, BYTE PTR [rdi]
	xor	r15d, r15d
	mov	QWORD PTR 104[rsp], 0
	mov	r12d, 1
	mov	DWORD PTR 116[rsp], 0
	cmp	al, 10
	je	.L300
	.p2align 4
	.p2align 3
.L257:
	cmp	al, 46
	je	.L301
.L258:
	test	sil, sil
	je	.L292
.L265:
	mov	eax, esi
.L303:
	add	rdi, 1
	movzx	esi, BYTE PTR [rdi]
	cmp	al, 10
	jne	.L257
.L300:
	add	r12d, 1
	mov	r13, rdi
	test	sil, sil
	jne	.L265
.L292:
	mov	r13d, ebp
	mov	rbx, r11
	mov	rbp, r10
.L274:
	test	r13d, r13d
	je	.L297
	lea	rsi, 272[rsp]
	lea	r8, 144[rsp]
	lea	rdx, .LC51[rip]
	mov	rcx, rsi
	call	"sprintf"
	mov	DWORD PTR 40[rsp], r15d
	mov	r9, rbx
	xor	ecx, ecx
	lea	rax, .LC54[rip]
	mov	DWORD PTR 32[rsp], r13d
	lea	r8, .LC52[rip]
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC55[rip]
	lea	rdx, .LC53[rip]
	mov	QWORD PTR 72[rsp], rax
	mov	eax, DWORD PTR 116[rsp]
	mov	QWORD PTR 64[rsp], rsi
	mov	DWORD PTR 56[rsp], eax
	mov	rax, QWORD PTR 104[rsp]
	mov	QWORD PTR 48[rsp], rax
	call	"print_diagnostic"
	mov	r13, QWORD PTR 576[rsp]
	mov	r15, QWORD PTR 592[rsp]
.L276:
	mov	r12, QWORD PTR 568[rsp]
	mov	rbx, QWORD PTR 536[rsp]
	mov	rcx, rbp
	mov	rsi, QWORD PTR 544[rsp]
	mov	rbp, QWORD PTR 560[rsp]
	mov	rdi, QWORD PTR 552[rsp]
	add	rsp, 600
	jmp	"free"
	.p2align 4,,10
	.p2align 3
.L301:
	lea	eax, -97[rsi]
	cmp	al, 25
	jbe	.L277
	cmp	sil, 95
	jne	.L258
.L277:
	mov	rdx, rdi
	jmp	.L260
	.p2align 4,,10
	.p2align 3
.L302:
	cmp	al, 47
	jle	.L262
	sub	eax, 48
	bt	r9, rax
	jnc	.L265
.L263:
	add	rdx, 1
.L260:
	movzx	eax, BYTE PTR [rdx]
	cmp	al, 95
	jle	.L302
	sub	eax, 97
	cmp	al, 25
	jbe	.L263
	mov	eax, esi
	jmp	.L303
	.p2align 4,,10
	.p2align 3
.L262:
	cmp	al, 32
	jne	.L304
.L278:
	mov	rcx, rdx
	.p2align 4
	.p2align 4
	.p2align 3
.L287:
	movzx	eax, BYTE PTR 1[rcx]
	add	rcx, 1
	cmp	al, 32
	je	.L287
	cmp	al, 9
	je	.L287
.L266:
	cmp	al, 40
	jne	.L265
	sub	rdx, rdi
	mov	QWORD PTR 584[rsp], r14
	mov	r14, rdx
	test	rbx, rbx
	je	.L305
	movsxd	r8, edx
	mov	rcx, rdi
	mov	rdx, rbx
	mov	QWORD PTR 120[rsp], r10
	mov	QWORD PTR 128[rsp], r11
	mov	QWORD PTR 136[rsp], r8
	call	"strncmp"
	mov	r10, QWORD PTR 120[rsp]
	mov	r11, QWORD PTR 128[rsp]
	movabs	r9, 149533581247487
	test	eax, eax
	jne	.L296
	mov	rax, rdi
	mov	esi, r12d
	mov	rbp, r10
	mov	r12, r13
	sub	rax, r13
	mov	r8, QWORD PTR 136[rsp]
	mov	rbx, r11
	lea	r15d, 1[rax]
	cmp	r14d, 119
	jle	.L306
.L273:
	mov	DWORD PTR 116[rsp], r14d
	mov	r13d, esi
	mov	r14, QWORD PTR 584[rsp]
	mov	QWORD PTR 104[rsp], r12
	jmp	.L274
	.p2align 4,,10
	.p2align 3
.L304:
	cmp	al, 9
	je	.L278
	jmp	.L266
	.p2align 4,,10
	.p2align 3
.L297:
	mov	r13, QWORD PTR 576[rsp]
	mov	r15, QWORD PTR 592[rsp]
.L256:
	lea	rcx, .LC47[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC48[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC49[rip]
	call	"puts"
	lea	rcx, .LC50[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rcx, rax
	call	"fflush"
	jmp	.L276
	.p2align 4,,10
	.p2align 3
.L252:
	ret
	.p2align 4,,10
	.p2align 3
.L296:
	mov	r14, QWORD PTR 584[rsp]
	mov	eax, esi
	jmp	.L303
	.p2align 4,,10
	.p2align 3
.L298:
	lea	rcx, .LC47[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC48[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC49[rip]
	call	"puts"
	lea	rcx, .LC50[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rbx, QWORD PTR 536[rsp]
	mov	rsi, QWORD PTR 544[rsp]
	mov	rdi, QWORD PTR 552[rsp]
	mov	rcx, rax
	add	rsp, 600
	jmp	"fflush"
	.p2align 4,,10
	.p2align 3
.L305:
	mov	rax, rdi
	sub	rax, r13
	lea	r15d, 1[rax]
	cmp	edx, 119
	jle	.L271
	mov	QWORD PTR 104[rsp], r13
	mov	r14, QWORD PTR 584[rsp]
	mov	ebp, r12d
	mov	eax, esi
	mov	DWORD PTR 116[rsp], edx
	jmp	.L303
.L271:
	movsxd	rbp, edx
	lea	rcx, 144[rsp]
	mov	rdx, rdi
	mov	QWORD PTR 128[rsp], r11
	mov	r8, rbp
	mov	QWORD PTR 120[rsp], r10
	call	"strncpy"
	mov	BYTE PTR 144[rsp+rbp], 0
	mov	eax, esi
	mov	ebp, r12d
	mov	DWORD PTR 116[rsp], r14d
	mov	r10, QWORD PTR 120[rsp]
	movabs	r9, 149533581247487
	mov	QWORD PTR 104[rsp], r13
	mov	r11, QWORD PTR 128[rsp]
	mov	r14, QWORD PTR 584[rsp]
	jmp	.L303
.L306:
	lea	rcx, 144[rsp]
	mov	rdx, rdi
	mov	QWORD PTR 104[rsp], r8
	call	"strncpy"
	mov	r8, QWORD PTR 104[rsp]
	mov	BYTE PTR 144[rsp+r8], 0
	jmp	.L273
.L299:
	mov	rbp, QWORD PTR 560[rsp]
	mov	r12, QWORD PTR 568[rsp]
	mov	rcx, rsi
	mov	rbx, QWORD PTR 536[rsp]
	mov	rsi, QWORD PTR 544[rsp]
	mov	rdi, QWORD PTR 552[rsp]
	add	rsp, 600
	jmp	"fclose"
	.section .rdata,"dr"
	.align 8
.LC58:
	.ascii "\12\33[1;31merror[E0503]\33[0m: \33[1mruntime exception: division by zero\33[0m\0"
	.align 8
.LC59:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: mathematical operation resulted in division by zero\0"
	.align 8
.LC60:
	.ascii "   \33[1;34m=\33[0m \33[1mhelp\33[0m: verify denominator is non-zero before performing division or modulo\12\0"
	.align 8
.LC61:
	.ascii "runtime exception: division by zero\0"
.LC62:
	.ascii "error[E0503]\0"
	.align 8
.LC63:
	.ascii "verify denominator is non-zero before performing division or modulo\0"
	.align 8
.LC64:
	.ascii "mathematical operation resulted in division by zero\0"
.LC65:
	.ascii "division or modulo by zero\0"
	.text
	.p2align 4
	.globl	"report_runtime_div_zero"
	.def	"report_runtime_div_zero";	.scl	2;	.type	32;	.endef
"report_runtime_div_zero":
	test	rcx, rcx
	je	.L307
	sub	rsp, 136
	lea	rdx, .LC13[rip]
	mov	QWORD PTR 104[rsp], rbx
	mov	rbx, rcx
	mov	QWORD PTR 120[rsp], rdi
	call	"fopen"
	mov	rdi, rax
	test	rax, rax
	je	.L353
	mov	r8d, 2
	xor	edx, edx
	mov	rcx, rax
	mov	QWORD PTR 112[rsp], rsi
	mov	QWORD PTR 128[rsp], rbp
	call	"fseek"
	mov	rcx, rdi
	call	"ftell"
	xor	r8d, r8d
	xor	edx, edx
	mov	rcx, rdi
	movsxd	rbp, eax
	call	"fseek"
	lea	ecx, 16[rbp]
	movsxd	rcx, ecx
	call	"malloc"
	mov	rsi, rax
	test	rax, rax
	je	.L354
	mov	r9, rdi
	mov	r8, rbp
	mov	edx, 1
	mov	rcx, rax
	call	"fread"
	mov	rcx, rdi
	call	"fclose"
	mov	BYTE PTR [rsi+rbp], 0
	movzx	eax, BYTE PTR [rsi]
	test	al, al
	je	.L311
	mov	rcx, rsi
	mov	r11, rsi
	xor	edi, edi
	xor	edx, edx
	xor	r10d, r10d
	mov	r9d, 1
	jmp	.L324
	.p2align 4,,10
	.p2align 3
.L315:
	movzx	r8d, BYTE PTR 1[rcx]
	cmp	al, 37
	je	.L327
	add	rcx, 1
	mov	eax, r8d
.L313:
	test	al, al
	je	.L326
.L324:
	cmp	al, 10
	je	.L355
.L312:
	cmp	al, 35
	je	.L317
	cmp	al, 47
	jne	.L315
	movzx	eax, BYTE PTR 1[rcx]
	cmp	al, 47
	je	.L317
.L316:
	mov	r8, rcx
	add	rcx, 1
	sub	r8, r11
	lea	edx, 1[r8]
	cmp	al, 32
	je	.L329
	cmp	al, 9
	jne	.L319
.L329:
	mov	r8, rcx
	.p2align 4
	.p2align 4
	.p2align 3
.L343:
	movzx	r10d, BYTE PTR 1[r8]
	add	r8, 1
	cmp	r10b, 32
	je	.L343
	cmp	r10b, 9
	je	.L343
	cmp	r10b, 48
	je	.L323
	mov	rdi, r11
	mov	r10d, r9d
	jmp	.L312
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L356:
	cmp	al, 10
	je	.L313
.L317:
	movzx	eax, BYTE PTR 1[rcx]
	add	rcx, 1
	test	al, al
	jne	.L356
.L326:
	test	r10d, r10d
	je	.L311
	lea	rax, .LC63[rip]
	mov	DWORD PTR 40[rsp], edx
	mov	r9, rbx
	xor	ecx, ecx
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC64[rip]
	lea	r8, .LC61[rip]
	mov	QWORD PTR 72[rsp], rax
	lea	rax, .LC65[rip]
	lea	rdx, .LC62[rip]
	mov	QWORD PTR 64[rsp], rax
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 32[rsp], r10d
	call	"print_diagnostic"
.L325:
	mov	rbp, QWORD PTR 128[rsp]
	mov	rbx, QWORD PTR 104[rsp]
	mov	rcx, rsi
	mov	rdi, QWORD PTR 120[rsp]
	mov	rsi, QWORD PTR 112[rsp]
	add	rsp, 136
	jmp	"free"
	.p2align 4,,10
	.p2align 3
.L355:
	lea	r11, 1[rcx]
	movzx	eax, BYTE PTR 1[rcx]
	add	r9d, 1
	mov	rcx, r11
	jmp	.L313
	.p2align 4,,10
	.p2align 3
.L327:
	mov	eax, r8d
	jmp	.L316
	.p2align 4,,10
	.p2align 3
.L311:
	lea	rcx, .LC58[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC48[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC59[rip]
	call	"puts"
	lea	rcx, .LC60[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rcx, rax
	call	"fflush"
	jmp	.L325
	.p2align 4,,10
	.p2align 3
.L307:
	ret
	.p2align 4,,10
	.p2align 3
.L319:
	cmp	al, 48
	je	.L323
	mov	rdi, r11
	mov	r10d, r9d
	jmp	.L313
.L353:
	lea	rcx, .LC58[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC48[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC59[rip]
	call	"puts"
	lea	rcx, .LC60[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rbx, QWORD PTR 104[rsp]
	mov	rdi, QWORD PTR 120[rsp]
	add	rsp, 136
	mov	rcx, rax
	jmp	"fflush"
.L323:
	mov	rdi, r11
	mov	r10d, r9d
	jmp	.L326
.L354:
	mov	rsi, QWORD PTR 112[rsp]
	mov	rbp, QWORD PTR 128[rsp]
	mov	rcx, rdi
	mov	rbx, QWORD PTR 104[rsp]
	mov	rdi, QWORD PTR 120[rsp]
	add	rsp, 136
	jmp	"fclose"
	.section .rdata,"dr"
.LC66:
	.ascii "<script.nx>\0"
	.align 8
.LC67:
	.ascii "\12\33[1;31merror[E0505]\33[0m: \33[1mruntime exception: call stack overflow\33[0m\0"
	.align 8
.LC68:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: maximum call recursion depth exceeded (RIP=%p)\12\0"
	.align 8
.LC69:
	.ascii "   \33[1;34m=\33[0m \33[1mhelp\33[0m: check for unbounded recursion or missing base case in function calls\12\0"
	.text
	.p2align 4
	.globl	"report_runtime_stack_overflow"
	.def	"report_runtime_stack_overflow";	.scl	2;	.type	32;	.endef
"report_runtime_stack_overflow":
	push	rsi
	mov	rsi, rdx
	push	rbx
	mov	rbx, rcx
	lea	rcx, .LC67[rip]
	sub	rsp, 40
	call	"puts"
	test	rbx, rbx
	lea	rax, .LC66[rip]
	lea	rcx, .LC48[rip]
	cmovne	rax, rbx
	mov	rdx, rax
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	mov	rdx, rsi
	lea	rcx, .LC68[rip]
	call	"printf"
	lea	rcx, .LC69[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	add	rsp, 40
	pop	rbx
	mov	rcx, rax
	pop	rsi
	jmp	"fflush"
	.section .rdata,"dr"
	.align 8
.LC70:
	.ascii "\12\33[1;31merror[E0501]\33[0m: \33[1mruntime exception: memory access violation\33[0m\0"
	.align 8
.LC71:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: attempted to access unmapped memory or dereference null pointer (RIP=%p)\12\0"
	.align 8
.LC72:
	.ascii "   \33[1;34m=\33[0m \33[1mhelp\33[0m: verify object initialization, array bounds, and memory safety invariants\12\0"
	.text
	.p2align 4
	.globl	"report_runtime_access_violation"
	.def	"report_runtime_access_violation";	.scl	2;	.type	32;	.endef
"report_runtime_access_violation":
	push	rsi
	mov	rsi, rdx
	push	rbx
	mov	rbx, rcx
	lea	rcx, .LC70[rip]
	sub	rsp, 40
	call	"puts"
	test	rbx, rbx
	lea	rax, .LC66[rip]
	lea	rcx, .LC48[rip]
	cmovne	rax, rbx
	mov	rdx, rax
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	mov	rdx, rsi
	lea	rcx, .LC71[rip]
	call	"printf"
	lea	rcx, .LC72[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	add	rsp, 40
	pop	rbx
	mov	rcx, rax
	pop	rsi
	jmp	"fflush"
	.section .rdata,"dr"
.LC73:
	.ascii ".nx\0"
.LC74:
	.ascii "stdgpu\0"
.LC75:
	.ascii "stdtensor\0"
.LC76:
	.ascii "stdtorch\0"
.LC77:
	.ascii "stddl\0"
.LC78:
	.ascii "stdllm\0"
.LC79:
	.ascii "stddata\0"
.LC80:
	.ascii "stdgfx\0"
.LC81:
	.ascii "stdprofile\0"
.LC82:
	.ascii "stdlsp\0"
.LC83:
	.ascii "stdpkg\0"
.LC84:
	.ascii "stdmocap\0"
.LC85:
	.ascii "stdvfx\0"
.LC86:
	.ascii "import \0"
.LC87:
	.ascii ".nexus_cache\0"
.LC88:
	.ascii ".nexus_cache/_exp_%s\0"
.LC89:
	.ascii "wb\0"
.LC90:
	.ascii "import stdlib\12\12\0"
.LC91:
	.ascii "lib/%s.nx\0"
.LC92:
	.ascii "// === Module: %s ===\12\0"
.LC93:
	.ascii "// %.*s\0"
.LC94:
	.ascii "\12// === End Module: %s ===\12\12\0"
.LC95:
	.ascii "// === User Source: %s ===\12\0"
	.text
	.p2align 4
	.globl	"resolve_and_expand_imports"
	.def	"resolve_and_expand_imports";	.scl	2;	.type	32;	.endef
"resolve_and_expand_imports":
	sub	rsp, 552
	mov	QWORD PTR 488[rsp], rbx
	mov	rbx, rcx
	test	rcx, rcx
	je	.L368
	call	"strlen"
	cmp	rax, 2
	jbe	.L368
	lea	rcx, -3[rbx+rax]
	lea	rdx, .LC73[rip]
	call	"strcmp"
	mov	DWORD PTR 32[rsp], eax
	test	eax, eax
	je	.L482
.L368:
	mov	rax, rbx
.L365:
	mov	rbx, QWORD PTR 488[rsp]
	add	rsp, 552
	ret
	.p2align 4,,10
	.p2align 3
.L482:
	lea	rdx, .LC13[rip]
	mov	rcx, rbx
	mov	QWORD PTR 496[rsp], rsi
	call	"fopen"
	mov	rsi, rax
	test	rax, rax
	je	.L479
	mov	r8d, 2
	xor	edx, edx
	mov	rcx, rax
	mov	QWORD PTR 504[rsp], rdi
	call	"fseek"
	mov	rcx, rsi
	call	"ftell"
	xor	r8d, r8d
	xor	edx, edx
	mov	rcx, rsi
	mov	edi, eax
	call	"fseek"
	lea	eax, -1[rdi]
	cmp	eax, 16777215
	ja	.L480
	lea	ecx, 16[rdi]
	call	"malloc"
	mov	QWORD PTR 48[rsp], rax
	test	rax, rax
	je	.L480
	mov	r9, rsi
	mov	r8, rdi
	mov	edx, 1
	mov	rcx, rax
	mov	QWORD PTR 536[rsp], r14
	mov	r14, rax
	mov	QWORD PTR 544[rsp], r15
	call	"fread"
	mov	rcx, rsi
	mov	rsi, r14
	call	"fclose"
	lea	rax, .LC75[rip]
	mov	BYTE PTR [r14+rdi], 0
	mov	r15, rsi
	movq	xmm0, QWORD PTR .LC96[rip]
	movq	xmm1, rax
	lea	rax, .LC77[rip]
	movzx	r14d, BYTE PTR [r14]
	movq	xmm2, rax
	lea	rax, .LC79[rip]
	punpcklqdq	xmm0, xmm1
	movq	xmm3, rax
	lea	rax, .LC81[rip]
	movups	XMMWORD PTR 128[rsp], xmm0
	movq	xmm4, rax
	movq	xmm0, QWORD PTR .LC97[rip]
	lea	rax, .LC83[rip]
	movq	xmm5, rax
	lea	rax, .LC85[rip]
	punpcklqdq	xmm0, xmm2
	movq	xmm1, rax
	movups	XMMWORD PTR 144[rsp], xmm0
	movq	xmm0, QWORD PTR .LC98[rip]
	punpcklqdq	xmm0, xmm3
	movups	XMMWORD PTR 160[rsp], xmm0
	movq	xmm0, QWORD PTR .LC99[rip]
	punpcklqdq	xmm0, xmm4
	movups	XMMWORD PTR 176[rsp], xmm0
	movq	xmm0, QWORD PTR .LC100[rip]
	punpcklqdq	xmm0, xmm5
	movups	XMMWORD PTR 192[rsp], xmm0
	movq	xmm0, QWORD PTR .LC101[rip]
	punpcklqdq	xmm0, xmm1
	movups	XMMWORD PTR 208[rsp], xmm0
	pxor	xmm0, xmm0
	movups	XMMWORD PTR 64[rsp], xmm0
	movups	XMMWORD PTR 80[rsp], xmm0
	movups	XMMWORD PTR 96[rsp], xmm0
	movups	XMMWORD PTR 112[rsp], xmm0
	test	r14b, r14b
	je	.L372
	mov	QWORD PTR 512[rsp], rbp
	mov	edi, 8388625
	mov	QWORD PTR 520[rsp], r12
	mov	QWORD PTR 528[rsp], r13
	jmp	.L391
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L374:
	movzx	r14d, BYTE PTR 1[r15]
	add	r15, 1
.L391:
	lea	eax, -9[r14]
	cmp	al, 23
	ja	.L373
	bt	rdi, rax
	jc	.L374
.L373:
	mov	r8d, 7
	lea	rdx, .LC86[rip]
	mov	rcx, r15
	call	"strncmp"
	test	eax, eax
	je	.L483
.L375:
	test	r14b, r14b
	je	.L423
	cmp	r14b, 10
	je	.L387
	.p2align 5
	.p2align 4
	.p2align 3
.L383:
	movzx	eax, BYTE PTR 1[r15]
	add	r15, 1
	test	al, al
	je	.L385
	cmp	al, 10
	jne	.L383
.L387:
	movzx	r14d, BYTE PTR 1[r15]
	test	r14b, r14b
	je	.L388
	add	r15, 1
	jmp	.L391
.L480:
	mov	rcx, rsi
	call	"fclose"
	mov	rsi, QWORD PTR 496[rsp]
	mov	rdi, QWORD PTR 504[rsp]
	jmp	.L368
	.p2align 4,,10
	.p2align 3
.L385:
	cmp	al, 10
	je	.L387
	test	al, al
	je	.L388
	xor	r14d, r14d
	jmp	.L391
	.p2align 4,,10
	.p2align 3
.L483:
	movzx	eax, BYTE PTR 7[r15]
	lea	rsi, 7[r15]
	cmp	al, 32
	jne	.L481
	.p2align 4
	.p2align 4
	.p2align 3
.L460:
	movzx	eax, BYTE PTR 1[rsi]
	add	rsi, 1
	cmp	al, 32
	je	.L460
.L481:
	cmp	al, 9
	je	.L460
	lea	r13, 128[rsp]
	lea	rbp, 64[rsp]
	mov	r12d, 6
	jmp	.L382
	.p2align 4,,10
	.p2align 3
.L484:
	mov	rcx, QWORD PTR 0[r13]
	add	rbp, 4
	call	"strlen"
	mov	r12, rax
.L382:
	mov	rdx, QWORD PTR 0[r13]
	mov	r8, r12
	mov	rcx, rsi
	call	"strncmp"
	test	eax, eax
	jne	.L380
	movzx	eax, BYTE PTR [rsi+r12]
	cmp	al, 59
	ja	.L380
	movabs	rdx, 576460756598400513
	bt	rdx, rax
	jnc	.L380
	mov	DWORD PTR 0[rbp], 1
	mov	DWORD PTR 32[rsp], 1
.L380:
	add	r13, 8
	lea	rax, 224[rsp]
	cmp	r13, rax
	jne	.L484
	jmp	.L375
.L423:
	cmp	r14b, 10
	je	.L387
.L388:
	mov	ecx, DWORD PTR 32[rsp]
	test	ecx, ecx
	je	.L485
	mov	edx, DWORD PTR 76[rsp]
	mov	eax, DWORD PTR 32[rsp]
	lea	rcx, .LC87[rip]
	test	edx, edx
	cmove	eax, DWORD PTR 72[rsp]
	xor	edx, edx
	mov	DWORD PTR 72[rsp], eax
	call	[QWORD PTR __imp_CreateDirectoryA[rip]]
	mov	edx, 47
	mov	rcx, rbx
	call	"strrchr"
	test	rax, rax
	je	.L486
.L394:
	lea	r9, 1[rax]
.L395:
	lea	r8, .LC88[rip]
	mov	edx, 1024
	lea	rcx, "expanded_path_buf"[rip]
	call	"snprintf"
	lea	rdx, .LC89[rip]
	lea	rcx, "expanded_path_buf"[rip]
	call	"fopen"
	mov	r12, rax
	test	rax, rax
	je	.L487
	mov	r9, rax
	mov	r8d, 15
	mov	edx, 1
	lea	rcx, .LC90[rip]
	lea	rsi, 64[rsp]
	call	"fwrite"
	lea	rbp, 128[rsp]
	jmp	.L409
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L397:
	add	rsi, 4
	lea	rax, 112[rsp]
	add	rbp, 8
	cmp	rax, rsi
	je	.L488
.L409:
	mov	eax, DWORD PTR [rsi]
	test	eax, eax
	je	.L397
	mov	rax, QWORD PTR 0[rbp]
	lea	r8, .LC91[rip]
	mov	edx, 256
	lea	rcx, 224[rsp]
	mov	r9, rax
	mov	QWORD PTR 40[rsp], rax
	call	"snprintf"
	lea	rdx, .LC13[rip]
	lea	rcx, 224[rsp]
	call	"fopen"
	mov	r15, rax
	test	rax, rax
	je	.L397
	mov	r8d, 2
	xor	edx, edx
	mov	rcx, rax
	call	"fseek"
	mov	rcx, r15
	call	"ftell"
	xor	r8d, r8d
	xor	edx, edx
	mov	rcx, r15
	mov	edi, eax
	call	"fseek"
	lea	eax, -1[rdi]
	cmp	eax, 16777214
	jbe	.L489
.L399:
	mov	rcx, r15
	call	"fclose"
	jmp	.L397
.L479:
	mov	rsi, QWORD PTR 496[rsp]
	jmp	.L368
.L488:
	mov	r8, rbx
	lea	rdx, .LC95[rip]
	mov	rcx, r12
	call	"fprintf"
	mov	rsi, QWORD PTR 48[rsp]
	movzx	ebp, BYTE PTR [rsi]
	test	bpl, bpl
	je	.L410
	.p2align 4
	.p2align 3
.L418:
	mov	edx, 10
	mov	rcx, rsi
	call	"strchr"
	mov	rbx, rax
	test	rax, rax
	je	.L411
	mov	rdi, rax
	sub	rdi, rsi
	add	rdi, 1
.L412:
	mov	rcx, rsi
	cmp	bpl, 9
	je	.L462
	cmp	bpl, 32
	jne	.L413
	.p2align 4
	.p2align 4
	.p2align 3
.L462:
	movzx	eax, BYTE PTR 1[rcx]
	add	rcx, 1
	cmp	al, 32
	je	.L462
	cmp	al, 9
	je	.L462
.L413:
	mov	r8d, 7
	lea	rdx, .LC86[rip]
	call	"strncmp"
	test	eax, eax
	jne	.L416
	mov	r9, rsi
	mov	r8d, edi
	lea	rdx, .LC93[rip]
	mov	rcx, r12
	call	"fprintf"
.L417:
	test	rbx, rbx
	je	.L410
	movzx	ebp, BYTE PTR 1[rbx]
	lea	rsi, 1[rbx]
	test	bpl, bpl
	jne	.L418
.L410:
	mov	rcx, r12
	call	"fclose"
	mov	rcx, QWORD PTR 48[rsp]
	call	"free"
	mov	rsi, QWORD PTR 496[rsp]
	mov	rdi, QWORD PTR 504[rsp]
	lea	rax, "expanded_path_buf"[rip]
	mov	rbp, QWORD PTR 512[rsp]
	mov	r12, QWORD PTR 520[rsp]
	mov	r13, QWORD PTR 528[rsp]
	mov	r14, QWORD PTR 536[rsp]
	mov	r15, QWORD PTR 544[rsp]
	jmp	.L365
	.p2align 4,,10
	.p2align 3
.L416:
	mov	r9, r12
	mov	r8, rdi
	mov	edx, 1
	mov	rcx, rsi
	call	"fwrite"
	jmp	.L417
	.p2align 4,,10
	.p2align 3
.L411:
	mov	rcx, rsi
	call	"strlen"
	mov	rdi, rax
	jmp	.L412
.L489:
	lea	ecx, 1[rdi]
	call	"malloc"
	mov	QWORD PTR 56[rsp], rax
	mov	r14, rax
	test	rax, rax
	je	.L399
	mov	r8, rdi
	mov	r9, r15
	mov	edx, 1
	mov	rcx, rax
	call	"fread"
	mov	BYTE PTR [r14+rdi], 0
	mov	r8, QWORD PTR 40[rsp]
	mov	rcx, r12
	lea	rdx, .LC92[rip]
	mov	rdi, r14
	call	"fprintf"
	movzx	r14d, BYTE PTR [r14]
	test	r14b, r14b
	je	.L400
	.p2align 4
	.p2align 3
.L408:
	mov	edx, 10
	mov	rcx, rdi
	call	"strchr"
	mov	r13, rax
	test	rax, rax
	je	.L401
	sub	rax, rdi
	add	rax, 1
	mov	QWORD PTR 32[rsp], rax
.L402:
	mov	rcx, rdi
	cmp	r14b, 32
	je	.L461
	cmp	r14b, 9
	jne	.L403
	.p2align 4
	.p2align 4
	.p2align 3
.L461:
	movzx	eax, BYTE PTR 1[rcx]
	add	rcx, 1
	cmp	al, 32
	je	.L461
	cmp	al, 9
	je	.L461
.L403:
	mov	r8d, 7
	lea	rdx, .LC86[rip]
	call	"strncmp"
	test	eax, eax
	jne	.L406
	mov	r8d, DWORD PTR 32[rsp]
	mov	r9, rdi
	lea	rdx, .LC93[rip]
	mov	rcx, r12
	call	"fprintf"
.L407:
	test	r13, r13
	je	.L400
	movzx	r14d, BYTE PTR 1[r13]
	lea	rdi, 1[r13]
	test	r14b, r14b
	jne	.L408
.L400:
	mov	r8, QWORD PTR 40[rsp]
	mov	rcx, r12
	lea	rdx, .LC94[rip]
	call	"fprintf"
	mov	rcx, QWORD PTR 56[rsp]
	call	"free"
	jmp	.L399
	.p2align 4,,10
	.p2align 3
.L406:
	mov	r8, QWORD PTR 32[rsp]
	mov	r9, r12
	mov	edx, 1
	mov	rcx, rdi
	call	"fwrite"
	jmp	.L407
	.p2align 4,,10
	.p2align 3
.L401:
	mov	rcx, rdi
	call	"strlen"
	mov	QWORD PTR 32[rsp], rax
	jmp	.L402
.L486:
	mov	edx, 92
	mov	rcx, rbx
	call	"strrchr"
	mov	r9, rbx
	test	rax, rax
	jne	.L394
	jmp	.L395
.L485:
	mov	rbp, QWORD PTR 512[rsp]
	mov	r12, QWORD PTR 520[rsp]
	mov	r13, QWORD PTR 528[rsp]
.L372:
	mov	rcx, QWORD PTR 48[rsp]
	call	"free"
	mov	rsi, QWORD PTR 496[rsp]
	mov	rdi, QWORD PTR 504[rsp]
	mov	r14, QWORD PTR 536[rsp]
	mov	r15, QWORD PTR 544[rsp]
	jmp	.L368
.L487:
	mov	rcx, QWORD PTR 48[rsp]
	call	"free"
	mov	rsi, QWORD PTR 496[rsp]
	mov	rdi, QWORD PTR 504[rsp]
	mov	rbp, QWORD PTR 512[rsp]
	mov	r12, QWORD PTR 520[rsp]
	mov	r13, QWORD PTR 528[rsp]
	mov	r14, QWORD PTR 536[rsp]
	mov	r15, QWORD PTR 544[rsp]
	jmp	.L368
.lcomm "expanded_path_buf",1024,32
.lcomm "delim_top",4,4
.lcomm "delim_stack",49152,32
	.section .rdata,"dr"
	.align 16
.LC56:
	.quad	6876565001518935669
	.quad	110429656606061
	.align 8
.LC96:
	.quad	.LC74
	.align 8
.LC97:
	.quad	.LC76
	.align 8
.LC98:
	.quad	.LC78
	.align 8
.LC99:
	.quad	.LC80
	.align 8
.LC100:
	.quad	.LC82
	.align 8
.LC101:
	.quad	.LC84
	.ident	"GCC: (Rev3, Built by MSYS2 project) 16.2.0"
	.def	"memset";	.scl	2;	.type	32;	.endef
	.def	"printf";	.scl	2;	.type	32;	.endef
	.def	"puts";	.scl	2;	.type	32;	.endef
	.def	"fflush";	.scl	2;	.type	32;	.endef
	.def	"fopen";	.scl	2;	.type	32;	.endef
	.def	"fseek";	.scl	2;	.type	32;	.endef
	.def	"ftell";	.scl	2;	.type	32;	.endef
	.def	"malloc";	.scl	2;	.type	32;	.endef
	.def	"fread";	.scl	2;	.type	32;	.endef
	.def	"fclose";	.scl	2;	.type	32;	.endef
	.def	"sprintf";	.scl	2;	.type	32;	.endef
	.def	"free";	.scl	2;	.type	32;	.endef
	.def	"strncmp";	.scl	2;	.type	32;	.endef
	.def	"strncpy";	.scl	2;	.type	32;	.endef
	.def	"strlen";	.scl	2;	.type	32;	.endef
	.def	"strcmp";	.scl	2;	.type	32;	.endef
	.def	"strrchr";	.scl	2;	.type	32;	.endef
	.def	"snprintf";	.scl	2;	.type	32;	.endef
	.def	"fwrite";	.scl	2;	.type	32;	.endef
	.def	"fprintf";	.scl	2;	.type	32;	.endef
	.def	"strchr";	.scl	2;	.type	32;	.endef
	.def	"fwrite";	.scl	2;	.type	32;	.endef
