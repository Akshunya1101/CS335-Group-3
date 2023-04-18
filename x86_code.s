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
movq $1, %rdx
movq %rdx, -16(%rbp)
movq $2, %rdx
movq %rdx, -24(%rbp)
movq $3, %rdx
movq %rdx, -32(%rbp)
movq -16(%rbp), %rax
imulq -24(%rbp), %rax
movq %rax, -40(%rbp)
movq -16(%rbp), %rax
addq -24(%rbp), %rax
movq %rax, -48(%rbp)
movq -32(%rbp), %rax
imulq -48(%rbp), %rax
movq %rax, -56(%rbp)
movq -40(%rbp), %rax
addq -56(%rbp), %rax
movq %rax, -64(%rbp)
movq -64(%rbp), %rdx
movq %rdx, -72(%rbp)
movq -32(%rbp), %rax
imulq -32(%rbp), %rax
movq %rax, -80(%rbp)
movq -80(%rbp), %rdx
movq %rdx, -88(%rbp)
movq %rax, %rsi
leaq .LC0(%rip), %rax
movq %rax, %rdi
movq $0, %rax
call printf@PLT
leave
ret

