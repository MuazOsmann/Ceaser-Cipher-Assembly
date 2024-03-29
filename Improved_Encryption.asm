;Group Members:
; Muaz Osman
; Waseem Qaffaf
; Kassem Darawcha
; Munir Alremawi


;Defining the Constants
LF equ 10 ; line feed
NULL equ 0 ; end of string
EXIT_SUCCESS equ 0 ; success code
STDIN equ 0 ; standard input
STDOUT equ 1 ; standard output
STDERR equ 2 ; standard error
SYS_read equ 0 ; read
SYS_write equ 1 ; write
SYS_open equ 2 ; file open
SYS_close equ 3 ; file close
SYS_exit equ 60 ; terminate
O_CREAT equ 0x40
O_TRUNC equ 0x200
O_RDONLY equ 000000q ; read only
O_WRONLY equ 000001q ; write only
O_RDWR equ 000002q ; read and write
S_IRUSR equ 00400q
S_IWUSR equ 00200q

section .data
  bufsize dw 1024
  FileName db "msg.txt",0
  ResultFile db "result.txt",0
  FileOpenErrorMsg db "Error: File could not be opened",10,0
  LineFeeder db " ",10,0
section .bss
  bufer resb 1024
section  .text              ; declaring our .text segment
  global  _start
_start:                     ; this is where code starts getting executed
  ; open the file
    mov rax, SYS_open ; file open
    mov rdi, FileName ; file name string
    mov rsi, O_RDWR   ; READ WRITE PERMISSIONS
    mov rdx, 0
    syscall
  ; check if the file is opened successfully
    cmp rax, 0
    jl FileOpenError

  ; read the file
    mov rdi, rax ; file descriptor
    mov rsi, bufer ; buffer
    mov rdx, bufsize ; buffer size
    mov rax, SYS_read ; read
    syscall


        ; write to STDOUT
    mov rdi, bufer ; PRINTING CONTENT OF FILE - file descriptor
    call printString
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
    call odd_even_swap ; calling the swap function to swap between odds and even
    mov rsi, bufer ; set the pointer to the beginning of the buffer
    call swap_all    ; calling the swap_all function : swaps every 2 elements together

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
    mov rsi, O_CREAT | O_TRUNC | O_WRONLY ; O_CREAT : create the file if it does not exist
                                          ; O_TRUNC : truncate the file to zero length
                                          ; O_WRONLY : open for writing only
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

FileOpenError:
    mov rdi, FileOpenErrorMsg ; file open error message
    call printString ; print the error message
    syscall ; system call
    mov rax, SYS_exit ; exit
    mov rdi, EXIT_SUCCESS ; exit code
    syscall ; system call
; Create a printing function
global printString
printString:
  push rbp ; save the base pointer
  mov rbp, rsp ; set the base pointer to the stack pointer
  push rbx ; save the base pointer
  ; Count characters in string.
  mov rbx, rdi ; save the string pointer
  mov rdx, NULL ; set the end of string character
CountingLoop:
  cmp byte [rbx], NULL ; check if the end of string
  ; if the character is NULL then exit the current loop
  je CountingDone ; exit the loop if the character is NULL
  inc rbx ; increment the pointer
  inc rdx ; increment the counter
  jmp CountingLoop ; go to the loop
CountingDone:
  ;if rdx is 0, then return the value
  cmp rdx, NULL ; check if the counter is 0 or not
  je PrintingDone ; if the counter is 0 then exit the function
  mov rax, SYS_write ; code for system writing
  mov rsi, rdi ; address of the string
  mov rdi, STDOUT ; file descriptor
  syscall ; system call
; String Printed
PrintingDone:
  pop rbx ; restore the base pointer
  pop rbp ; restore the base pointer
  ret ; return to the caller

global odd_even_swap
odd_even_swap:
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
      add rsi, 2 ; increment the pointer by 2
      jmp SwapLoop
ret

global swap_all
swap_all:
    SwapAllLoop:
    ; check if the end of file
      cmp byte [rsi+1], NULL
      jne .notDoneYet
      ret
    .notDoneYet:
    ; swap the current letter with the next letter
      mov al, [rsi] ; move the current letter to al
      mov bl, [rsi+1] ; move the next letter to bl
      mov [rsi], bl ; move bl to the current letter
      mov [rsi+1], al ; move al to the next letter
      inc rsi
      jmp SwapAllLoop
ret
