.section    .rodata
.LC0:
     .string    "%d\n"
     .text
     .globl    main

sum:
pushq %rbp
movq %rsp, %rbp
movq +16(%rbp), %rdx
movq %rdx, -8(%rbp)
movq +24(%rbp), %rdx
movq %rdx, -16(%rbp)
movq +32(%rbp), %rdx
movq %rdx, -24(%rbp)
movq +40(%rbp), %rdx
movq %rdx, -32(%rbp)
movq $5, -40(%rbp)
movq -40(%rbp), %rax
imulq $2, %rax
movl 2, %rax
popq %rbp
leave
ret


main:
pushq %rbp
movq %rsp, %rbp
movq +16(%rbp), %rdx
movq %rdx, -8(%rbp)
movq $19, -16(%rbp)
movq $2, -24(%rbp)
movq $3, -32(%rbp)
movq -16(%rbp), %rax
addq -24(%rbp), %rax
imulq -32(%rbp), %rax
movq %rax, -40(%rbp)
pushq %rax
movq -32(%rbp), %rax
imulq -32(%rbp), %rax
movq %rax, -48(%rbp)
pushq %rax
movq -16(%rbp), %rax
imulq -24(%rbp), %rax
pushq %rax
pushq -48(%rbp)
pushq -32(%rbp)
pushq t5
call sum
SP = SP + 32
movq %rax, -56(%rbp)
popq %rbp
leave
ret

