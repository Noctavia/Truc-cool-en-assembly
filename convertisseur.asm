section .data
    prompt db "Entrez un nombre decimal: ", 0
    result_msg db "Le nombre en binaire est: ", 0
    buffer db 20 dup(0)

section .bss
    num resq 1

section .text
    global _start

_start:
    ; Demander un nombre décimal
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, 30
    syscall

    ; Lire le nombre
    call read_input
    mov rax, [buffer]
    sub rax, '0'        ; Convertir caractère en entier
    mov [num], rax

    ; Afficher le résultat
    mov rax, [num]
    call print_binary

    ; Sortir du programme
    mov rax, 60
    xor rdi, rdi
    syscall

read_input:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 20
    syscall
    ret

print_binary:
    ; Afficher le nombre en binaire
    mov rbx, 8          ; Nombre de bits
    mov rcx, 0          ; Compteur de bits

print_loop:
    shl rax, 1          ; Décaler à gauche
    jc print_one        ; Si le bit de poids fort est 1
    mov rdx, '0'
    jmp print_char

print_one:
    mov rdx, '1'

print_char:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rdx]
    mov rdx, 1
    syscall

    inc rcx
    cmp rcx, rbx
    jl print_loop

    ret
