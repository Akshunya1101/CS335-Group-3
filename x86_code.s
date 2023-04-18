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
movq -24(%rbp), %rdx
movq %rdx, -16(%rbp)
movq $19, %rdx
movq %rdx, -32(%rbp)
movq $4, %rdx
movq %rdx, -40(%rbp)
movq $3, %rdx
movq %rdx, -48(%rbp)
movq $0, %rcx
movq $1, %rbx
imulq $40, %rbx
addq %rbx, %rcx
movq $1, %rbx
imulq $8, %rbx
addq %rbx, %rcx
movq -16(%rbp), %r8
addq %rcx, %r8
movq $20, %rdx
movq %rdx, (%r8)
movq $0, %rcx
movq $0, %rbx
imulq $40, %rbx
addq %rbx, %rcx
movq $0, %rbx
imulq $8, %rbx
addq %rbx, %rcx
movq -16(%rbp), %r8
addq %rcx, %r8
movq $3, %rdx
movq %rdx, (%r8)
movq $0, %rcx
movq -32(%rbp), %rbx
imulq $40, %rbx
addq %rbx, %rcx
movq -40(%rbp), %rbx
imulq $8, %rbx
addq %rbx, %rcx
movq -16(%rbp), %r8
addq %rcx, %r8
movq -32(%rbp), %rax
subq $18, %rax
movq %rax, -56(%rbp)
movq $0, %rcx
movq -56(%rbp), %rbx
imulq $40, %rbx
addq %rbx, %rcx
movq -40(%rbp), %rax
subq $3, %rax
movq %rax, -64(%rbp)
movq -64(%rbp), %rbx
imulq $8, %rbx
addq %rbx, %rcx
movq -16(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, -72(%rbp)
movq -32(%rbp), %rax
subq $19, %rax
movq %rax, -80(%rbp)
movq $0, %rcx
movq -80(%rbp), %rbx
imulq $40, %rbx
addq %rbx, %rcx
movq -48(%rbp), %rax
subq $3, %rax
movq %rax, -88(%rbp)
movq -88(%rbp), %rbx
imulq $8, %rbx
addq %rbx, %rcx
movq -16(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, -96(%rbp)
movq -72(%rbp), %rdx
movq (%rdx), %rax
movq -96(%rbp), %rdx
imulq (%rdx), %rax
movq %rax, -104(%rbp)
movq -104(%rbp), %rdx
movq %rdx, (%r8)
movq -32(%rbp), %rax
subq $18, %rax
movq %rax, -112(%rbp)
movq $0, %rcx
movq -112(%rbp), %rbx
imulq $40, %rbx
addq %rbx, %rcx
movq -40(%rbp), %rax
subq $3, %rax
movq %rax, -120(%rbp)
movq -120(%rbp), %rbx
imulq $8, %rbx
addq %rbx, %rcx
movq -16(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, -128(%rbp)
movq -128(%rbp), %rdx
movq (%rdx), %rax
movq %rax, %rsi
leaq .LC0(%rip), %rax
movq %rax, %rdi
movq $0, %rax
call printf@PLT
movq $0, %rax
leave
ret

