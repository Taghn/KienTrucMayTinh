
.model small
.stack 100h
.data
binary_int db '11010111',0   ; phần nguyên
binary_frac db '10101',0     ; phần thập phân
result_int dw 0
result_frac dw 0
power dw 1

.code
main:
    mov ax, @data
    mov ds, ax

    ; --- TÍNH PHẦN NGUYÊN ---
    ; đảo chuỗi binary_int để tính từ phải qua
    lea si, binary_int
    call strlen
    mov cx, ax      ; độ dài chuỗi
    dec si          ; si trỏ về ký tự cuối cùng
    mov result_int, 0
    mov bx, 1       ; 2^0

next_bit_int:
    mov al, [si]
    cmp al, '1'
    jne skip_add_int
    add result_int, bx

skip_add_int:
    shl bx, 1       ; bx *= 2
    dec si
    loop next_bit_int

    ; --- TÍNH PHẦN THẬP PHÂN ---
    lea si, binary_frac
    mov result_frac, 0
    mov bx, 2       ; bắt đầu từ 1/2 = 2^-1

next_bit_frac:
    mov al, [si]
    cmp al, 0
    je done_frac
    cmp al, '1'
    jne skip_add_frac
    ; result_frac += 10000 / bx
    mov ax, 10000
    div bx          ; chia cho 2,4,8...
    add result_frac, ax

skip_add_frac:
    shl bx, 1       ; bx *= 2
    inc si
    jmp next_bit_frac

done_frac:
    ; --- IN KẾT QUẢ ---
    mov ax, result_int
    call print_num
    mov ah, 2
    mov dl, '.'
    int 21h
    mov ax, result_frac
    call print_num

    mov ah, 4ch
    int 21h

; --- IN SỐ THẬP PHÂN ---
print_num:
    push ax
    mov cx, 0
    mov bx, 10

next_digit:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne next_digit

print_loop:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop print_loop
    pop ax
    ret

; --- TÍNH ĐỘ DÀI CHUỖI ---
strlen:
    push si
    xor ax, ax
find_len:
    cmp [si], 0
    je len_done
    inc ax
    inc si
    jmp find_len
len_done:
    pop si
    ret

end main
