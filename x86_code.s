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
movl $40, %edi
call malloc@PLT
movq %rax, -16(%rbp)
movq $0, %rcx
movq $3, %rbx
imulq $4, %rbx
addq %rbx, %rcx
movq -16(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, %rcx
movq $6, %rdx
movq %rdx, (%rcx)
movq $0, %rcx
movq $3, %rbx
imulq $4, %rbx
addq %rbx, %rcx
movq -16(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, %rcx
movq (%rcx), %rax
movq %rax, %rsi
leaq .LC0(%rip), %rax
movq %rax, %rdi
movq $0, %rax
call printf@PLT
leave
ret

