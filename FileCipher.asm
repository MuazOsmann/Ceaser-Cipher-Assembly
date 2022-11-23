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
  ; get the filename in ebx
    mov ebx, FileName

  ; open the file
    mov eax, SYS_open
    mov ecx, O_RDONLY
    int 0x80               ; );

  ; read the file
    mov eax, SYS_read
    mov ebx, eax       ;   file_descriptor,
    mov ecx, bufer       ;   *buf,
    mov edx, bufsize   ;   *bufsize
    int 0x80             ; );

  ; write to STDOUT
    mov eax, SYS_write
    mov ebx, STDOUT
    int 0x80             ; );

  ; exit
    mov   eax, SYS_exit
    mov   ebx, EXIT_SUCCESS
    int   0x80               ; );