; Formulas 
; lateralAreas[n] = ((2*bases[n])*slants[n])
; totalArea = (bases*((2*slants)+bases))
; volumes(n) = ((bases(n)^2) * heights(n)) / 3
section .data
    NULL            equ     0          
    TRUE            equ     1
    FALSE           equ     0
    EXIT_SUCCESS    equ     0           
    SYS_exit        equ     60         

    ; Data Set
    bases   db  148, 194, 162, 163, 118, 161, 145, 152, 129, 165
            db  112, 100, 185, 163, 125, 176, 147, 155, 110, 113
            db  108, 145, 161, 164, 165, 177, 120, 156, 147, 161
            db  152, 119, 165, 161, 131, 165, 114, 123, 115, 114
            db  101, 171, 111

    slants  dw  233, 214, 223, 211, 234, 212, 200, 285, 263, 205
            dw  264, 213, 224, 213, 265, 244, 212, 213, 212, 223
            dw  265, 264, 273, 216, 234, 253, 213, 243, 213, 235
            dw  244, 169, 234, 233, 232, 234, 223, 215, 214, 201
            dw  222, 242, 233

    heights dd  245, 234, 223, 223, 223, 253, 253, 243, 253, 235
            dd  234, 234, 256, 264, 242, 253, 253, 284, 242, 234
            dd  245, 234, 223, 223, 223, 234, 234, 256, 264, 242
            dd  253, 253, 284, 242, 234, 256, 264, 242, 234, 201
            dd  201, 223, 272

    length      dd      43

    laMin       dd      0
    laEstMed    dd      0
    laMax       dd      0
    laSum       dd      0
    laAve       dd      0

    taMin       dd      0
    taEstMed    dd      0
    taMax       dd      0
    taSum       dd      0
    taAve       dd      0

    vMin        dd      0
    vEstMed     dd      0
    vMax        dd      0
    vSum        dd      0
    vAve        dd      0

section .data
    ddTwo       dd      2
    ddThree     dd      3

section .bss
    ; Uninitialized data
    lateralAreas resd   43
    totalAreas   resd   43
    volumes      resd   43

section .text
global _start
_start:

; ---------------------- Calculate lateral surface areas ----------------------
; ECX lenght
; EAX temp register for base
; EBX temp register for slants
; ESI index for array

; load value byte value
; Multiply the base by 2
; multiply the slant with base 
; store the result in lateralAreas array
mov ecx, [length]
mov eax, 0
mov ebx, 0
mov esi, 0
calc_lateral_area:
    movzx eax, byte [bases + esi]
    movzx rbx, ax
    add eax, eax
    movzx ebx, word [slants + esi * 2]  ;  size
    imul eax, ebx
    mov [lateralAreas + esi * 4], eax
    inc esi
    loop calc_lateral_area

; --------------- Minimum, maximum, sum, and average for lateral surface areas ---------------
; load the length into ECX
; load base address into EDX
; Start loop
; Load the lateralArea Array into EAX
; Add the current value to the sum
; Check for minimum
; if not, then check for Max
; Check for Maximum 
    mov ecx, [length]
    mov esi, 0
    mov edx, [lateralAreas]
    mov [laMin], edx
    mov [laMax], edx
    
la_loop:
    mov eax, [lateralAreas + esi * 4]
    add [laSum], eax
    ; Compare for minimum
    cmp eax, [laMin]
    jb la_update_min
    ; Compare for maximum
    cmp eax, [laMax]
    ja la_update_max
    jmp la_continue
la_update_min:
    mov [laMin], eax
    jmp la_continue
la_update_max:
    mov [laMax], eax
la_continue:
    inc esi
    loop la_loop

; ----------------------- Calculate average -----------------------
; Load Sum into EAX
; Load length into EBX
; check if not divideing by 0
; Sign-Extend EDX:EAX
; Divide EAX by EAX
; Store result in laAve
mov eax, [laSum]   
mov ebx, [length]  
cmp ebx, 0
je divide_by_zero_error 
cdq          
idiv ebx            
mov [laAve], eax  
divide_by_zero_error:


; ---------------------- Calculate total surface areas ----------------------
; Formula : totalArea = (bases*((2*slants)+bases))
; Load the length into ECX
; Startloop
; Load byte from Bases into EAX
; Load word from Slants into EBX
; Multiply slants by 2
; Multiply th result by base
; Multiply that result by base
; Store it into totalAreas array
mov ecx, [length]
mov esi, 0
calc_total_area:
    movzx eax, byte [bases + esi]
    movzx ebx, word[slants + esi * 2]  
    imul ebx, [ddTwo]
    add ebx, eax
    imul ebx, eax
    mov [totalAreas + esi * 4], ebx
    inc esi
    loop calc_total_area

; ----------------------------- Calculate volumes -----------------------------
; Formula : volumes = (((bases^2)*heights)/3)
; Load the length into ECX
; Load the base array into EAX
; Square the base
; Multiply the result by slants
; divide that result by 3
; store it into Volumnes array

mov ecx, [length]     
mov esi, 0             
calc_volume:
    movzx eax, byte [bases + esi]          
    mul eax                
    mul dword [heights + esi * 4]     
    div dword [ddThree]     
    mov dword[volumes + esi * 4], eax           
    inc esi                            
    cmp esi, ecx                            
    jb calc_volume                         



; --------------- Minimum, maximum, sum, and average for totalAreas ---------------
; load the length into ECX
; load base address into EAX
; Start loop
; Load the totalArea Array into EDX
; Add the current value to the sum
; Check for minimum
; if not, then check for Max
; Check for Maximum 

    mov ecx, [length]
    mov esi, 0
    mov edx, [totalAreas]
    mov [taMin], edx
    mov [taMax], edx  
ta_loop:
    mov eax, [totalAreas + esi * 4]
    add [taSum], eax
    ; Compare for minimum
    cmp eax, [taMin]
    jb ta_update_min
    ; Compare for maximum
    cmp eax, [taMax]
    ja ta_update_max
    jmp ta_continue
ta_update_min:
    mov [taMin], eax
    jmp ta_continue
ta_update_max:
    mov [taMax], eax
ta_continue:
    inc esi
    loop ta_loop

 ; ----------------------- Calculate average -----------------------
; Load Sum into EAX
; Load length into EBX
; check if not divideing by 0
; Sign-Extend EDX:EAX
; Divide EAX by EAX
; Store result in taAve
mov eax, [taSum]   
mov ebx, [length]  

cmp ebx, 0
je divide_by_zero
cdq          
idiv ebx            
mov [taAve], eax   
divide_by_zero:


; --------------- Minimum, maximum, sum, and average for Volumes ---------------
; load the length into ECX
; load base address into EAX
; Start loop
; Load the Volume Array into EDX
; Add the current value to the sum
; Check for minimum
; if not, then check for Max
; Check for Maximum  
    mov ecx, [length]
    mov esi, 0
    mov edx, [volumes]
    mov [vMin], edx
    mov [vMax], edx
va_loop:
    mov eax, [volumes + esi * 4]
    add [vSum], eax
    ; Compare for minimum
    cmp eax, [vMin]
    jb va_update_min
    ; Compare for maximum
    cmp eax, [vMax]
    ja va_update_max
    jmp va_continue
va_update_min:
    mov [vMin], eax
    jmp va_continue
va_update_max:
    mov [vMax], eax
va_continue:
    inc esi
    loop va_loop

; ----------------------- Calculate average -----------------------
; Load Sum into EAX
; Load length into EBX
; check if not divideing by 0
; Sign-Extend EDX:EAX
; Divide EAX by EAX
; Store result in laAve
mov eax, [vSum]   
mov ebx, [length]  
cmp ebx, 0
je divideBy_zero
cdq          
idiv ebx            
mov [vAve], eax    
divideBy_zero:

; ------------------- Calculate estimated median -------------------
    mov eax, [laMin]
    add eax, [laMax]
    add eax, [lateralAreas + ebx * 2] ; middle value
    mov ebx, 3
    div ebx
    mov [laEstMed], eax
; Exit Program
    mov rax, SYS_exit                 ; System call for exit (SYS_exit)
    mov rdi, EXIT_SUCCESS             ; Return C/C++ style code (0)
    syscall

