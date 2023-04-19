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
movq $5, %rdx
movq %rdx, -16(%rbp)
movl $3200, %edi
call malloc@PLT
movq %rax, -24(%rbp)
movl $800, %edi
call malloc@PLT
movq %rax, -40(%rbp)
movq $19, %rdx
movq %rdx, -48(%rbp)
movq $4, %rdx
movq %rdx, -56(%rbp)
movq $3, %rdx
movq %rdx, -64(%rbp)
movq $0, %rcx
movq $1, %rbx
imulq $80, %rbx
addq %rbx, %rcx
movq $1, %rbx
imulq $4, %rbx
addq %rbx, %rcx
movq -24(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, -72(%rbp)
movq $20, %rdx
movq %rdx, -72(%rbp)
movq $0, %rcx
movq $0, %rbx
imulq $80, %rbx
addq %rbx, %rcx
movq $0, %rbx
imulq $4, %rbx
addq %rbx, %rcx
movq -24(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, -80(%rbp)
movq $3, %rdx
movq %rdx, -80(%rbp)
movq $0, %rcx
movq $0, %rbx
imulq $20, %rbx
addq %rbx, %rcx
movq $0, %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -40(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, -88(%rbp)
movq $2, %rdx
movq %rdx, -88(%rbp)
movq $0, %rcx
movq -48(%rbp), %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -56(%rbp), %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -24(%rbp), %rbx
addq %rcx, %rbx
movq %rbx, -96(%rbp)
movq -48(%rbp), %rax
subq $18, %rax
movq %rax, -104(%rbp)
movq $0, %rcx
movq $18, %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -56(%rbp), %rax
subq $3, %rax
movq %rax, -112(%rbp)
movq $3, %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -24(%rbp), %rbx
addq %rcx, %rbx
movq -48(%rbp), %rax
subq $19, %rax
movq %rax, -120(%rbp)
movq $0, %rcx
movq $19, %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -64(%rbp), %rax
subq $3, %rax
movq %rax, -128(%rbp)
movq $3, %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -24(%rbp), %rbx
addq %rcx, %rbx
movq -24(%rbp), %rax
imulq -24(%rbp), %rax
movq %rax, -136(%rbp)
movq -136(%rbp), %rdx
movq %rdx, -96(%rbp)
movq $0, %rcx
movq -48(%rbp), %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -56(%rbp), %rbx
imulq $0, %rbx
addq %rbx, %rcx
movq -24(%rbp), %rbx
addq %rcx, %rbx
movq %rax, %rsi
leaq .LC0(%rip), %rax
movq %rax, %rdi
movq $0, %rax
call printf@PLT
movq $0, %rax
leave
ret

