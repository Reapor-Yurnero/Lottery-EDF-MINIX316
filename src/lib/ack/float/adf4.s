.sect .text; .sect .rom; .sect .data; .sect .bss
.extern .adf4
.sect .text
.adf4:
push ebp
mov ebp,esp
sub	esp,28
mov -28(ebp),0
cmp 12(ebp),0
jne I1_4
mov edx,8(ebp)
mov 12(ebp),edx
jmp I1_1
I1_4:
cmp 8(ebp),0
je I1_1
push 4
lea eax,-12(ebp)
push eax
lea eax,12(ebp)
push eax
call .extend
add esp,12
push 4
lea eax,-24(ebp)
push eax
lea eax,8(ebp)
push eax
call .extend
add esp,12
lea eax,-24(ebp)
push eax
lea eax,-12(ebp)
push eax
call .add_ext
pop ecx
pop ecx
push 4
lea eax,12(ebp)
push eax
lea eax,-12(ebp)
push eax
call .compact
add esp,12
I1_1:
leave
ret
