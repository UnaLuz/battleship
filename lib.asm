.8086
.model small
.stack 100h
.data
    ; msj_ocupado db "Lugar no disponible", 0dh, 0ah, 24h

.code
  ;Declaracion de funciones publicas
  public comprobar_lugar
  public obtenerIndice
  public seedInicial
  public disparar
  public regToAscii

comprobar_lugar proc
  ;Por Bx espera el offset del 
    ;creo esta función para no modificar los registros en ponerBarco
  ;Cuido el entorno
  push ax
  push bx   ; El offset del tablero no me interesa modificarlo asi que por las dudas lo guardo, para no romper nada
  push cx
  push dx
  push di
  pushf

  comprobar:
    mov ah, byte ptr [bx + di] ;muevo lo que haya en el tablero a AH
    cmp ah, '.' ;compruebo si hay . (vacío)
    jne ocupado ;si es diferente . entonces hay un barco o un límite
    ;sino, sigo comparando
    add di, dx ; Le sumo los caracteres por columna
    loop comprobar
    jmp fin_comprobar_lugar ;cuando termine el loop, que termine la función

  ocupado:
    mov byte ptr [si], 1 ;activo la bandera que indica que hay algo ocupado
    ; push dx
    ; push ax

    ; mov ah, 9
    ; mov dx, offset msj_ocupado
    ; int 21h
    
    ; pop ax
    ; pop dx

    fin_comprobar_lugar:
  popf
  pop di
  pop dx
  pop cx
  pop bx
  pop ax
  ret
comprobar_lugar endp

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
  pushf
  xor ax, ax
  xor bx, bx
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
  pop dx
  pop cx
  pop bx
  pop ax
  ret
  obtenerIndice endp

seedInicial proc
  ; Genera una semilla a partir de la fecha y hora del sistema, la devuelve por AX
  push bx
  push cx
  push dx
  pushf

  xor ax, ax
  xor cx, cx
  xor dx, dx

  mov ah, 2ah   ;Obtengo la fecha
  int 21h   ;CX = YY, DH = M, DL = D, AL = w (dia de la semana, ej: 00h = Domingo) 

  xor ah, ah  ;Limpio AH

  add bx, cx
  add bx, dx
  add bx, ax
  
  mov ah, 2ch   ;Obtengo la hora, CH = Hr, CL = Min, DH = Sec, DL = 1/100sec
  int 21h

  add bx, cx
  add bx, dx
  or bx, 8101h  ;Necesito que el seed sea distinto de cero e impar en el bit menos significativo de cada byte
  mov ax, bx

  popf
  pop dx
  pop cx
  pop bx
  ret
seedInicial endp

;Recibe un indice por DI
; el offset del tablero visible por BX
; y el offset del tablero con los barcos en SI
;Devuelve por AL si el disparo fue exitoso o no
; AL = 0 --> Error, ya se disparo en esa posicion
; AL = 1 --> Disparo cae en agua
; AL = 2 --> Disparo exitoso, le dio a un barco
disparar proc
  push di
  push bx
  push si
  push cx
  pushf

  ;Me fijo si es agua
  cmp byte ptr [bx + di], "."
  je agua

  cmp byte ptr [bx + di], "*"   ;Ya se disparó en esa posicion
  je noDisparo

  cmp byte ptr [bx + di], "#"   ;Hay restos de un barco roto (ya se disparó ahí)
  je noDisparo
  ;No es agua, le dio a un barco
  mov cl, "#"
  mov al, 2
  jmp disparo

  noDisparo:
  mov al, 0
  jmp terminarDisparo

  agua:
  mov cl, "*"
  mov al, 1

  disparo:
  mov byte ptr [bx + di], cl
  mov bx, si ;Por alguna razon no me deja usar SI directamente
  mov byte ptr [bx + di], cl
terminarDisparo:
  popf
  pop cx
  pop si
  pop bx
  pop di
  ret
disparar endp

; recibe en AL el numero a convertir
; recibe en BX el offset de la variable (de dos caracteres/digitos)
regToAscii proc
  push ax
  push bx
  push cx
  pushf

  xor ah, ah
  ;GENERO DECENA
  mov cl, 10    ; guardo el valor por el que voy a dividir en cl
  div cl        ; Divido por 10 para obtener la decena
  add al, 30h   ;Paso a ascii
  mov [bx+0], al  ;Lo pongo en el bit mas significativo

  ;GENERO UNIDAD
  add ah, 30h   ;Paso el resto a ascii
  mov [bx+1], ah   ;Lo guardo en el byte menos significativo

  popf
  pop cx
  pop bx
  pop ax
  ret
regToAscii endp

end