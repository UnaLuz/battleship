.8086
.model small
.stack 100h
.data

.code
  ;Declaracion de funciones publicas
  public ponerBarco
  public obtenerIndice
  public random
  ; Recibe en BX el offset del tablero
  ; en DI la coordenada en X + la coordenada en Y multiplicada por la cantidad de columnas (la posicion correspondiente)
  ; en DX la cantidad de caracteres por fila (para ubicar verticalmente) o tamaño de las columnas (para ubicar horizontalmente)
  ; en AL el caracter para representar el barco
  ; y en CX el tamaño del barco a colocar
  ponerBarco proc
  ;Cuido el entorno
  push ax
  push bx   ; El offset del tablero no me interesa modificarlo asi que por las dudas lo guardo, para no romper nada
  push cx
  push dx
  push di
  pushf
  barco:
  mov byte ptr [bx + di], al ; Pongo un simbolo  en la posicion DI del tablero

  add di, dx ; Le sumo los caracteres (por columna o por fila)

  continuarLoop:
  loop barco

  popf
  pop di
  pop dx
  pop cx
  pop bx
  pop ax
  ret
  ponerBarco endp


  ; Recibo las coordenadas por DX (ej: DX = "B6")
  ; Recibo el ancho de las columnas por CL
  ; Recibo el largo de las filas por CH
  ;Devuelvo el índice correspondiente por DI
  obtenerIndice proc
  ;Cuido el entorno
  push ax
  push bx
  push cx
  push dx
  ; push si
  ; push di
  pushf
  xor ax, ax
  xor bx, bx
  ; xor cx, cx
  ; xor dx, dx
  ; xor si, si
  xor di, di

  ;Poner un circulo en la posicion A4: x + y.cols -> 4 + 1.10 = 14 -> sería la posicion/indice del arreglo si consideramos solo 10 columnas
  ;Calculo la columna
  mov al, cl
  add di, ax ; Me corro una columna a la derecha por que la primera es la de las letras
  mov bl, 2 ; Pongo un 2 en BL
  div bl ; Divido AL por 2
  xor ah, ah
  add di, ax ; Agrego AL a DI para posicionarme en el centro de la columna del 0
  ; mov di, 6 ; Lo anterior es lo mismo que esto si el ancho de columna es 4
  mov al, dl ; Pongo la coordenada de la columna (el numero) en AL
  sub al, 30h ; Paso el caracter a numero
  
  mul cl ; multiplico AL por CL
  add di, ax ; Me posiciono en el índice correspondiente

  xor ax, ax
  ;Sumo las filas a la columna
  mov al, 2 ; Me posiciono en la fila A

  add al, dh ; Pongo el caracter de la fila en AL
  sub al, 41h ; Paso la letra ascii a numero (asumiendo que es una letra mayuscula)

  mul ch ; multiplico AL por Ch (por el largo de las filas)
  add di, ax ; Sumo a DI (la posicion en X) lo que tengo en AL (la posicion en y por la cant de columnas)

  popf
  ; pop di ; Devuelvo el indice correspondiente por DI
  ; pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret
  obtenerIndice endp

    ;recibo en BX el rango del número
    ;devuelvo en DX el número random
random proc
    ;cuido el entorno
    push ax
    push cx
    push si

    call delay ;llamo al delay para que se genere un clock

    mov ah, 0 ;interrupción para tener el system time
    int 1ah ;guarda el número del clock en dx

    mov ax, dx ;paso el clock a ax
    xor dx, dx ;limpio dx
    ;BX va a ser el divisor para generar un resto entre 0 <= r < bx
    div bx ;divido ax por bx
    ;como es una división en 4 bytes, el resto queda en dx

    ;devuelvo el entorno
    pop si
    pop cx
    pop ax

    ret
random endp

;FUNCION AUXILIAR PARA RANDOM
delay proc ;supongo que esto le da tiempo al clock para procesar un número
        mov cx, 1

empieza:
        cmp cx, 30000
        inc cx
    je termina
        inc cx
    jmp empieza

termina:
        ret
delay endp


end