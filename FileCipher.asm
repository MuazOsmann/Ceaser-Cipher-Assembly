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
section .bss
  bufer resb 1024
section  .text              ; declaring our .text segment
  global  _start  
_start:                     ; this is where code starts getting executed
  ; open the file
    mov rax, SYS_open ; file open
    mov rdi, FileName ; file name string
    mov rsi, O_RDONLY
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
    mov rdi, STDOUT ; file descriptor
    mov rsi, bufer ; buffer
    mov rdx, rax ; buffer size
    mov rax, SYS_write ; write
    syscall

  ; exit
    mov rax, SYS_exit ; exit
    mov rdi, EXIT_SUCCESS ; exit code
    syscall