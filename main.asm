.8086
.model small
.stack 100h
.data
; Porta-aviones PPPPP
; Nave de batalla BBBB
; Crucero de batalla CCC
; Submarino SSS
; Destructor DD
  msj db "Ingrese Y para continuar, otra tecla para salir", 0dh, 0ah, 24h
  msjError db "No se pudo ubicar la nave, simbolo incorrecto", 0dh, 0ah, 24h
  bandera db 0

  seed        dw 0
  weylseq     dw 0
  prevRandInt dw 0

  impTablero db "El tablero:", 0dh, 0ah, 0dh, 0ah

  tablero   db "x-------------------------------------------x ", 0dh, 0ah
            db "|   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | ", 0dh, 0ah
            db "| A | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| B | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| C | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| D | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| E | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| F | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| G | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| H | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| I | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "| J | . | . | . | . | . | . | . | . | . | . | ", 0dh, 0ah
            db "x-------------------------------------------x ", 0dh, 0ah, 24h
  chars db 48  ;Cantidad de caracteres por fila
  rows db 12  ;Cantidad de filas
  colW db 4   ;Cantidad de caracteres por columna del tablero

.code
; Importo funciones de la libreria
extrn comprobar_lugar:proc
extrn obtenerIndice:proc
extrn seedInicial:proc

  main proc
    mov ax, @data
    mov ds, ax

    call seedInicial
    ;Inicializo las tres variables con el seed porque si no hay patrones
    mov seed, ax
    mov weylseq, ax
    mov prevRandInt, ax

inicio:
    call Clearscreen

    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di
    
    mov bx, offset tablero


ubicarP:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "P" ;Quiero un porta-aviones
    call ubicarBarco
    cmp bandera[0], 1
    je ubicarP
    call chequearError

ubicarB:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "B" ;Quiero una nave de batalla
    call ubicarBarco
    cmp bandera[0], 1
    je ubicarB
    call chequearError

ubicarD:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "D" ;Quiero un destructor
    call ubicarBarco
    cmp bandera[0], 1
    je ubicarD
    call chequearError

ubicarS:
    mov bandera[0], 0
    call generarFyC 
    call ElijeHoV
    mov si, ax
    mov al, "S" ;Quiero un submarino
    call ubicarBarco
    cmp bandera[0], 1
    je ubicarS
    call chequearError

ubicarC:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "C" ;Quiero un crucero
    call ubicarBarco
    cmp bandera[0], 1
    je ubicarC
    call chequearError
  
imprimir:
    ; Imprimir tablero
    mov ah, 9
    mov dx, offset impTablero
    int 21h

    ; mov ah, 9
    ; mov dx, offset msj
    ; int 21h

    ; mov ah, 1
    ; int 21h

    ; cmp al, "y"
    ; jne fin

    ; jmp inicio

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

  ; Recibe en BX el offset del tablero
  ; en DI la coordenada en X + la coordenada en Y multiplicada por la cantidad de columnas (la posicion correspondiente)
  ; en DX la cantidad de caracteres por fila (para ubicar verticalmente) o tama??o de las columnas (para ubicar horizontalmente)
  ; en AL el caracter para representar el barco
  ; y en CX el tama??o del barco a colocar
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

    mov si, offset bandera
    call comprobar_lugar
    cmp bandera[0], 1
    je fin_ponerBarco

  barco:
        mov byte ptr [bx + di], al ; Pongo un simbolo  en la posicion DI del tablero
        add di, dx ; Le sumo los caracteres que hay por fila para pasar a la fila de abajo
        loop barco

    fin_ponerBarco:
    ; mov bandera[0], 0 ;reinicio la bandera
  popf
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret
ponerBarco endp


; Recibo el simbolo del barco por AL
; El offset del tablero por BX
; Las coordenadas por DX
;y si es horizontal u vertical por SI
;Devuelve por CX 0 si se le pas? un simbolo de barco erroneo
ubicarBarco proc
;Cuido el entorno
  push ax
  push bx
  push dx
  push di
  pushf
  xor cx, cx

  mov cl, colW
  mov ch, chars
  call obtenerIndice ;Me devuelve las coordenadas transformadas en un ?ndice por DI

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
  add cx, 1   ;Tama?o 5
  naveBatlla:
  add cx, 1   ;Tama?o 4
  crucero:
  submarino:
  add cx, 1   ;Ambos de tama?o 3
  destructor:
  add cx, 2   ;Tama?o 2

  call ponerBarco ; Tambien le paso el indice por DI

salir:
  popf
  pop di
  pop dx
  pop bx
  pop ax
  ret
ubicarBarco endp

chequearError proc
  push ax
  push dx
  pushf
  cmp cx, 0
  jne finChequeo
  mov ah, 9
  mov dx, offset msjError
  int 21h
  finChequeo:
  popf
  pop dx
  pop ax
  ret
chequearError endp

generarFyC proc
    ;Recibe por AX un seed o 0 para usar el existente
    ; por SI el offset de la secuencia de weyl
    ;y por DI el offset del numero random anterior
    ;devuelvo en DX la posicion random
    ;cuido el entorno
    push bx
    pushf

    mov ax, seed
    mov si, weylseq
    mov di, prevRandInt
    int 81h   ;Genero un numero random
    ;Recibo por AX el numero random
    mov weylseq, si
    mov prevRandInt, ax

    xor ah, ah  ;Limpio AH para la division de 8bits
    mov bl, 0Ah
    div bl

    add ah, 41h    ;Convierto a numero ascii el resto
    mov dh, ah

    xor ah, ah  ;Limpio AH para la division de 8bits
    mov bl, 0Ah
    div bl

    add ah, 30h    ;Convierto a ascii el resto
    mov dl, ah

    ;devuelvo el entorno
    popf
    pop bx
    ret
generarFyC endp
  
;Elige de forma aleatoria si el barco ser? vertical u horizontal
ElijeHoV proc
  ;Recibe por AX un seed o 0 para usar el existente
    ; por SI el offset de la secuencia de weyl
    ;y por DI el offset del numero random anterior
    ;devuelvo en DX la posicion random
    ;cuido el entorno
    push si
    push dx
    push bx
    pushf

    mov ax, seed
    mov si, weylseq
    mov di, prevRandInt
    int 81h   ;Genero un numero random
    ;Recibo por AX el numero random
    mov weylseq, si
    mov prevRandInt, ax

    xor ah, ah  ;Limpio AH para la division de 8bits
    mov bl, 2
    div bl

    mov al, ah
    xor ah, ah

    ;devuelvo el entorno
    popf
    pop bx
    pop dx
    pop si
    ret
ElijeHoV endp

end main