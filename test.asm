   Swapping:
    mov rsi, bufer ; set the pointer to the beginning of the buffer
    ; Swap between the current letter and the next lettermov rsi, buffer ; set the pointer to the beginning of the buffer
    mov rdi, rsi    ; gives rsi as argument/parameter to function swap
    call swap

global swap
swap:
    SwapLoop:
    ; check if the end of file
      cmp byte [rsi], NULL
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
ret


mov rsi, buffer
global lengthCounter
lengthCounter:
    cmp byte [rsi], NULL
    je endOfCounter
    inc buffer_counter
    inc rsi
    jmp lengthCounter

    endOfCounter:
        ret