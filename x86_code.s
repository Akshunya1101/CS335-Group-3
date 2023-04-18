.section    .rodata
.LC0:
     .string    "%d\n"
     .text
     .globl    main

sum:
.cfi_startproc
pushq %rbp
movq %rsp, %rbp
movq +16(%rbp), %rdx
movq %rdx, -12(%rbp)
movq +24(%rbp), %rdx
movq %rdx, -20(%rbp)
movq +32(%rbp), %rdx
movq %rdx, -28(%rbp)
movq -20(%rbp), %rax
addq -28(%rbp), %rax
pushq %rax
movq -20(%rbp), %rax
imulq -28(%rbp), %rax
popq %rdx
addq %rdx, %rax
movq %rax, -36(%rbp)
movl s, %rax
popq %rbp
leave
ret
.cfi_endproc


main:
.cfi_startproc
pushq %rbp
movq %rsp, %rbp
movq +16(%rbp), %rdx
movq %rdx, -12(%rbp)
movq +24(%rbp), %rdx
movq %rdx, -20(%rbp)
movq $1, %rax
movq %rax, -28(%rbp)
movq $2, %rax
movq %rax, -36(%rbp)
movq $3, %rax
movq %rax, -44(%rbp)
movq -28(%rbp), %rax
imulq -36(%rbp), %rax
pushq %rax
pushq -36(%rbp)
pushq -28(%rbp)
call sum
imulq -44(%rbp), %rax
popq %rdx
addq %rdx, %rax
movq %rax, -52(%rbp)
popq %rbp
leave
ret
.cfi_endproc

