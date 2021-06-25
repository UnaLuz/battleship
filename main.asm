.8086
.model small
.stack 100h
.data

  msjInicio   db "Las posiciones se determinan por la fila (A-J) y despues por la columna (0-9)", 0dh, 0ah, 24h
  msjError    db "No se pudo ubicar la nave", 0dh, 0ah, 24h
  msjBarcos   db "Ubique el barco ", 24h
  msjTam      db ", su tamanio es ", 24h
  msjIngreso  db "Ingrese una coordenada desde la fila (A-J) y la columna (0-9): ", 24h
  msjOrientacion db "Elija 0 (para horizontal) u otro caracter (para vertical): ", 24h
  msjMalPos   db "Esa no es una posicion correcta, ingrese <Esc> para salir o <Enter> para seguir", 0dh, 0ah, 24h
  msjPosErr   db "Ya se disparo en esa posicion", 0dh, 0ah, 24h
  msjFin      db "Fin del juego", 0dh, 0ah, 24h
  msjDisparoMaq db "The enemy is disparanding. Presione enter para continuar: ", 24h

  msjGanaste  db 0dh, 0ah, "Felicitaciones!", 0dh, 0ah
              ;db ∞€€€€€€ª∞∞€€€€€ª∞€€€ª∞∞€€ª∞€€€€€ª∞∞€€€€€€ª€€€€€€€€ª€€€€€€€ª, 0dh, 0ah
              ;db €€…ÕÕÕÕº∞€€…ÕÕ€€ª€€€€ª∞€€∫€€…ÕÕ€€ª€€…ÕÕÕÕº»ÕÕ€€…ÕÕº€€…ÕÕÕÕº, 0dh, 0ah
              ;db €€∫∞∞€€ª∞€€€€€€€∫€€…€€ª€€∫€€€€€€€∫»€€€€€ª∞∞∞∞€€∫∞∞∞€€€€€ª∞∞, 0dh, 0ah
              ;db €€∫∞∞»€€ª€€…ÕÕ€€∫€€∫»€€€€∫€€…ÕÕ€€∫∞»ÕÕÕ€€ª∞∞∞€€∫∞∞∞€€…ÕÕº∞∞, 0dh, 0ah
              ;db »€€€€€€…º€€∫∞∞€€∫€€∫∞»€€€∫€€∫∞∞€€∫€€€€€€…º∞∞∞€€∫∞∞∞€€€€€€€ª, 0dh, 0ah
              ;db ∞»ÕÕÕÕÕº∞»Õº∞∞»Õº»Õº∞∞»ÕÕº»Õº∞∞»Õº»ÕÕÕÕÕº∞∞∞∞»Õº∞∞∞»ÕÕÕÕÕÕº, 0dh, 0ah, 24h
              db 0B0h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0B0h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0B0h, 0DBh, 0DBh, 0BBh, 0B0h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0B0h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0dh, 0ah
              db 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 0B0h, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0DBh, 0DBh, 0BBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0DBh, 0DBh, 0BBh, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 0C8h, 0CDh, 0CDh, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0BCh, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 0dh, 0ah
              db 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0DBh, 0DBh, 0BBh, 0B0h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0C9h, 0DBh, 0DBh, 0BBh, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BAh, 0C8h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0B0h, 0B0h, 0B0h, 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0B0h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0B0h, 0dh, 0ah
              db 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0C8h, 0DBh, 0DBh, 0BBh, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0BAh, 0C8h, 0DBh, 0DBh, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0DBh, 0DBh, 0BAh, 0B0h, 0C8h, 0CDh, 0CDh, 0CDh, 0DBh, 0DBh, 0BBh, 0B0h, 0B0h, 0B0h, 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0B0h, 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0BCh, 0B0h, 0B0h, 0dh, 0ah
              db 0C8h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0C9h, 0BCh, 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0BAh, 0B0h, 0C8h, 0DBh, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0DBh, 0DBh, 0BAh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0C9h, 0BCh, 0B0h, 0B0h, 0B0h, 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0B0h, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0dh, 0ah
              db 0B0h, 0C8h, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 0B0h, 0C8h, 0CDh, 0BCh, 0B0h, 0B0h, 0C8h, 0CDh, 0BCh, 0C8h, 0CDh, 0BCh, 0B0h, 0B0h, 0C8h, 0CDh, 0CDh, 0BCh, 0C8h, 0CDh, 0BCh, 0B0h, 0B0h, 0C8h, 0CDh, 0BCh, 0C8h, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 0B0h, 0B0h, 0B0h, 0B0h, 0C8h, 0CDh, 0BCh, 0B0h, 0B0h, 0B0h, 0C8h, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 0dh, 0ah, 24h

  msjPerdiste  db 0dh, 0ah, "PERDISTE!! Que mal... La proxima version le bajamos la dificultad para vos :D!", 0dh, 0ah, 24h
              ;db €€€€€€€ª, 0dh, 0ah
              ;db €€…ÕÕÕÕº, 0dh, 0ah
              ;db €€€€€ª∞∞, 0dh, 0ah
              ;db €€…ÕÕº∞∞, 0dh, 0ah
              ;db €€∫∞∞∞∞∞, 0dh, 0ah
              ;db »Õº∞∞∞∞∞, 0dh, 0ah, 24h
  msjSurrender db 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0dh, 0ah
               db 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 0dh, 0ah
               db 0DBh, 0DBh, 0DBh, 0DBh, 0DBh, 0BBh, 0B0h, 0B0h, 0dh, 0ah
               db 0DBh, 0DBh, 0C9h, 0CDh, 0CDh, 0BCh, 0B0h, 0B0h, 0dh, 0ah
               db 0DBh, 0DBh, 0BAh, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0dh, 0ah
               db 0C8h, 0CDh, 0BCh, 0B0h, 0B0h, 0B0h, 0B0h, 0B0h, 0dh, 0ah, 24h

  salto db 0dh, 0ah, 24h
  bandera db 0
  Intentos db 17
  IntentosMaq db 17
  
  seed        dw 0
  weylseq     dw 0
  prevRandInt dw 0

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
    
  ;UBICACI?N DE BARCOS DEL USUARIO

    mov di, 0
    mov bx, offset tableroUser
    ubicarUnBarco:
    ;Le muestro el tablero
      cmp di, 5 ;Si el contador es 5, entonces significa que se ubicaron los 5 barcos
      je inicio ;Voy a ubicar los barcos de la compu
      mov ah, 9
      mov dx, bx ;Muevo el offset del tablero
      int 21h
      call pedirBarco
      inc di ;Incremento el contador de barcos
      call Clearscreen
      jmp ubicarUnBarco


;UBICACI?N DE BARCOS DE LA M?QUINA

inicio:
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di
    
    mov bx, offset tableroMaquina
    
  ; Porta-aviones PPPPP
  ubicarP:
    mov bandera[0], 0 ;Reinicio la bandera
    call generarFyC
    call ElijeHoV
    mov si, ax ;Muevo el valor de la orientaci?n devuelta por ElijeHoV
    mov al, "P" ;Quiero un porta-aviones
    mov cl, colW ;Muevo la cantidad de caracteres por columna del tablero
    mov ch, chars ;Muevo la cantidad de caracteres por fila
    call ubicarBarco
    mov si, offset bandera ;Muevo el offset de la bandera para que pueda activarla, en caso de necesitarlo
    call ponerBarco ;Tambi?n le paso el indice por DI
    cmp bandera[0], 1 ;Comparo si se activ? la bandera de error
    je ubicarP ;Si es as?, entonces se ubica de nuevo

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
    call ponerBarco
    cmp bandera[0], 1
    je ubicarB

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
    call ponerBarco
    cmp bandera[0], 1
    je ubicarD

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
    call ponerBarco
    cmp bandera[0], 1
    je ubicarS

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
    call ponerBarco
    cmp bandera[0], 1
    je ubicarC
  
imprimir:
    ;Una vez ubicados los barcos, imprimo el tablero
    mov ah, 9
    mov dx, offset tablero
    int 21h

;DISPARO DEL USUARIO   

ingresoPos:
    ;Pido que ingrese una posici?n a atacar
    mov ah, 9
    mov dx, offset msjIngreso
    int 21h
    ;Leo el primer caracter
    mov ah, 1
    int 21h
    ;Chequeo que sea una letra v?lida
    cmp al, "a"
    jb checkLetra
    cmp al, "j"
    ja malPos
    ;Es una letra min?scula, la cambio a may?scula
    sub al, 20h

checkLetra:
    cmp al, "A"
    jb malPos
    cmp al, "J"
    ja malPos
    ;Es una letra v?lida as? que la guardo el DH
    mov dh, al
    ;Leo el siguiente caracter
    mov ah, 1
    int 21h
    ;Chequeo que sea un n?mero
    cmp al, "0"
    jb malPos
    cmp al, "9"
    ja malPos
    ;Es un n?mero v?lido, as? que lo guardo en DL
    mov dl, al
    ;Ahora tengo la posici?n guardada en DX

    mov cl, colW
    mov ch, chars
    ;Muevo las variables necesarias para las funciones
    call obtenerIndice
    mov si, offset tablero
    mov bx, offset tableroMaquina
    call disparar
    ;Chequeo si el disparo fue exitoso o no
    cmp al, 0 ;Hubo un error, no se puede disparar en esa posici?n
    je nuevoIntento
    
    cmp al, 1
    je continuar

    cmp al, 2
    jne nuevoIntento

    dec Intentos[0]  ;Intentos guarda la cantidad de disparos existosos restante para ganar. Se decrementa si se efectua un disparo exitoso
    cmp Intentos[0], 0  ;Si Intentos llega a 0, el jugador obtendr? la victoria
    je fin_auxiliar

    jmp continuar

  fin_auxiliar:
    ;Salto auxiliar porque no alcanzan los bytes del JE
    jmp fin

    nuevoIntento:
    mov ah, 9                 
    mov dx, offset salto
    int 21h
    mov ah, 9
    mov dx, offset msjPosErr
    int 21h
    jmp ingresoPos

    continuar:
    ;Vuelvo a pedir una nueva posicion a disparar
    mov ah, 08h ;Espero otra tecla sin imprimir en pantalla para que pueda leer la posici?n ingresada
    int 21h
    jmp seguir

    ;No se ingres? una posici?n v?lida
  malPos:
    mov ah, 9
    mov dx, offset salto
    int 21h
    ;Informo que no lo era
    mov ah, 9
    mov dx, offset msjMalPos
    int 21h

  leerTecla:
    ;Espero confirmaci?n del usuario para seguir o salir
    mov ah, 08h ;Leer sin eco en la pantalla
    int 21h
    ;Si apreto <Esc> termino del programa
    cmp al, 1Bh
    je fin
    ;Si apreto <Enter> vuelvo a pedir que ingrese una posicion valida
    cmp al, 0dh
    je vuelta
    ;Si ingreso cualquier otra cosa sigo esperando
    jmp leerTecla


  seguir:
    call Clearscreen
    ;Imprimir tablero
    mov ah, 9
    mov dx, offset tablero
    int 21h

    mov ah, 9
    mov dx, offset msjDisparoMaq ;Imprimo un mensaje para avisar que la m?quina est? efectuando un disparo
    int 21h
    

;DISPARO DE LA M?QUINA

  disparoMaq:
    call generarFyC
    mov cl, colW
    mov ch, chars
    call obtenerIndice
    mov bx, offset tableroUser
    mov si, offset tableroUser
    call disparar

    cmp al, 0
    je disparoMaq

    cmp al, 1
    je aguaMaq

    dec IntentosMaq[0]
    cmp IntentosMaq[0], 0
    je fin
    
aguaMaq:
    ;Espero otra tecla sin imprimir en pantalla para que pueda leer la posicion ingresada
    mov ah, 08h
    int 21h
vuelta:
    ;Limpio la pantalla antes de volver a mostrar el tablero
    call Clearscreen
    jmp imprimir

fin:
    call Clearscreen

    cmp Intentos[0], 0
    je ganaste 
    ;quiero creer que si la m?quina no es 0 (ganamos), entonces el nuestro es 0 (perdimos) 
    ; ....pues no (?) XD
    cmp IntentosMaq[0], 0
    jne surrender

    mov ah, 9
    mov dx, offset msjPerdiste
    int 21h
    mov ah, 9
    mov dx, offset msjSurrender
    int 21h
    ; mov ah, 9
    ; mov dx, offset tableroUser
    ; int 21h
    jmp fin1

  ganaste:
    mov ah, 9
    mov dx, offset msjGanaste
    int 21h
    ; mov ah, 9
    ; mov dx, offset tablero
    ; int 21h
    jmp fin1

  surrender:
    mov ah, 9
    mov dx, offset msjSurrender
    int 21h

  fin1:
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


;Recibe por AX un seed o 0 para usar el existente
; por SI el offset de la secuencia de weyl
;y por DI el offset del numero random anterior
;devuelvo en DX la posicion random
generarFyC proc
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
;Recibe por AX un seed
  ; por SI la secuencia de weyl
  ; y por DI el numero random anterior
  ;devuelvo en AL la posicion random
ElijeHoV proc
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
    mov dh, al ;la fila est? en DH
    mov ah, 1
    int 21h
    mov dl, al ;la columna est? en DL
    ;Transformamos a mayuscula
    cmp dh, 4Ah ;comparon con J
    jl prosigo

    sub dh, 20h


  prosigo:
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
    mov si, ax ;la orientaci?n est? en SI
    sub si, 30h

    mov al, letrasBarcos[di] ;la letra queda guardada en AL
    mov cl, colW
    mov ch, chars
    push di
    call ubicarBarco

    mov si, offset bandera
    call ponerBarco ;tambi?n le paso el ?ndice por DI
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