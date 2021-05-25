.8086
.model small
.stack 100h
.data
  tablero db "  0 1 2 3 4 5 6 7 8 9 ", 0dh, 0ah
          db " +-------------------+", 0dh, 0ah
          db "A|                   |", 0dh, 0ah
          db "B|                   |", 0dh, 0ah
          db "C|                   |", 0dh, 0ah
          db "D|                   |", 0dh, 0ah
          db "E|                   |", 0dh, 0ah
          db "F|                   |", 0dh, 0ah
          db "G|                   |", 0dh, 0ah
          db "H|                   |", 0dh, 0ah
          db "I|                   |", 0dh, 0ah
          db "J|                   |", 0dh, 0ah
          db " +-------------------+", 24h

.code
; Importo funciones de la libreria
extrn ponerBarco:proc

  main proc
    mov ax, @data
    mov ds, ax

    xor ax, ax

    mov bx, offset tablero

    ;Poner un circulo en la posicion A4: x + y.cols -> 4 + 1.10 = 14 -> sería la posicion/indice del arreglo si consideramos solo 10 columnas
    mov di, 2 ; Me posiciono en la columna del 0
    add di, 8 ; Añado 2 por cada posicion que me quiero mover en X por los espacios agregados
    mov al, 2 ; Me posiciono en la fila A
    add al, 0 ; Sumo la cantidad de filas que me quiero mover
    mov cl, 24 ; Pongo en cl la cantidad de columnas que hay (hay que contar todos los caracteres, incluso los saltos)
    mul cl ; multiplico AL por CL
    add di, ax ; Sumo a DI (la posicion en X) lo que tengo en AL (la posicion en y por la cant de columnas)

    mov ax, 0 ; poner el barco en forma horizontal
    mov cx, 3 ; Barco de tamaño 3
    mov dx, 2
    call ponerBarco

    mov di, 2 ; Me posiciono en la columna del 0
    add di, 4 ; Añado 2 por cada posicion que me quiero mover en X por los espacios agregados
    mov al, 2 ; Me posiciono en la fila A
    add al, 0 ; Sumo la cantidad de filas que me quiero mover
    mov cl, 24 ; Pongo en cl la cantidad de columnas que hay (hay que contar todos los caracteres, incluso los saltos)
    mul cl ; multiplico AL por CL
    add di, ax ; Sumo a DI (la posicion en X) lo que tengo en AL (la posicion en y por la cant de columnas)
    ; pos posiciones antes que el anterior (en teoria)

    mov ax, 1 ; poner el barco en forma vertical
    mov cx, 4 ; barco de tamaño 4
    mov dx, 24 ; cantidad de caracteres por columna
    call ponerBarco

    ; Imprimir tablero
    mov ah, 9
    mov dx, bx
    int 21h

    mov ax, 4c00h
    int 21h
  main endp

  
end main