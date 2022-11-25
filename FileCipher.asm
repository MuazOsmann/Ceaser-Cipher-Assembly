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
  bufsize dw 1024   ; number of characters read from the file
  FileName db "msg.txt", NULL   ; name of the file to be read, NULL FOR END OF STRING
  ResultFile db "result.txt", NULL  ; name of the file to written in, NULL FOR END OF STRING
section .bss
  bufer resb 1024   ; TO STORE THE TEXT READ FROM THE FILE
  CipheredText resb 1024    ;   TO STORE THE CIPHER TEXT
section  .text              ; declaring our .text segment
  global  _start  
_start:                     ; this is where code starts getting executed
  ; open the file
    mov rax, SYS_open ; file open
    mov rdi, FileName ; file name string
    mov rsi, O_RDWR   ; read and write permissions
    syscall           ; to call the open file

    ; TO DO
    ; COMPARE if rax < 0
    ; IF TRUE JUMP TO OPEN FILE ERROR LABEL
    ; mov  qword readBuffer[], rax

  ; read the file
    mov rax, SYS_read ; read
    mov rdi, rax ; file descriptor
    mov rsi, bufer ; buffer - content of file stored in rsi
    mov rdx, bufsize ; buffer size
    syscall

    ; TO DO
    ; COMPARE if rax < 0
    ; IF TRUE JUMP TO READ FILE ERROR LABEL

        ; write content of file to STDOUT
    mov rax, SYS_write ; write
    mov rdi, STDOUT ; file descriptor
    mov rsi, bufer ; buffer
    mov rdx, rax ; buffer size
    syscall

  ; Take Every Letter ASCII value and add 3 to it
  ; if the value is greater than 90 then subtract 26
  ; if the value is less than 65 then add 26

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

  ShiftingLoop:
  ; check if the end of file proceed to the Swapping part
    cmp byte [rsi], NULL
    je Swapping
  ; check if the element is a letter
    cmp byte [rsi], 65 ; 65 is ASCII value of A
    jl NotALetter
    cmp byte [rsi], 90 ; 90 is ASCII value of Z
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
    mov byte [rsi], 65 ; change the element X to A
    jmp NextElement
  ; else if the element is Y
  Y:
    mov byte [rsi], 66 ; change the element to B
    jmp NextElement
  ; else if the element is Z
  Z:
    mov byte [rsi], 67 ; change the element to C
    jmp NextElement
  ; if the element is not a letter
  NotALetter:
    mov byte [rsi], 32 ; change the element to space
  ; go to the next element
  NextElement:
    inc rsi ; increment the pointer -> going to the next charachter
    jmp ShiftingLoop ; go to the loop
  ; end of loop
  ; swap the elements
  Swapping:
    mov rsi, bufer ; set the pointer to the beginning of the buffer
    ; Swap between the current letter and the next letter

    SwapLoop:
    ; check if the end of file use the bufer variable
      cmp byte [rsi+1], NULL
      je EndOfLoop
      cmp byte [rsi], NULL
      je EndOfLoop, Null
    ; swap the current letter with the next letter
      mov al, [rsi] ; move the current letter to al
      mov bl, [rsi+1] ; move the next letter to bl
      mov [rsi], bl ; move bl to the current letter
      mov [rsi+1], al ; move al to the next letter
      inc rsi ; increment the pointer
      jmp SwapLoop
  EndOfLoop:
    ; write to STDOUT
    mov rdi, STDOUT ; file descriptor
    mov rsi, bufer ; buffer
    mov rdx, rax ; buffer size
    mov rax, SYS_write ; write
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

    