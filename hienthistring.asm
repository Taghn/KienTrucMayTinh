.model small
.stack 100h

.data
    ho_ten db 'Ho va ten: Nguyen Van A', 13, 10, '$'
    ma_so  db 'Ma so: 12345678$'

.code
main:
    mov ax, @data
    mov ds, ax

    ; Hi?n th? h? tên + xu?ng dòng
    mov ah, 09h
    lea dx, ho_ten
    int 21h

    ; Hi?n th? mã s?
    lea dx, ma_so
    int 21h

    ; K?t thúc chuong trình
    mov ah, 4Ch
    int 21h
end main