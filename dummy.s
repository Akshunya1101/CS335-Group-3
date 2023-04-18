	.file	"dummy.c"
	.text
	.section	.rodata
.LC0:
	.string	"%d %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl $500, %edi
    call malloc@PLT
    movq %rax, -8(%rbp)
    movq $1, -12(%rbp)
    movq $3, -16(%rbp)
    movq $4, -20(%rbp)
    movq $0, %rcx
    movq -12(%rbp), %rbx
    imulq $100, %rbx
    addq %rbx, %rcx
    movq -16(%rbp), %rbx
    imulq $20, %rbx
    addq %rbx, %rcx
    movq -20(%rbp), %rbx
    imulq $4, %rbx
    addq %rbx, %rcx
    movq -8(%rbp), %rbx
    addq %rcx, %rbx
    movq $2, %rbx
    movq $0, %rcx
    movq $1, %rbx
    imulq $100, %rbx
    addq %rbx, %rcx
    movq $3, %rbx
    imulq $20, %rbx
    addq %rbx, %rcx
    movq $4, %rbx
    imulq $4, %rbx
    addq %rbx, %rcx
    movq -8(%rbp), %rbx
    movq %rbx, %rdi
    addq %rcx, %rbx
    movq $1, %rbx
	movq %rbx, %rsi
	movl	$0, %eax
    lea .LC0(%rip), %rdi
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
