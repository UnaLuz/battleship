.8086
.model small
.stack 100h
.data
; Porta-aviones PPPPP
; Nave de batalla BBBB
; Crucero de batalla CCC
; Submarino BBB
; Destructor DD

  posicion db "A4", 24h

  msj db "Ingrese Y para continuar, otra tecla para salir", 0dh, 0ah, 24h

  impTablero db "El tablero:", 0dh, 0ah, 0dh, 0ah

  tableroXL db "x-------------------------------------------x ", 0dh, 0ah
            db "|   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | ", 0dh, 0ah
            db "| A |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| B |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| C |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| D |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| E |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| F |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| G |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| H |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| I |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "| J |   |   |   |   |   |   |   |   |   |   | ", 0dh, 0ah
            db "x-------------------------------------------x ", 0dh, 0ah, 24h
  cols db 48
  rows db 12
  colW db 4

.code
; Importo funciones de la libreria
extrn ponerBarco:proc
extrn obtenerIndice:proc

  main proc
    mov ax, @data
    mov ds, ax

inicio:
    call Clearscreen

    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di
    
    mov bx, offset tableroXL

    mov dx, "D3"
    mov cl, colW
    mov ch, cols
    call obtenerIndice
    ; Porta aviones - PPPPP
    mov si, 0 ; poner el barco en forma horizontal
    mov al, "P" ; Caracter que representa al barco
    mov cx, 5 ; Barco de tamaño 3
    mov dx, 0
    add dl, colW ; paso el ancho de cada columna
    call ponerBarco

    mov dx, "A9"
    mov cl, colW
    mov ch, cols
    call obtenerIndice
    ;Nave de batalla BBBB
    mov si, 1 ; poner el barco en forma vertical
    mov al, "B" ; Caracter que representa al barco
    mov cx, 4 ; barco de tamaño 4
    mov dx, 0
    add dl, cols ; cantidad de caracteres por columna
    call ponerBarco


    ; Destructor DD
    mov dx, "E5"
    mov cl, colW
    mov ch, cols
    call obtenerIndice
    ;Nave de batalla BBBB
    mov si, 1 ; poner el barco en forma vertical
    mov al, "D" ; Caracter que representa al barco
    mov cx, 2 ; barco de tamaño 4
    mov dx, 0
    add dl, cols ; cantidad de caracteres por columna
    call ponerBarco

    ; Imprimir tablero
    mov ah, 9
    mov dx, offset impTablero
    int 21h

    mov ah, 9
    mov dx, offset msj
    int 21h

    mov ah, 1
    int 21h

    cmp al, "y"
    jne fin

    jmp inicio

    fin:

    mov ax, 4c00h
    int 21h
  main endp



  Clearscreen proc
  push ax
  push es
  push cx
  push di
  mov ax,3
  int 10h
  mov ax,0b800h
  mov es,ax
  mov cx,1000
  mov ax,7
  mov di,ax
  cld
  rep stosw
  pop di
  pop cx
  pop es
  pop ax
  ret 
Clearscreen endp

  
end main