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
movq $1, -28(%rbp)
movq $2, -36(%rbp)
movq $3, -44(%rbp)
movq -28(%rbp), %rax
imulq -36(%rbp), %rax
movq %rax, -52(%rbp)
pushq %rax
movq -44(%rbp), %rax
imulq -44(%rbp), %rax
movq %rax, -60(%rbp)
leave
ret

