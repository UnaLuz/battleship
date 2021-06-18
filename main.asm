.8086
.model small
.stack 100h
.data
  ;msj         db "Ingrese Y para continuar, otra tecla para salir", 0dh, 0ah, 24h
  msjInicio   db "Las posiciones se determinan por la fila (A-J) y despues por la columna (0-9)", 0dh, 0ah, 24h
  msjIntentos db "Intentos disponibles: ", 24h
  msjError    db "No se pudo ubicar la nave, simbolo incorrecto", 0dh, 0ah, 24h
  msjBarcos   db "Ubique el barco ", 24h
  msjTam      db ", su tamanio es ", 24h
  msjIngreso  db "Ingrese una coordenada desde la fila (A-J) y la columna (0-9): ", 24h
  msjOrientacion db "Elija 0 (para horizontal) u otro caracter (para vertical): ", 24h
  msjMalPos   db "Esa no es una posicion correcta, ingrese <Esc> para salir o <Enter> para seguir", 0dh, 0ah, 24h
  msjPosErr   db "Ya se disparo en esa posicion", 0dh, 0ah, 24h
  msjFin      db 0dh, 0ah, "Fin del juego", 0dh, 0ah, 24h
  salto db 0dh, 0ah, 24h
  bandera db 0
  Intentos db 17
  IntentosAscii db "17", 0dh, 0ah, 24h

  seed        dw 0
  weylseq     dw 0
  prevRandInt dw 0

  ; impTablero  db "Tableros:", 0dh, 0ah, 0dh, 0ah

  ;Estos son los tableros que ve el usuario
  tablero   db "x--------Enemy---------x", 0dh, 0ah
            db "|  0 1 2 3 4 5 6 7 8 9 |", 0dh, 0ah
            db "|a . . . . . . . . . . |", 0dh, 0ah
            db "|b . . . . . . . . . . |", 0dh, 0ah
            db "|c . . . . . . . . . . |", 0dh, 0ah
            db "|d . . . . . . . . . . |", 0dh, 0ah
            db "|e . . . . . . . . . . |", 0dh, 0ah
            db "|f . . . . . . . . . . |", 0dh, 0ah
            db "|g . . . . . . . . . . |", 0dh, 0ah
            db "|h . . . . . . . . . . |", 0dh, 0ah
            db "|i . . . . . . . . . . |", 0dh, 0ah
            db "|j . . . . . . . . . . |", 0dh, 0ah
tableroUser db "x--------Player--------x", 0dh, 0ah
            db "|  0 1 2 3 4 5 6 7 8 9 |", 0dh, 0ah
            db "|a . . . . . . . . . . |", 0dh, 0ah
            db "|b . . . . . . . . . . |", 0dh, 0ah
            db "|c . . . . . . . . . . |", 0dh, 0ah
            db "|d . . . . . . . . . . |", 0dh, 0ah
            db "|e . . . . . . . . . . |", 0dh, 0ah
            db "|f . . . . . . . . . . |", 0dh, 0ah
            db "|g . . . . . . . . . . |", 0dh, 0ah
            db "|h . . . . . . . . . . |", 0dh, 0ah
            db "|i . . . . . . . . . . |", 0dh, 0ah
            db "|j . . . . . . . . . . |", 0dh, 0ah, 24h
            ; db "x----------------------x", 24h
  ;Este tablero seria el que hay que editar con los barcos random

  tableroMaquina  db "x----------------------x", 0dh, 0ah
                  db "|  0 1 2 3 4 5 6 7 8 9 |", 0dh, 0ah
                  db "|a . . . . . . . . . . |", 0dh, 0ah
                  db "|b . . . . . . . . . . |", 0dh, 0ah
                  db "|c . . . . . . . . . . |", 0dh, 0ah
                  db "|d . . . . . . . . . . |", 0dh, 0ah
                  db "|e . . . . . . . . . . |", 0dh, 0ah
                  db "|f . . . . . . . . . . |", 0dh, 0ah
                  db "|g . . . . . . . . . . |", 0dh, 0ah
                  db "|h . . . . . . . . . . |", 0dh, 0ah
                  db "|i . . . . . . . . . . |", 0dh, 0ah
                  db "|j . . . . . . . . . . |", 0dh, 0ah
                  db "x----------------------x", 24h

  letrasBarcos db "PBDSC"
  tamBarcos db "54233"
  chars db 26  ;Cantidad de caracteres por fila
  colW db 2   ;Cantidad de caracteres por columna del tablero

.code
; Importo funciones de la libreria
extrn comprobar_lugar:proc
extrn obtenerIndice:proc
extrn seedInicial:proc
extrn disparar:proc
extrn regToAscii:proc
extrn chequearError:proc
extrn ubicarBarco:proc
extrn ponerBarco:proc

  main proc
    mov ax, @data
    mov ds, ax

    call seedInicial
    ;Inicializo las tres variables con el seed porque si no hay patrones
    mov seed, ax
    mov weylseq, ax
    mov prevRandInt, ax
    call Clearscreen

    mov ah, 9
    mov dx, offset msjInicio
    int 21h
    
    mov di, 0
    mov bx, offset tableroUser
    ubicarUnBarco:
    ;Le muestro el tablero
      cmp di, 5
      je inicio
      mov ah, 9
      mov dx, bx
      int 21h
      call pedirBarco
      inc di
      call Clearscreen
      jmp ubicarUnBarco

inicio:
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di
    
    mov bx, offset tableroMaquina

    ; mov bx, offset tablero

; Porta-aviones PPPPP
ubicarP:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "P" ;Quiero un porta-aviones
    mov cl, colW
    mov ch, chars
    call ubicarBarco
    mov si, offset bandera
    call ponerBarco ; Tambien le paso el indice por DI
    cmp bandera[0], 1
    je ubicarP
    mov dx, offset msjError
    call chequearError

; Nave de batalla BBBB
ubicarB:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "B" ;Quiero una nave de batalla
    mov cl, colW
    mov ch, chars
    call ubicarBarco
    mov si, offset bandera
    call ponerBarco ; Tambien le paso el indice por DI
    cmp bandera[0], 1
    je ubicarB
    mov dx, offset msjError
    call chequearError

; Destructor DD
ubicarD:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "D" ;Quiero un destructor
    mov cl, colW
    mov ch, chars
    call ubicarBarco
    mov si, offset bandera
    call ponerBarco ; Tambien le paso el indice por DI
    cmp bandera[0], 1
    je ubicarD
    mov dx, offset msjError
    call chequearError

; Submarino SSS
ubicarS:
    mov bandera[0], 0
    call generarFyC 
    call ElijeHoV
    mov si, ax
    mov al, "S" ;Quiero un submarino
    mov cl, colW
    mov ch, chars
    call ubicarBarco
    mov si, offset bandera
    call ponerBarco ; Tambien le paso el indice por DI
    cmp bandera[0], 1
    je ubicarS
    mov dx, offset msjError
    call chequearError

; Crucero de batalla CCC
ubicarC:
    mov bandera[0], 0
    call generarFyC
    call ElijeHoV
    mov si, ax
    mov al, "C" ;Quiero un crucero
    mov cl, colW
    mov ch, chars
    call ubicarBarco
    mov si, offset bandera
    call ponerBarco ; Tambien le paso el indice por DI
    cmp bandera[0], 1
    je ubicarC
    mov dx, offset msjError
    call chequearError
  
imprimir:
    ; mov ah, 9
    ; mov dx, offset msjIntentos
    ; int 21h

    mov bx, offset IntentosAscii
    mov al, Intentos[0]
    call regToAscii

    ; mov ah, 9
    ; mov dx, offset IntentosAscii
    ; int 21h

    ; Imprimir tablero
    mov ah, 9
    mov dx, offset tablero
    int 21h

    ; mov ah, 9
    ; mov dx, offset tableroMaquina

    ; int 21h
    ;mov ah, 9
    ;mov dx, offset titulo
    ;int 21h

    ;Pido que ingrese una posicion a atacar
    mov ah, 9
    mov dx, offset msjIngreso
    int 21h
    ;Leo el primer caracter
    mov ah, 1
    int 21h
    ;Chequeo que sea una letra valida
    cmp al, "a"
    jb checkLetra
    cmp al, "j"
    ja malPos
    ;Es una letra minuscula, la cambio a mayuscula
    sub al, 20h

checkLetra:
    cmp al, "A"
    jb malPos
    cmp al, "J"
    ja malPos
    ;Es una letra valida asi que la guardo el DH
    mov dh, al
    ;Leo el siguiente caracter
    mov ah, 1
    int 21h
    ;Chequeo que sea un numero
    cmp al, "0"
    jb malPos
    cmp al, "9"
    ja malPos
    ;Es un numero valido asi que lo guardo en DL
    mov dl, al
    ;Ahora tengo la posicion guardada en DX

    mov cl, colW
    mov ch, chars
    call obtenerIndice
    mov si, offset tablero
    mov bx, offset tableroMaquina
    call disparar
    ; Chequeo si el disparo fue exitoso o no
    cmp al, 0   ;Hubo un error, no se puede disparar en esa posicion
    je nuevoIntento
    
    cmp al, 1
    je continuar

    cmp al, 2
    jne nuevoIntento

    dec Intentos[0]
    cmp Intentos[0], 0
    je fin

    jmp continuar

    nuevoIntento:
    mov ah, 9
    mov dx, offset salto
    int 21h
    mov ah, 9
    mov dx, offset msjPosErr
    int 21h
    
    continuar:
    ;Espero otra tecla sin imprimir en pantalla para que pueda leer la posicion ingresada
    mov ah, 08h
    int 21h
    jmp seguir

    ;No ingreso una posicion valida
  malPos:
    mov ah, 9
    mov dx, offset salto
    int 21h
    ;Informo que no lo era
    mov ah, 9
    mov dx, offset msjMalPos
    int 21h

  leerTecla:
    ;Espero confirmacion del usuario a seguir o salir
    mov ah, 08h   ;Leer sin eco en la pantalla
    int 21h
    ;Si apreto <Esc> termino del programa
    cmp al, 1Bh
    je fin
    ;Si apreto <Enter> vuelvo a pedir que ingrese una posicion valida
    cmp al, 0dh
    je seguir
    ;Si ingreso cualquier otra cosa sigo esperando
    jmp leerTecla

  seguir:
    mov ah, 9
    mov dx, offset salto
    int 21h
    ;Limpio la pantalla antes de volver a mostrar el tablero
    call Clearscreen
    jmp imprimir

    fin:
    mov ah, 9
    mov dx, offset msjFin
    int 21h
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


generarFyC proc
    ;Recibe por AX un seed o 0 para usar el existente
    ; por SI el offset de la secuencia de weyl
    ;y por DI el offset del numero random anterior
    ;devuelvo en DX la posicion random
    ;cuido el entorno
    push ax
    push bx
    push si
    push di
    pushf

    xor dx, dx

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
    pop di
    pop si
    pop bx
    pop ax
    ret
generarFyC endp
  
;Elige de forma aleatoria si el barco sera vertical u horizontal
ElijeHoV proc
  ;Recibe por AX un seed
    ; por SI la secuencia de weyl
    ; y por DI el numero random anterior
    ;devuelvo en AL la posicion random
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


; Recibe por BX el offset del tablero
; por DI el indice de la letra del barco
pedirBarco proc
  push ax
  push bx
  push cx
  push dx
  push di
  push si
    

  ubicarBarcoUser:
    mov bandera[0], 0

    mov ah, 9
    mov dx, offset msjBarcos
    int 21h

    mov ah, 2
    mov dl, letrasBarcos[di]
    int 21h

    mov ah, 9
    mov dx, offset msjTam
    int 21h

    mov ah, 2
    mov dl, tamBarcos[di]
    int 21h

    mov ah, 9
    mov dx, offset salto
    int 21h
  
    mov ah, 9
    mov dx, offset msjIngreso
    int 21h

    mov ah, 1
    int 21h
    mov dh, al ;la fila est  en DH
    mov ah, 1
    int 21h
    mov dl, al ;la columna est  en DL
    push dx

    mov ah, 9
    mov dx, offset salto
    int 21h

    mov ah, 9
    mov dx, offset msjOrientacion
    int 21h

    pop dx
    mov ah, 1
    int 21h
    xor ah, ah
    mov si, ax ;la orientaci¢n est  en SI
    sub si, 30h

    mov al, letrasBarcos[di] ;la letra queda guardada en AL
    mov cl, colW
    mov ch, chars
    push di
    call ubicarBarco

    mov si, offset bandera
    call ponerBarco ;tambi‚n le paso el ¡ndice por DI
    pop di

    cmp bandera[0], 1
    je mensaje
    jmp finPedirBarco

  mensaje:
    mov ah, 9
    mov dx, offset salto
    int 21h
    mov ah, 9
    mov dx, offset msjError
    int 21h
    jmp ubicarBarcoUser

  finPedirBarco:
  pop si
  pop di
  pop dx
  pop cx
  pop bx
  pop ax
  ret
pedirBarco endp



end main