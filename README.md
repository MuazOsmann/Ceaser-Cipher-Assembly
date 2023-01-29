# CSEC-Assignment-2

## Part A
Assembly Code Documentation
Group Members
Muaz Osman
Waseem Qaffaf
Kassem Darawcha
Munir Alremawi
Constants Definition
The following constants are used in the code:

Constant	Value	Description
LF	10	Line Feed
NULL	0	End of string
EXIT_SUCCESS	0	Success code
STDIN	0	Standard input
STDOUT	1	Standard output
STDERR	2	Standard error
SYS_read	0	Read
SYS_write	1	Write
SYS_open	2	File open
SYS_close	3	File close
SYS_exit	60	Terminate
O_CREAT	0x40	Open with create option
O_TRUNC	0x200	Open with truncate option
O_RDONLY	000000q	Open with read-only permission
O_WRONLY	000001q	Open with write-only permission
O_RDWR	000002q	Open with read and write permission
S_IRUSR	00400q	User read permission
S_IWUSR	00200q	User write permission
Data Section
The following data is declared in the .data section:

Variable	Value	Description
bufsize	1024	Number of characters, each character has a 2 bytes of memory
FileName	"msg.txt",0	Name of the source file that includes the text to be ciphered
ResultFile	"result.txt",0	Name of the file where the ciphered text will be stored
FileOpenErrorMsg	"Error: File could not be opened",10,0	Error message that will be displayed if there's an error opening the file
LineFeeder	" ",10,0	Line feed character
BSS Section
The following uninitialized data is declared in the .bss section:

Variable	Value	Description
bufer	resb 1024	Reserved memory for storing the content to be manipulated later
Text Section
The .text section contains the code that will be executed. The code starts with the _start label:

Open the file with SYS_open syscall. The file name string is stored in FileName, the read and write permission in O_RDWR.
Check if the file opened successfully by comparing the value of rax with 0. If rax is less than 0, jump to the FileOpenError label.
Read the file with SYS_read syscall. The file descriptor is stored in rdi, the buffer in rsi, and the buffer size in rdx.
Write to the standard output with SYS_write syscall. The content of the file is stored in bufer.
Shift the content of the file by adding 3 to each letter's ASCII value. If the value is greater than 90, subtract 26
