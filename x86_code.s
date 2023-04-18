.section    .rodata
.LC0:
     .string    "%d\n"
     .text
     .globl    main

main:
pushq %rbp
movq %rsp, %rbp
movq +16(%rbp), %rdx
movq %rdx, -12(%rbp)
movq +24(%rbp), %rdx
movq %rdx, -20(%rbp)
movq $1, %rax
movq $1, -28(%rbp)
movq $2, %rax
movq $2, -36(%rbp)
movq $3, %rax
movq $3, -44(%rbp)
movq -28(%rbp), %rax
movq -36(%rbp), %rax
movq -28(%rbp), %rax
imulq -36(%rbp), %rax
movq %rax, -52(%rbp)
movq -52(%rbp), %rax
movq %rax, %rsi
leaq .LC0(%rip), %rax
movq %rax, %rdi
movq $0, %rax
call printf@PLT
movq $100, %rax
movq %rax, %rsi
leaq .LC0(%rip), %rax
movq %rax, %rdi
movq $0, %rax
call printf@PLT
popq %rbp
leave
ret

