section .data
    array db 5, 3, 8, 1, 2
    array_size db 5
    msg db "Tableau trie: ", 0

section .text
    global _start

_start:
    ; Tri à bulles
    mov rbx, [array_size]
    dec rbx              ; Taille - 1

outer_loop:
    mov rcx, rbx
    xor rdi, rdi        ; Indice i

inner_loop:
    mov al, [array + rdi]
    mov bl, [array + rdi + 1]
    cmp al, bl
    jbe no_swap

    ; Échanger les éléments
    mov [array + rdi], bl
    mov [array + rdi + 1], al

no_swap:
    inc rdi
    cmp rdi, rcx
    jl inner_loop

    dec rbx
    jnz outer_loop

    ; Afficher le tableau trié
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 15
    syscall

    mov rcx, [array_size]
    mov rdi, 0          ; Indice pour l'affichage

print_loop:
    mov al, [array + rdi]
    add al, '0'         ; Convertir en caractère
    mov [buffer], al

    mov rax, 1
    mov rdi, 1
    lea rsi, [buffer]
    mov rdx, 1
    syscall

    inc rdi
    cmp rdi, rcx
    jl print_loop

    ; Sortir du programme
    mov rax, 60
    xor rdi, rdi
    syscall
