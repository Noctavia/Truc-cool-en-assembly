section .data
    prompt db "Devinez un nombre entre 1 et 10: ", 0
    correct_msg db "Correct! Vous avez devine le nombre.", 0
    wrong_msg db "Incorrect. Essayez encore.", 0
    random_number db 5  ; Nombre à deviner (pour simplifier)

section .bss
    guess resb 2

section .text
    global _start

_start:
    ; Demander un nombre
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, 40
    syscall

    ; Lire la supposition
    call read_input
    mov rax, [guess]
    sub rax, '0'        ; Convertir caractère en entier

    ; Vérifier la supposition
    cmp rax, [random_number]
    je correct

    ; Si incorrect
    mov rax, 1
    mov rdi, 1
    mov rsi, wrong_msg
    mov rdx, 30
    syscall
    jmp end_program

correct:
    ; Si correct
    mov rax, 1
    mov rdi, 1
    mov rsi, correct_msg
    mov rdx, 40
    syscall

end_program:
    ; Sortir du programme
    mov rax, 60
    xor rdi, rdi
    syscall

read_input:
    mov rax, 0
    mov rdi, 0
    lea rsi, [guess]
    mov rdx, 2
    syscall
    ret
