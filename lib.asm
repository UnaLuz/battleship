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
  public chequearError
  public ubicarBarco
  public ponerBarco


  ; Recibo las coordenadas por DX (ej: DX = "B6")
  ; Recibo el ancho de las columnas por CL
  ; Recibo el largo de las filas por CH
  ; Devuelvo el índice correspondiente por DI
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
; el offset del tableroMaquina por BX
; y el offset del tablero visible al usuario en SI
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
  mov bx, si
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


chequearError proc
  push ax
  push dx
  pushf
  cmp cx, 0
  jne finChequeo
  mov ah, 9
  int 21h
  finChequeo:
  popf
  pop dx
  pop ax
  ret
chequearError endp

; Recibo el simbolo del barco por AL
; El offset del tablero por BX
; Las coordenadas por DX
; y si es horizontal u vertical por SI
; Devuelve por CX 0 si se le pasa un simbolo de barco erroneo, si no devuelve el tamanio del barco
; el indice por DI
; en DX los caracteres por fila o columna, segun si es vertical u horizontal
ubicarBarco proc
;Cuido el entorno
  push ax
  push bx
  push si
  pushf

  call obtenerIndice ;Me devuelve las coordenadas transformadas en un indice por DI

  mov dx, 0 ; Limpio dx
  cmp si, 0
  je horizontal
  add dl, ch    ; paso el largo de cada fila a DL para que se ubique de forma vertical
  jmp simbolo
  horizontal:
  add dl, cl    ;paso el ancho de cada columna para que sea horizontal

  simbolo:
  mov cx, 0
; Porta-aviones PPPPP
; Nave de batalla BBBB
; Crucero de batalla CCC
; Submarino SSS
; Destructor DD
  cmp al, "P"
  je portaAviones
  cmp al, "B"
  je naveBatlla
  cmp al, "C"
  je crucero
  cmp al, "S"
  je submarino
  cmp al, "D"
  je destructor
  ;no era ninguno, es un barco erroneo
  jmp salir

  portaAviones:
  add cx, 1   ;Tamanio 5
  naveBatlla:
  add cx, 1   ;Tamanio 4
  crucero:
  submarino:
  add cx, 1   ;Ambos de tamanio 3
  destructor:
  add cx, 2   ;Tamanio 2

salir:
  popf
  pop si
  pop bx
  pop ax
  ret
ubicarBarco endp

  ; Recibe AL el caracter para representar el barco
  ; en BX el offset del tablero
  ; Por SI el offset de la bandera
  ; en DI la coordenada en X + la coordenada en Y multiplicada por la cantidad de columnas (la posicion correspondiente)
  ; en DX la cantidad de caracteres por fila (para ubicar verticalmente) o tamanio de las columnas (para ubicar horizontalmente)
  ; y en CX el tamanio del barco a colocar
ponerBarco proc
  ;Cuido el entorno
  push ax
  push bx   ; El offset del tablero no me interesa modificarlo asi que por las dudas lo guardo, para no romper nada
  push cx
  push dx
  push si
  push di
  pushf

  call comprobar_lugar
  cmp byte ptr [si], 1
  je fin_ponerBarco

  barco:
    mov byte ptr [bx + di], al ; Pongo un simbolo  en la posicion DI del tablero
    add di, dx ; Le sumo los caracteres que hay por fila para pasar a la fila de abajo
    loop barco

  fin_ponerBarco:
  popf
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret
ponerBarco endp

comprobar_lugar proc
  ;Por Bx espera el offset del tablero
  ; por DX la cantidad de caracteres por fila o columna.
    ;creo esta función para no modificar los registros en ponerBarco
  ;Cuido el entorno
  push ax
  push bx   ; El offset del tablero no me interesa modificarlo asi que por las dudas lo guardo, para no romper nada
  push cx
  push dx
  push di
  push si
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

  fin_comprobar_lugar:
  popf
  pop si
  pop di
  pop dx
  pop cx
  pop bx
  pop ax
  ret
comprobar_lugar endp

end