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
movq +24(%rbp), %rdx
movq %rdx, -16(%rbp)
movq $1, -24(%rbp)
movq $2, -32(%rbp)
movq $3, -40(%rbp)
movq -24(%rbp), %rax
imulq -32(%rbp), %rax
movq %rax, -48(%rbp)
popq %rbp
leave
ret

