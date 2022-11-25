;Defining the Constants
LF equ 10 ; line feed
NULL equ 0 ; end of string
TRUE equ 1
FALSE equ 0
EXIT_SUCCESS equ 0 ; success code
STDIN equ 0 ; standard input
STDOUT equ 1 ; standard output
STDERR equ 2 ; standard error
SYS_read equ 0 ; read
SYS_write equ 1 ; write
SYS_open equ 2 ; file open
SYS_close equ 3 ; file close
SYS_fork equ 57 ; fork
SYS_exit equ 60 ; terminate
SYS_creat equ 85 ; file open/create
SYS_time equ 201 ; get time
O_CREAT equ 0x40
O_TRUNC equ 0x200
O_APPEND equ 0x400
O_RDONLY equ 000000q ; read only
O_WRONLY equ 000001q ; write only
O_RDWR equ 000002q ; read and write
S_IRUSR equ 00400q
S_IWUSR equ 00200q
S_IXUSR equ 00100q

section .data
  bufsize dw 1024
  FileName db "msg.txt",0
  ResultFile db "result.txt",0
  buffer_counter db 0
  LineFeeder db " ",10,0
section .bss
  bufer resb 1024
  CipheredText resb 1024
section  .text              ; declaring our .text segment
  global  _start
_start:                     ; this is where code starts getting executed
  ; open the file
    mov rax, SYS_open ; file open
    mov rdi, FileName ; file name string
    mov rsi, O_RDWR
    mov rdx, 0
    syscall

  ; read the file
    mov rdi, rax ; file descriptor
    mov rsi, bufer ; buffer
    mov rdx, bufsize ; buffer size
    mov rax, SYS_read ; read
    syscall

   ; CIPHER CODE
        ; TRAVERSE THE CONTENT OF THE FILE
        ; FIRST CHECK IF END OF FILE
        ; CHECK IF ELEMENT IS A LETTER -> RANGE OF LETTERS IN ASSCI
        ; CAPITAL LETTERS RANGE A (65) TO Z (90)
        ; USING ASCI
        ; WE CHECK IF X Y Z
        ; IF X SHIFT TO A       X = 88 TO A = 65
        ; IF Y SHIFT TO B       Y = 89 TO B = 66
        ; IF Z SHIFT TO C       Z = 90 TO C = 67
        ; ELSE
        ; SHIFT EVERY ELEMENT BY 3

        ; write to STDOUT
    mov rdi, bufer ; file descriptor
    call printString
    syscall
  ; Take Every Letter ASCII value and add 3 to it
  ; if the value is greater than 90 then subtract 26
  ; if the value is less than 65 then add 26
  ShiftingLoop:
  ; check if the end of file proceed to the Swapping part
    cmp byte [rsi], NULL
    je Swapping
  ; check if the element is a letter
    cmp byte [rsi], 65 ; This is ASCII value of A
    jl NotALetter
    cmp byte [rsi], 90 ; This is ASCII value of Z
    jg NotALetter
  ; check if the element is X Y Z
    cmp byte [rsi], 88 ; This is ASCII value of X
    je X
    cmp byte [rsi], 89 ; This is ASCII value of Y
    je Y
    cmp byte [rsi], 90 ; This is ASCII value of Z
    je Z
  ; else shift the element by 3
    add byte [rsi], 3 ; add 3 to the element
    jmp NextElement
  ; if the element is X
  X:
    mov byte [rsi], 65 ; change the element to A
    jmp NextElement
  ; if the element is Y
  Y:
    mov byte [rsi], 66 ; change the element to B
    jmp NextElement
  ; if the element is Z
  Z:
    mov byte [rsi], 67 ; change the element to C
    jmp NextElement
  ; if the element is not a letter
  NotALetter:
    mov byte [rsi], 32 ; change the element to space
  ; go to the next element
  NextElement:
    inc rsi ; increment the pointer
    jmp ShiftingLoop ; go to the loop
  ; end of loop
  ; swap the elements
  Swapping:
    mov rsi, bufer ; set the pointer to the beginning of the buffer
    ; Swap between the current letter and the next lettermov rsi, buffer ; set the pointer to the beginning of the buffer
    call swap ; calling the swap function to swap between paramteres

  EndOfLoop:
    ; Line Feed
    mov rdi, LineFeeder
    call printString

    ; write to STDOUT
    mov rdi, bufer ; file descriptor
    call printString
    syscall

  ; open the file
    mov rax, SYS_open ; file open
    mov rdi, ResultFile ; file name string
    mov rsi, O_CREAT | O_TRUNC | O_WRONLY ; flags
    mov rdx, S_IRUSR | S_IWUSR ; mode
    syscall
  ; write to the file
    mov rdi, rax ; file descriptor
    mov rsi, bufer ; buffer
    mov rax, SYS_write ; write
    syscall
  ; close the file
    mov rdi, rax ; file descriptor
    mov rax, SYS_close ; close
    syscall
  ; exit
    mov rax, SYS_exit ; exit
    mov rdi, EXIT_SUCCESS ; exit code
    syscall

; Create a printing function
global printString
printString:
  push rbp
  mov rbp, rsp
  push rbx
  ; Count characters in string.
  mov rbx, rdi
  mov rdx, NULL
CountingLoop:
  cmp byte [rbx], NULL
  ; if the character is NULL then exit the current loop
  je CountingDone
  inc rbx
  inc rdx
  jmp CountingLoop
CountingDone:
  ;if rdx is 0, then return the value
  cmp rdx, NULL
  je PrintingDone
  mov rax, SYS_write ; code for system writing
  mov rsi, rdi ; address of the string
  mov rdi, STDOUT ; file descriptor
  syscall ; system call
; String Printed
PrintingDone:
  pop rbx
  pop rbp
  ret

global swap
swap:
    SwapLoop:
    ; check if the end of file
      cmp byte [rsi+1], NULL
      jne .notDone
      ret
    .notDone:
    ; swap the current letter with the next letter
      mov al, [rsi] ; move the current letter to al
      mov bl, [rsi+1] ; move the next letter to bl
      mov [rsi], bl ; move bl to the current letter
      mov [rsi+1], al ; move al to the next letter
      inc rsi ; increment the pointer
      jmp SwapLoop
ret