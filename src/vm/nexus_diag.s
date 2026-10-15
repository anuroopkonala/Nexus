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
	.ascii "rb\0"
	.align 8
.LC10:
	.ascii "lexical error: unclosed string literal\0"
.LC11:
	.ascii "error[E0002]\0"
	.align 8
.LC12:
	.ascii "add a matching double quote '\"' before the end of the line\0"
	.align 8
.LC13:
	.ascii "string literal was opened with '\"' but never terminated before newline or EOF\0"
	.align 8
.LC14:
	.ascii "string literal is missing closing quote\0"
	.align 8
.LC15:
	.ascii "syntax error: expected expression after '='\0"
.LC16:
	.ascii "error[E0001]\0"
	.align 8
.LC17:
	.ascii "provide a value or expression, e.g., 'let x = 0;'\0"
	.align 8
.LC18:
	.ascii "assignment operator '=' requires a right-hand side expression\0"
.LC19:
	.ascii "expected expression here\0"
	.align 8
.LC20:
	.ascii "unexpected closing delimiter '%c'\0"
	.align 8
.LC21:
	.ascii "check delimiter matching and remove unmatched '%c'\0"
	.align 8
.LC22:
	.ascii "syntax error: mismatched closing delimiter\0"
.LC23:
	.ascii "error[E0102]\0"
	.align 8
.LC24:
	.ascii "delimiter closing does not match any open delimiter\0"
	.align 8
.LC25:
	.ascii "character '%c' is not recognized in Nexus syntax\0"
	.align 8
.LC26:
	.ascii "lexical error: unrecognized character\0"
.LC27:
	.ascii "error[E0003]\0"
	.align 8
.LC28:
	.ascii "remove the invalid character or replace with a supported operator\0"
	.align 8
.LC29:
	.ascii "character is not a valid identifier or operator in Nexus\0"
.LC30:
	.ascii "return\0"
	.align 8
.LC31:
	.ascii "unreachable statement detected\0"
.LC32:
	.ascii "warning[W0001]\0"
	.align 8
.LC33:
	.ascii "remove the unreachable statement or move it before 'return'\0"
	.align 8
.LC34:
	.ascii "statement follows a 'return' statement in the same block\0"
	.align 8
.LC35:
	.ascii "this code will never be executed\0"
	.align 8
.LC36:
	.ascii "unclosed '%c', expected matching '%c'\0"
	.align 8
.LC37:
	.ascii "add matching closing delimiter '%c'\0"
	.align 8
.LC38:
	.ascii "syntax error: unclosed delimiter\0"
	.align 8
.LC39:
	.ascii "delimiter was opened here but never closed before end of file\0"
	.text
	.p2align 4
	.globl	"scan_and_diagnose_preflight"
	.def	"scan_and_diagnose_preflight";	.scl	2;	.type	32;	.endef
"scan_and_diagnose_preflight":
	test	rcx, rcx
	je	.L185
	sub	rsp, 312
	lea	rdx, .LC9[rip]
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
	ja	.L197
	lea	ecx, 16[rbp]
	mov	QWORD PTR 272[rsp], rsi
	call	"malloc"
	mov	rsi, rax
	test	rax, rax
	je	.L198
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
.L111:
	lea	eax, -9[r8]
	cmp	al, 38
	ja	.L50
	movzx	eax, al
	movsxd	rax, DWORD PTR 0[rbp+rax*4]
	add	rax, rbp
	jmp	rax
	.section .rdata,"dr"
	.align 4
.L52:
	.long	.L194-.L52
	.long	.L55-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L194-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L194-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L58-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L50-.L52
	.long	.L51-.L52
	.text
	.p2align 4,,10
	.p2align 3
.L51:
	movsx	r8d, BYTE PTR 1[r10]
	cmp	r8b, 47
	jne	.L57
	.p2align 5
	.p2align 4
	.p2align 3
.L58:
	movsx	r8d, BYTE PTR 1[r10]
	add	r10, 1
	test	r8b, r8b
	je	.L61
	cmp	r8b, 10
	jne	.L58
.L56:
	test	r8b, r8b
	jne	.L111
	.p2align 4
	.p2align 3
.L61:
	mov	eax, DWORD PTR "delim_top"[rip]
	test	eax, eax
	jle	.L192
	sub	eax, 1
	mov	QWORD PTR 296[rsp], r14
	mov	edi, 41
	lea	rdx, [rax+rax*2]
	lea	rax, "delim_stack"[rip]
	lea	rax, [rax+rdx*8]
	movsx	r8d, BYTE PTR [rax]
	mov	r10d, DWORD PTR 4[rax]
	mov	r11d, DWORD PTR 8[rax]
	mov	r14, QWORD PTR 16[rax]
	cmp	r8b, 40
	je	.L112
	cmp	r8b, 91
	mov	edi, 125
	mov	eax, 93
	cmove	edi, eax
.L112:
	lea	rbp, 128[rsp]
	mov	r9d, edi
	mov	DWORD PTR 112[rsp], r10d
	lea	rdx, .LC36[rip]
	mov	rcx, rbp
	mov	DWORD PTR 104[rsp], r11d
	call	"sprintf"
	lea	rcx, 192[rsp]
	mov	r8d, edi
	lea	rdx, .LC37[rip]
	call	"sprintf"
	mov	r11d, DWORD PTR 104[rsp]
	mov	r9, rbx
	mov	r10d, DWORD PTR 112[rsp]
	lea	rax, .LC39[rip]
	lea	rcx, 192[rsp]
	mov	QWORD PTR 48[rsp], r14
	mov	QWORD PTR 80[rsp], rcx
	lea	r8, .LC38[rip]
	lea	rdx, .LC23[rip]
	xor	ecx, ecx
	mov	QWORD PTR 72[rsp], rax
	mov	DWORD PTR 40[rsp], r11d
	mov	DWORD PTR 32[rsp], r10d
	mov	QWORD PTR 64[rsp], rbp
	mov	DWORD PTR 56[rsp], 1
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	mov	r14, QWORD PTR 296[rsp]
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L50:
	cmp	r8b, 34
	je	.L199
	cmp	r8b, 61
	je	.L200
	cmp	r8b, 96
	jg	.L83
	cmp	r8b, 35
	jle	.L194
	lea	ecx, -36[r8]
	mov	eax, 1
	movabs	rdx, 1224979098913210369
	sal	rax, cl
	test	rax, rdx
	jne	.L84
	movabs	rdx, 144115188075855904
	test	rax, rdx
	je	.L201
	cmp	r8b, 41
	mov	ecx, 91
	mov	eax, 40
	cmove	ecx, eax
.L87:
	mov	eax, DWORD PTR "delim_top"[rip]
	test	eax, eax
	jle	.L90
	lea	edx, -1[rax]
	mov	rax, rdx
	lea	r9, [rdx+rdx*2]
	lea	rdx, "delim_stack"[rip]
	cmp	BYTE PTR [rdx+r9*8], cl
	je	.L195
.L90:
	lea	rbp, 128[rsp]
	lea	rdx, .LC20[rip]
	mov	DWORD PTR 124[rsp], r11d
	mov	rcx, rbp
	mov	QWORD PTR 112[rsp], r10
	mov	DWORD PTR 104[rsp], r8d
	call	"sprintf"
	mov	r8d, DWORD PTR 104[rsp]
	lea	rcx, 192[rsp]
	lea	rdx, .LC21[rip]
	call	"sprintf"
	mov	r10, QWORD PTR 112[rsp]
	mov	r9, rbx
	mov	r11d, DWORD PTR 124[rsp]
	lea	rcx, 192[rsp]
	lea	rax, .LC24[rip]
	mov	QWORD PTR 64[rsp], rbp
	sub	r10, rdi
	mov	QWORD PTR 80[rsp], rcx
	xor	ecx, ecx
	lea	r8, .LC22[rip]
	add	r10d, 1
	mov	QWORD PTR 72[rsp], rax
	lea	rdx, .LC23[rip]
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], r10d
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
.L73:
	mov	rsi, QWORD PTR 272[rsp]
	mov	rbp, QWORD PTR 288[rsp]
	mov	eax, 1
	mov	r15, QWORD PTR 304[rsp]
	jmp	.L43
	.p2align 4,,10
	.p2align 3
.L197:
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
.L55:
	movsx	r8d, BYTE PTR 1[r10]
	lea	rdi, 1[r10]
	add	r11d, 1
	mov	r10, rdi
	test	r8b, r8b
	jne	.L111
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L185:
	xor	eax, eax
	ret
	.p2align 4,,10
	.p2align 3
.L200:
	cmp	rdi, r10
	jnb	.L202
	movzx	edx, BYTE PTR -1[r10]
	movsx	r8d, BYTE PTR 1[r10]
	lea	r15, 1[r10]
	lea	eax, -33[rdx]
	cmp	al, 29
	jbe	.L181
.L77:
	cmp	dl, 42
	setne	al
	cmp	dl, 47
	setne	dl
	and	eax, edx
	jmp	.L76
	.p2align 4,,10
	.p2align 3
.L201:
	movabs	rdx, 36028797018963984
	test	rax, rdx
	jne	.L86
	.p2align 4
	.p2align 3
.L194:
	lea	r15, 1[r10]
.L54:
	movsx	r8d, BYTE PTR 1[r10]
	mov	r10, r15
	test	r8b, r8b
	jne	.L111
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L202:
	movsx	r8d, BYTE PTR 1[r10]
	mov	eax, 1
	lea	r15, 1[r10]
.L76:
	mov	r10, r15
	cmp	r8b, 61
	je	.L56
	test	al, al
	je	.L56
	mov	rax, r15
	mov	r9d, 8388625
	jmp	.L78
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L203:
	bt	r9, rdx
	jnc	.L82
	add	rax, 1
.L78:
	movzx	ecx, BYTE PTR [rax]
	lea	edx, -9[rcx]
	cmp	dl, 23
	jbe	.L203
	cmp	cl, 59
	ja	.L56
.L82:
	movabs	rdx, 576460752303424513
	bt	rdx, rcx
	jnc	.L56
	lea	rdx, .LC17[rip]
	sub	rax, rdi
	xor	ecx, ecx
	mov	r9, rbx
	mov	QWORD PTR 80[rsp], rdx
	lea	rdx, .LC18[rip]
	add	eax, 1
	lea	r8, .LC15[rip]
	mov	QWORD PTR 72[rsp], rdx
	lea	rdx, .LC19[rip]
	mov	QWORD PTR 64[rsp], rdx
	lea	rdx, .LC16[rip]
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], eax
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L83:
	cmp	r8b, 123
	je	.L86
	cmp	r8b, 125
	je	.L117
	mov	QWORD PTR 296[rsp], r14
	cmp	r8b, 114
	jne	.L193
	cmp	rdi, r10
	je	.L91
	movzx	eax, BYTE PTR -1[r10]
	cmp	al, 59
	jg	.L92
	cmp	al, 8
	jle	.L193
	movabs	rdx, 576460756598391296
	bt	rdx, rax
	jnc	.L193
.L91:
	mov	rcx, r10
	mov	r8d, 6
	lea	rdx, .LC30[rip]
	mov	DWORD PTR 112[rsp], r11d
	lea	r14, 1[r10]
	mov	QWORD PTR 104[rsp], r10
	call	"strncmp"
	mov	r15, r14
	mov	r10, QWORD PTR 104[rsp]
	mov	r11d, DWORD PTR 112[rsp]
	test	eax, eax
	je	.L93
	movsx	r8d, BYTE PTR 1[r10]
	mov	r10, r14
	mov	r14, QWORD PTR 296[rsp]
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L57:
	cmp	r8b, 42
	je	.L60
	add	r10, 1
	test	r8b, r8b
	jne	.L111
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L86:
	mov	eax, DWORD PTR "delim_top"[rip]
	cmp	eax, 1999
	jg	.L89
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
.L195:
	mov	DWORD PTR "delim_top"[rip], eax
.L89:
	movsx	r8d, BYTE PTR 1[r10]
	add	r10, 1
	test	r8b, r8b
	jne	.L111
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L199:
	movzx	eax, BYTE PTR 1[r10]
	cmp	al, 10
	je	.L68
	test	al, al
	je	.L68
	lea	rdx, 1[r10]
	movsx	r8d, BYTE PTR 1[rdx]
	cmp	al, 92
	je	.L204
.L69:
	add	rdx, 1
	cmp	al, 34
	je	.L114
	mov	eax, r8d
.L70:
	test	al, al
	je	.L68
	cmp	al, 10
	je	.L68
	movsx	r8d, BYTE PTR 1[rdx]
	cmp	al, 92
	jne	.L69
.L204:
	test	r8b, r8b
	jne	.L205
.L68:
	lea	rax, .LC12[rip]
	sub	r10, rdi
	xor	ecx, ecx
	mov	r9, rbx
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC13[rip]
	lea	r8, .LC10[rip]
	mov	QWORD PTR 72[rsp], rax
	lea	rax, .LC14[rip]
	lea	rdx, .LC11[rip]
	mov	QWORD PTR 64[rsp], rax
	lea	eax, 1[r10]
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], eax
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L84:
	lea	rbp, 192[rsp]
	lea	rdx, .LC25[rip]
	mov	DWORD PTR 112[rsp], r11d
	mov	rcx, rbp
	mov	QWORD PTR 104[rsp], r10
	call	"sprintf"
	mov	r10, QWORD PTR 104[rsp]
	xor	ecx, ecx
	mov	r9, rbx
	mov	r11d, DWORD PTR 112[rsp]
	lea	rax, .LC28[rip]
	mov	QWORD PTR 64[rsp], rbp
	lea	r8, .LC26[rip]
	sub	r10, rdi
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC29[rip]
	lea	rdx, .LC27[rip]
	add	r10d, 1
	mov	QWORD PTR 72[rsp], rax
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 40[rsp], r10d
	mov	DWORD PTR 32[rsp], r11d
	call	"print_diagnostic"
	mov	rcx, rsi
	call	"free"
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L114:
	mov	r10, rdx
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L205:
	movzx	eax, BYTE PTR 2[rdx]
	add	rdx, 2
	jmp	.L70
	.p2align 4,,10
	.p2align 3
.L181:
	mov	rcx, -939529218
	bt	rcx, rax
	jc	.L77
	mov	r10, r15
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L117:
	mov	ecx, 123
	jmp	.L87
.L93:
	movzx	edx, BYTE PTR 6[r10]
	cmp	dl, 59
	jg	.L94
	cmp	dl, 8
	jg	.L206
.L191:
	mov	r14, QWORD PTR 296[rsp]
	jmp	.L54
.L60:
	movzx	edx, BYTE PTR 2[r10]
	test	dl, dl
	je	.L61
	lea	rax, 3[r10]
	jmp	.L62
	.p2align 4,,10
	.p2align 3
.L65:
	movzx	ecx, BYTE PTR [rax]
	cmp	dl, 10
	jne	.L113
	add	r11d, 1
	mov	edx, ecx
	mov	rdi, rax
.L63:
	add	rax, 1
	test	dl, dl
	je	.L64
.L62:
	mov	r10, rax
	cmp	dl, 42
	jne	.L65
	movzx	edx, BYTE PTR [rax]
	cmp	dl, 47
	jne	.L63
	movsx	r8d, BYTE PTR 1[rax]
	add	r10, 1
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L113:
	mov	edx, ecx
	jmp	.L63
.L193:
	mov	r14, QWORD PTR 296[rsp]
	lea	r15, 1[r10]
	jmp	.L54
.L92:
	lea	r15, 1[r10]
	cmp	al, 123
	jne	.L191
	jmp	.L91
.L192:
	mov	r15, QWORD PTR 304[rsp]
.L49:
	mov	rcx, rsi
	call	"free"
	mov	rsi, QWORD PTR 272[rsp]
	mov	rbp, QWORD PTR 288[rsp]
	jmp	.L44
.L64:
	movsx	r8d, BYTE PTR [r10]
	jmp	.L56
.L206:
	movabs	rax, 576460756598400512
	bt	rax, rdx
	jnc	.L191
	lea	rax, 6[r10]
	cmp	dl, 59
	jne	.L98
	jmp	.L97
	.p2align 4,,10
	.p2align 3
.L207:
	cmp	dl, 125
	je	.L102
	movzx	edx, BYTE PTR 1[rax]
	add	rax, 1
	test	dl, dl
	je	.L99
	cmp	dl, 59
	je	.L97
.L98:
	cmp	dl, 10
	jne	.L207
.L102:
	mov	r9, rdi
	mov	r8d, r11d
	jmp	.L103
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L208:
	mov	r14d, 8388627
	bt	r14, rcx
	jnc	.L107
	add	rax, 1
	lea	ecx, 1[r8]
	cmp	dl, 10
	cmove	r8d, ecx
	cmove	r9, rax
.L103:
	movzx	edx, BYTE PTR [rax]
	lea	ecx, -9[rdx]
	cmp	cl, 23
	jbe	.L208
	cmp	dl, 47
	jbe	.L107
	mov	ecx, 1
.L108:
	cmp	dl, 125
	je	.L122
	test	cl, cl
	jne	.L109
.L122:
	movsx	r8d, BYTE PTR 1[r10]
	mov	r14, QWORD PTR 296[rsp]
	mov	r10, r15
	jmp	.L56
.L94:
	lea	rax, 6[r10]
	cmp	dl, 125
	jne	.L191
	jmp	.L98
.L107:
	movabs	rcx, -140771848093698
	bt	rcx, rdx
	setc	cl
	jmp	.L108
.L99:
	cmp	dl, 59
	jne	.L102
.L97:
	add	rax, 1
	jmp	.L102
.L109:
	lea	rdx, .LC33[rip]
	sub	rax, r9
	mov	QWORD PTR 48[rsp], r9
	mov	r9, rbx
	mov	QWORD PTR 80[rsp], rdx
	add	eax, 1
	lea	rdx, .LC34[rip]
	mov	ecx, 1
	mov	QWORD PTR 72[rsp], rdx
	lea	rdx, .LC35[rip]
	mov	QWORD PTR 64[rsp], rdx
	lea	rdx, .LC32[rip]
	mov	DWORD PTR 32[rsp], r8d
	lea	r8, .LC31[rip]
	mov	DWORD PTR 56[rsp], 19
	mov	DWORD PTR 40[rsp], eax
	mov	DWORD PTR 112[rsp], r11d
	mov	QWORD PTR 104[rsp], r10
	call	"print_diagnostic"
	mov	r10, QWORD PTR 104[rsp]
	mov	r11d, DWORD PTR 112[rsp]
	mov	r14, QWORD PTR 296[rsp]
	movsx	r8d, BYTE PTR 1[r10]
	mov	r10, r15
	jmp	.L56
.L198:
	mov	rcx, rdi
	call	"fclose"
	mov	rsi, QWORD PTR 272[rsp]
	mov	rbp, QWORD PTR 288[rsp]
	jmp	.L44
	.section .rdata,"dr"
	.align 8
.LC40:
	.ascii "\12\33[1;31merror[E0502]\33[0m: \33[1mruntime exception: unresolved method or function call\33[0m\0"
	.align 8
.LC41:
	.ascii "  \33[1;34m-->\33[0m \33[1;37m%s\33[0m\12\0"
	.align 8
.LC42:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: attempted to call an undefined function or null method pointer\0"
	.align 8
.LC43:
	.ascii "   \33[1;34m=\33[0m \33[1mhelp\33[0m: verify method spelling or ensure the target object supports this method\12\0"
	.align 8
.LC44:
	.ascii "method '%s' is not defined on target object\0"
	.align 8
.LC45:
	.ascii "runtime exception: unresolved method or function call\0"
.LC46:
	.ascii "error[E0502]\0"
	.align 8
.LC47:
	.ascii "verify method spelling or ensure the target object implements this method\0"
	.align 8
.LC48:
	.ascii "attempted to call an undefined function or null method pointer\0"
	.text
	.p2align 4
	.globl	"report_runtime_unresolved"
	.def	"report_runtime_unresolved";	.scl	2;	.type	32;	.endef
"report_runtime_unresolved":
	test	rcx, rcx
	je	.L209
	sub	rsp, 600
	mov	QWORD PTR 552[rsp], rdi
	mov	rdi, rdx
	lea	rdx, .LC9[rip]
	mov	QWORD PTR 536[rsp], rbx
	mov	rbx, rcx
	mov	QWORD PTR 544[rsp], rsi
	call	"fopen"
	mov	rsi, rax
	test	rax, rax
	je	.L255
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
	je	.L256
	mov	r9, rsi
	mov	r8, r12
	mov	edx, 1
	mov	rcx, rax
	call	"fread"
	mov	rcx, rsi
	call	"fclose"
	movdqu	xmm0, XMMWORD PTR .LC49[rip]
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
	je	.L213
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
	je	.L257
	.p2align 4
	.p2align 3
.L214:
	cmp	al, 46
	je	.L258
.L215:
	test	sil, sil
	je	.L249
.L222:
	mov	eax, esi
.L260:
	add	rdi, 1
	movzx	esi, BYTE PTR [rdi]
	cmp	al, 10
	jne	.L214
.L257:
	add	r12d, 1
	mov	r13, rdi
	test	sil, sil
	jne	.L222
.L249:
	mov	r13d, ebp
	mov	rbx, r11
	mov	rbp, r10
.L231:
	test	r13d, r13d
	je	.L254
	lea	rsi, 272[rsp]
	lea	r8, 144[rsp]
	lea	rdx, .LC44[rip]
	mov	rcx, rsi
	call	"sprintf"
	mov	DWORD PTR 40[rsp], r15d
	mov	r9, rbx
	xor	ecx, ecx
	lea	rax, .LC47[rip]
	mov	DWORD PTR 32[rsp], r13d
	lea	r8, .LC45[rip]
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC48[rip]
	lea	rdx, .LC46[rip]
	mov	QWORD PTR 72[rsp], rax
	mov	eax, DWORD PTR 116[rsp]
	mov	QWORD PTR 64[rsp], rsi
	mov	DWORD PTR 56[rsp], eax
	mov	rax, QWORD PTR 104[rsp]
	mov	QWORD PTR 48[rsp], rax
	call	"print_diagnostic"
	mov	r13, QWORD PTR 576[rsp]
	mov	r15, QWORD PTR 592[rsp]
.L233:
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
.L258:
	lea	eax, -97[rsi]
	cmp	al, 25
	jbe	.L234
	cmp	sil, 95
	jne	.L215
.L234:
	mov	rdx, rdi
	jmp	.L217
	.p2align 4,,10
	.p2align 3
.L259:
	cmp	al, 47
	jle	.L219
	sub	eax, 48
	bt	r9, rax
	jnc	.L222
.L220:
	add	rdx, 1
.L217:
	movzx	eax, BYTE PTR [rdx]
	cmp	al, 95
	jle	.L259
	sub	eax, 97
	cmp	al, 25
	jbe	.L220
	mov	eax, esi
	jmp	.L260
	.p2align 4,,10
	.p2align 3
.L219:
	cmp	al, 32
	jne	.L261
.L235:
	mov	rcx, rdx
	.p2align 4
	.p2align 4
	.p2align 3
.L244:
	movzx	eax, BYTE PTR 1[rcx]
	add	rcx, 1
	cmp	al, 32
	je	.L244
	cmp	al, 9
	je	.L244
.L223:
	cmp	al, 40
	jne	.L222
	sub	rdx, rdi
	mov	QWORD PTR 584[rsp], r14
	mov	r14, rdx
	test	rbx, rbx
	je	.L262
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
	jne	.L253
	mov	rax, rdi
	mov	esi, r12d
	mov	rbp, r10
	mov	r12, r13
	sub	rax, r13
	mov	r8, QWORD PTR 136[rsp]
	mov	rbx, r11
	lea	r15d, 1[rax]
	cmp	r14d, 119
	jle	.L263
.L230:
	mov	DWORD PTR 116[rsp], r14d
	mov	r13d, esi
	mov	r14, QWORD PTR 584[rsp]
	mov	QWORD PTR 104[rsp], r12
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L261:
	cmp	al, 9
	je	.L235
	jmp	.L223
	.p2align 4,,10
	.p2align 3
.L254:
	mov	r13, QWORD PTR 576[rsp]
	mov	r15, QWORD PTR 592[rsp]
.L213:
	lea	rcx, .LC40[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC41[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC42[rip]
	call	"puts"
	lea	rcx, .LC43[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rcx, rax
	call	"fflush"
	jmp	.L233
	.p2align 4,,10
	.p2align 3
.L209:
	ret
	.p2align 4,,10
	.p2align 3
.L253:
	mov	r14, QWORD PTR 584[rsp]
	mov	eax, esi
	jmp	.L260
	.p2align 4,,10
	.p2align 3
.L255:
	lea	rcx, .LC40[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC41[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC42[rip]
	call	"puts"
	lea	rcx, .LC43[rip]
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
.L262:
	mov	rax, rdi
	sub	rax, r13
	lea	r15d, 1[rax]
	cmp	edx, 119
	jle	.L228
	mov	QWORD PTR 104[rsp], r13
	mov	r14, QWORD PTR 584[rsp]
	mov	ebp, r12d
	mov	eax, esi
	mov	DWORD PTR 116[rsp], edx
	jmp	.L260
.L228:
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
	jmp	.L260
.L263:
	lea	rcx, 144[rsp]
	mov	rdx, rdi
	mov	QWORD PTR 104[rsp], r8
	call	"strncpy"
	mov	r8, QWORD PTR 104[rsp]
	mov	BYTE PTR 144[rsp+r8], 0
	jmp	.L230
.L256:
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
.LC51:
	.ascii "\12\33[1;31merror[E0503]\33[0m: \33[1mruntime exception: division by zero\33[0m\0"
	.align 8
.LC52:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: mathematical operation resulted in division by zero\0"
	.align 8
.LC53:
	.ascii "   \33[1;34m=\33[0m \33[1mhelp\33[0m: verify denominator is non-zero before performing division or modulo\12\0"
	.align 8
.LC54:
	.ascii "runtime exception: division by zero\0"
.LC55:
	.ascii "error[E0503]\0"
	.align 8
.LC56:
	.ascii "verify denominator is non-zero before performing division or modulo\0"
	.align 8
.LC57:
	.ascii "mathematical operation resulted in division by zero\0"
.LC58:
	.ascii "division or modulo by zero\0"
	.text
	.p2align 4
	.globl	"report_runtime_div_zero"
	.def	"report_runtime_div_zero";	.scl	2;	.type	32;	.endef
"report_runtime_div_zero":
	test	rcx, rcx
	je	.L264
	sub	rsp, 136
	lea	rdx, .LC9[rip]
	mov	QWORD PTR 104[rsp], rbx
	mov	rbx, rcx
	mov	QWORD PTR 120[rsp], rdi
	call	"fopen"
	mov	rdi, rax
	test	rax, rax
	je	.L310
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
	je	.L311
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
	je	.L268
	mov	rcx, rsi
	mov	r11, rsi
	xor	edi, edi
	xor	edx, edx
	xor	r10d, r10d
	mov	r9d, 1
	jmp	.L281
	.p2align 4,,10
	.p2align 3
.L272:
	movzx	r8d, BYTE PTR 1[rcx]
	cmp	al, 37
	je	.L284
	add	rcx, 1
	mov	eax, r8d
.L270:
	test	al, al
	je	.L283
.L281:
	cmp	al, 10
	je	.L312
.L269:
	cmp	al, 35
	je	.L274
	cmp	al, 47
	jne	.L272
	movzx	eax, BYTE PTR 1[rcx]
	cmp	al, 47
	je	.L274
.L273:
	mov	r8, rcx
	add	rcx, 1
	sub	r8, r11
	lea	edx, 1[r8]
	cmp	al, 32
	je	.L286
	cmp	al, 9
	jne	.L276
.L286:
	mov	r8, rcx
	.p2align 4
	.p2align 4
	.p2align 3
.L300:
	movzx	r10d, BYTE PTR 1[r8]
	add	r8, 1
	cmp	r10b, 32
	je	.L300
	cmp	r10b, 9
	je	.L300
	cmp	r10b, 48
	je	.L280
	mov	rdi, r11
	mov	r10d, r9d
	jmp	.L269
	.p2align 4
	.p2align 4,,10
	.p2align 3
.L313:
	cmp	al, 10
	je	.L270
.L274:
	movzx	eax, BYTE PTR 1[rcx]
	add	rcx, 1
	test	al, al
	jne	.L313
.L283:
	test	r10d, r10d
	je	.L268
	lea	rax, .LC56[rip]
	mov	DWORD PTR 40[rsp], edx
	mov	r9, rbx
	xor	ecx, ecx
	mov	QWORD PTR 80[rsp], rax
	lea	rax, .LC57[rip]
	lea	r8, .LC54[rip]
	mov	QWORD PTR 72[rsp], rax
	lea	rax, .LC58[rip]
	lea	rdx, .LC55[rip]
	mov	QWORD PTR 64[rsp], rax
	mov	DWORD PTR 56[rsp], 1
	mov	QWORD PTR 48[rsp], rdi
	mov	DWORD PTR 32[rsp], r10d
	call	"print_diagnostic"
.L282:
	mov	rbp, QWORD PTR 128[rsp]
	mov	rbx, QWORD PTR 104[rsp]
	mov	rcx, rsi
	mov	rdi, QWORD PTR 120[rsp]
	mov	rsi, QWORD PTR 112[rsp]
	add	rsp, 136
	jmp	"free"
	.p2align 4,,10
	.p2align 3
.L312:
	lea	r11, 1[rcx]
	movzx	eax, BYTE PTR 1[rcx]
	add	r9d, 1
	mov	rcx, r11
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L284:
	mov	eax, r8d
	jmp	.L273
	.p2align 4,,10
	.p2align 3
.L268:
	lea	rcx, .LC51[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC41[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC52[rip]
	call	"puts"
	lea	rcx, .LC53[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rcx, rax
	call	"fflush"
	jmp	.L282
	.p2align 4,,10
	.p2align 3
.L264:
	ret
	.p2align 4,,10
	.p2align 3
.L276:
	cmp	al, 48
	je	.L280
	mov	rdi, r11
	mov	r10d, r9d
	jmp	.L270
.L310:
	lea	rcx, .LC51[rip]
	call	"puts"
	mov	rdx, rbx
	lea	rcx, .LC41[rip]
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	lea	rcx, .LC52[rip]
	call	"puts"
	lea	rcx, .LC53[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	mov	rbx, QWORD PTR 104[rsp]
	mov	rdi, QWORD PTR 120[rsp]
	add	rsp, 136
	mov	rcx, rax
	jmp	"fflush"
.L280:
	mov	rdi, r11
	mov	r10d, r9d
	jmp	.L283
.L311:
	mov	rsi, QWORD PTR 112[rsp]
	mov	rbp, QWORD PTR 128[rsp]
	mov	rcx, rdi
	mov	rbx, QWORD PTR 104[rsp]
	mov	rdi, QWORD PTR 120[rsp]
	add	rsp, 136
	jmp	"fclose"
	.section .rdata,"dr"
.LC59:
	.ascii "<script.nx>\0"
	.align 8
.LC60:
	.ascii "\12\33[1;31merror[E0505]\33[0m: \33[1mruntime exception: call stack overflow\33[0m\0"
	.align 8
.LC61:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: maximum call recursion depth exceeded (RIP=%p)\12\0"
	.align 8
.LC62:
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
	lea	rcx, .LC60[rip]
	sub	rsp, 40
	call	"puts"
	test	rbx, rbx
	lea	rax, .LC59[rip]
	lea	rcx, .LC41[rip]
	cmovne	rax, rbx
	mov	rdx, rax
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	mov	rdx, rsi
	lea	rcx, .LC61[rip]
	call	"printf"
	lea	rcx, .LC62[rip]
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
.LC63:
	.ascii "\12\33[1;31merror[E0501]\33[0m: \33[1mruntime exception: memory access violation\33[0m\0"
	.align 8
.LC64:
	.ascii "   \33[1;34m=\33[0m \33[1mnote\33[0m: attempted to access unmapped memory or dereference null pointer (RIP=%p)\12\0"
	.align 8
.LC65:
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
	lea	rcx, .LC63[rip]
	sub	rsp, 40
	call	"puts"
	test	rbx, rbx
	lea	rax, .LC59[rip]
	lea	rcx, .LC41[rip]
	cmovne	rax, rbx
	mov	rdx, rax
	call	"printf"
	lea	rcx, .LC4[rip]
	call	"puts"
	mov	rdx, rsi
	lea	rcx, .LC64[rip]
	call	"printf"
	lea	rcx, .LC65[rip]
	call	"puts"
	mov	ecx, 1
	call	[QWORD PTR __imp___acrt_iob_func[rip]]
	add	rsp, 40
	pop	rbx
	mov	rcx, rax
	pop	rsi
	jmp	"fflush"
.lcomm "delim_top",4,4
.lcomm "delim_stack",49152,32
	.section .rdata,"dr"
	.align 16
.LC49:
	.quad	6876565001518935669
	.quad	110429656606061
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
