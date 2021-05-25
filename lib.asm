.8086
.model small
.stack 100h
.data

.code
  ;Declaracion de funciones publicas
  public ponerBarco
  public obtenerIndice
  ; Recibe en BX el offset del tablero
  ; en DI la coordenada en X + la coordenada en Y multiplicada por la cantidad de columnas (la posicion correspondiente)
  ; en SI si será horizontal o vertical (0 horizontal o distinto de 0 vertical)
  ; en DX la cantidad de caracteres por fila (cantidad de columnas) si AX = 0, o tamaño de las columnas si AX != 0
  ; en AL el caracter para representar el barco
  ; y en CX el tamaño del barco a colocar
  ponerBarco proc
  ;Cuido el entorno
  push ax
  push bx   ; El offset del tablero no me interesa modificarlo asi que por las dudas lo guardo, para no romper nada
  push cx
  push dx
  push si
  push di
  pushf
  ; xor ax, ax
  ; xor bx, bx
  ; xor cx, cx
  ; xor dx, dx
  ; xor si, si
  ; xor di, di

  barco:
  mov byte ptr [bx + di], al ; Pongo un simbolo  en la posicion DI del tablero

  cmp si, 0
  je horizontal

  ; AX no es cero por lo que coloco el barco de forma vertical
  add di, dx ; Le sumo los caracteres que hay por fila para pasar a la fila de abajo
  jmp continuarLoop

  horizontal:
  add di, dx ; Le sumo los caracteres por columna

  continuarLoop:
  loop barco

  popf
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret
  ponerBarco endp


  ; Recibo las coordenadas por DX (ej: DX = "B6")
  ; Recibo el ancho de las columnas por CL
  ; Recibo el largo de las filas por CH
  obtenerIndice proc
  ;Cuido el entorno
  push ax
  push bx
  push cx
  push dx
  push si
  ; push di
  pushf
  xor ax, ax
  xor bx, bx
  ; xor cx, cx
  ; xor dx, dx
  xor si, si
  xor di, di

  ;Poner un circulo en la posicion A4: x + y.cols -> 4 + 1.10 = 14 -> sería la posicion/indice del arreglo si consideramos solo 10 columnas
  ;Calculo la columna
  mov di, 6 ; Me posiciono en la columna del 0
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
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret

  obtenerIndice endp

end