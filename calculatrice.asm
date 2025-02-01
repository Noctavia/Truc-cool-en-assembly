section .data
    prompt1 db "Entrez le premier nombre: ", 0
    prompt2 db "Entrez le deuxieme nombre: ", 0
    prompt3 db "Choisissez une operation (+, -, *, /): ", 0
    result_msg db "Le resultat est: ", 0
    buffer db 20 dup(0)  ; Buffer pour les entrées

section .bss
    num1 resq 1
    num2 resq 1
    operation resb 1

section .text
    global _start

_start:
    ; Demander le premier nombre
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, prompt1    ; message
    mov rdx, 30         ; message length
    syscall

    ; Lire le premier nombre
    call read_input
    mov rax, [buffer]
    sub rax, '0'        ; Convertir caractère en entier
    mov [num1], rax

    ; Demander le deuxième nombre
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, 30
    syscall

    ; Lire le deuxième nombre
    call read_input
    mov rax, [buffer]
    sub rax, '0'        ; Convertir caractère en entier
    mov [num2], rax

    ; Demander l'opération
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt3
    mov rdx, 40
    syscall

    ; Lire l'opération
    call read_input
    mov [operation], byte [buffer]

    ; Effectuer l'opération
    mov rax, [num1]
    mov rbx, [num2]
    movzx rcx, byte [operation]

    cmp rcx, '+'
    je addition
    cmp rcx, '-'
    je soustraction
    cmp rcx, '*'
    je multiplication
    cmp rcx, '/'
    je division

    jmp end_program

addition:
    add rax, rbx
    jmp afficher_resultat

soustraction:
    sub rax, rbx
    jmp afficher_resultat

multiplication:
    imul rax, rbx
    jmp afficher_resultat

division:
    xor rdx, rdx      ; Clear rdx for division
    xor rax, rax      ; Clear rax before division
    mov rax, [num1]
    div rbx            ; rax = rax / rbx
    jmp afficher_resultat

afficher_resultat:
    ; Afficher le résultat
    mov rdi, rax
    call print_result
    jmp end_program

end_program:
    ; Sortir du programme
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; code de retour 0
    syscall

read_input:
    ; Lire une ligne d'entrée
    mov rax, 0          ; syscall: read
    mov rdi, 0          ; file descriptor: stdin
    mov rsi, buffer     ; buffer pour l'entrée
    mov rdx, 20         ; nombre de bytes à lire
    syscall
    ret

print_result:
    ; Convertir le résultat en chaîne de caractères et l'afficher
    ; Pour simplifier, nous allons juste afficher un message fixe
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, result_msg ; message
    mov rdx, 20         ; message length
    syscall

    ; Convertir le résultat en chaîne
    mov rax, rdi        ; Récupérer le résultat
    add rax, '0'        ; Convertir en caractère
    mov [buffer], al    ; Stocker le caractère dans le buffer

    ; Afficher le résultat
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer     ; buffer contenant le résultat
    mov rdx, 1          ; longueur du résultat
    syscall

    ret
