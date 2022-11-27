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
  bufsize dw 1024   ; number of characters, each character has a word (2 bytes) woth of memory specified for it
  FileName db "msg.txt",0   ; name of the source file - the file that includes the text to be ciphered
  ResultFile db "result.txt",0  ; name of the file where the ciphered text will be stored in
  FileOpenErrorMsg db "Error: File could not be opened",10,0    ; ERROR MESSAGE that will be displayed if any error occures when handling files
  LineFeeder db " ",10,0   ; The Line Feed

section .bss
  bufer resb 1024       ; reserved memory for where to store the extracted content, such that it would be manipulated later

section  .text              ; declaring our .text segment
  global  _start
_start:                     ; this is where code starts getting executed
  ; open the file
    mov rax, SYS_open ; file open
    mov rdi, FileName ; file name string
    mov rsi, O_RDWR   ; READ WRITE PERMISSIONS
    mov rdx, 0
    syscall
    ; output will be stored in rax, so we will compare to rax to handle errors
    ;Check if the File opened Successfuly
    cmp rax, 0      ; if a negative values is in rax, it would mean that an error has occured when the file was opened
    jl FileOpenError
    
  ; read the file
    mov rdi, rax ; file descriptor
    mov rsi, bufer ; buffer
    mov rdx, bufsize ; buffer size
    mov rax, SYS_read ; read
    syscall


        ; write to STDOUT/SCREEN
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
  ; Check if the end of file by checking if current character is NULL, if true proceed to the Swapping part
  ; NOTE: rsi holds the current character - rsi gets increamented later on such that we could traverse the array of chars
    cmp byte [rsi], NULL
    je Swapping     ; equavilant to if (rsi == NULL) { Jump to Swapping }
  ; check if the element is a letter by checking if it's withen the interval of the ASSCI NUMBER OS CAPITAL LETTERS
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

  EndOfLoop:
    ; Line Feed
    mov rdi, LineFeeder ; adds a line
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
    mov rdx, S_IRUSR | S_IWUSR ; mode of the file -> 
                               ;S_IRUSR : read permission for the owner
                               ; S_IWUSR : write permission for the owner
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
; Used to print on the screen any errors that may result when opening files
FileOpenError:
    mov rdi, FileOpenErrorMsg
    call printString
    syscall
    mov rax, SYS_exit ; exit
    mov rdi, EXIT_SUCCESS ; exit code
    syscall
; Create a printing function
global printString
printString:
  push rbp ; save the base pointer
  mov rbp, rsp ; set the base pointer to the stack pointer
  push rbx ; save the base pointer
  ; Count characters in string.
  mov rbx, rdi ; save the pointer to the string
  mov rdx, NULL ; save the end of string
CountingLoop: 
  cmp byte [rbx], NULL ; check if the end of string
  ; if the character is NULL then exit the current loop
  je CountingDone ; exit the loop
  inc rbx ; increment the pointer
  inc rdx ; increment the counter
  jmp CountingLoop ; go to the loop
CountingDone:
  ;if rdx is 0, then return the value
  cmp rdx, NULL ; if rdx is 0, then return the value
  je PrintingDone ; if rdx is 0, then return the value
  mov rax, SYS_write ; code for system writing
  mov rsi, rdi ; address of the string
  mov rdi, STDOUT ; file descriptor
  syscall ; system call
; String Printed
PrintingDone:
  pop rbx ; pop the value of rbx
  pop rbp ; pop the value of rbp
  ret ; return the value

; Function to Swap the odd characters with the even character for example abcd -> badc
global odd_even_swap
odd_even_swap:
    SwapLoop:
    ; check if the end of array
      cmp byte [rsi+1], NULL    ; if not the end of the array then keep on swapping
      jne .notDone
      ret   ; used to stop the function, then return to where the function was called: where function is stored is in rip register
    .notDone:
    ; swap the current letter with the next letter
      mov al, [rsi] ; move the current letter to al
      mov bl, [rsi+1] ; move the next letter to bl
      mov [rsi], bl ; move bl to the current letter
      mov [rsi+1], al ; move al to the next letter
      add rsi, 2 ; increment the pointer by 2
      jmp SwapLoop  ; continue swapping
ret

