.8086
.model small
.stack 100h
.data

.code
  ;Declaracion de funciones publicas
  public ponerBarco


  ; Recibe en BX el offset del tablero
  ; en DI la coordenada en X + la coordenada en Y multiplicada por la cantidad de columnas (la posicion correspondiente)
  ; en AX si será horizontal o vertical (0 horizontal o distinto de 0 vertical)
  ; en DL la cantidad total de caracteres por fila, en DH el ancho de cada columna
  ; y en CX el tamaño del barco a colocar
  ponerBarco proc
  ;Cuido el entorno
  push ax
  push bx   ; El offset del tablero no me interesa modificarlo asi que por las dudas lo guardo, para no romper nada
  push cx
  push dx
  push ax
  push di
  pushf
  ; xor ax, ax
  ; xor bx, bx
  ; xor cx, cx
  ; xor dx, dx
  xor si, si
  ; xor di, di

  barco:
  mov byte ptr [bx + di], "*" ; Pongo un simbolo  en la posicion DI del tablero

  cmp ax, 0
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

end