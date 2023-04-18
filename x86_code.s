.section    .rodata
.LC0:
     .string    "%d\n"
     .text
     .globl    main

main:
pushq %rbp
movq %rsp, %rbp
movq +16(%rbp), %rdx
movq %rdx, -8(%rbp)
movl $800, %edi
call malloc@PLT
movq %rax, -16(%rbp)
movq %rax, -16(%rbp)
movq $19, -24(%rbp)
movq $2, -32(%rbp)
movq $3, -40(%rbp)
movq $0, %rcx
movq -24(%rbp), %rbx
imulq $20, %rbx
addq %rbx, %rcx
movq -32(%rbp), %rbx
imulq $4, %rbx
addq %rbx, %rcx
movq -16(%rbp), %rbx
addq %rcx, %rbx
movq $2, %rbx
movq $0, %rcx
movq -24(%rbp), %rbx
imulq $20, %rbx
addq %rbx, %rcx
movq -16(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, %rax
movq %rax, %rsi
leaq .LC0(%rip), %rax
movq %rax, %rdi
movq $0, %rax
call printf@PLT
leave
ret

