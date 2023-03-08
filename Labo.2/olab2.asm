;DANIEL MOLINA 1007420
;IHOSEM OROZCO 1047920
;Carlos Fonseca 1243020
title laboratorio2
;STACK 64
.model small
.stack 64
.data 
;Declaramos los mensajes que seran mostrados en pantalla en el juego 
Niveles db 00h 
intact db 254 DUP(?),'$' ;Muestra en cada momento el hanged
points db 0 ,'$';MUESTRA EL ALMACEN DE PUNTOS DEL JUEGO
rompe  db 0dh, 0ah, '$'
intento db 0 ; CUENTA LOS intento QUE TIENE LA PERSONA
;Separaciones en el codigo
separacion db  '         ', '$'
Reglas DB '------------------------LAB2------------------------------',0DH,0AH
DB 'El juego consiste en adivinar adivinar palabras de 5 letras. Debe', 0DH, 0AH
DB 'ingresar una letra a la vez. Tiene 5 intentos y son 4 palabras en total.', 0DH, 0AH
DB 'Al terminar obtendra su punteo final o puede presionar alt+x para ', 0DH, 0AH
DB 'salir y ver sus puntos. El valor maximo es 200. Daniel, Ihosem, Carlos', 0DH, 0AH
DB '-----------------------------------------------------------------',0DH,0AH, '$'
;Mansajes que se muestran cada vez que falla
comp   db  '     o   ',0dh, 0ah
       db  '   / | \ ',0dh, 0ah
	   db  '     |   ',0dh, 0ah
       db  '    / \  ',0dh, 0ah,'$'

;CUANDO SE EQUIVOCA LA PRIMERA VEZ SALE LA CABEZA Y ABDOMEN
error1 db  '----|    ',0dh, 0ah    
       db  '    o    ',0dh, 0ah
	   db  '    |    ',0dh, 0ah
	   db  '    |    ',0dh, 0ah, '$'
       
;CUANDO SE EQUIVOCA LA SEGUNDA VEZ SALE EL BRAZO DERECHO
error2 db  '----|    ',0dh, 0ah    
       db  '    o    ',0dh, 0ah
	   db  '    |    ',0dh, 0ah
       db  '  / |    ',0dh, 0ah, '$'

;CUANDO SE EQUIVOCA LA TERCERA VEZ SALE EL BRAZO IZQUIERDO
error3 db  '----|    ',0dh, 0ah    
       db  '    o    ',0dh, 0ah
	   db  '    |    ',0dh, 0ah
       db  '  / | \  ',0dh, 0ah, '$'
	   
;CUANDO SE EQUIVOCA LA CUARTA VEZ SALE EL PIE DERECHO
error4 db  '----|    ',0dh, 0ah    
       db  '    o    ',0dh, 0ah
	   db  '    |    ',0dh, 0ah
       db  '  / | \  ',0dh, 0ah
       db  '   /     ',0dh, 0ah, '$'
;CUANDO SE EQUIVOCA LA QUINTA VEZ SALE EL PIE DERECHO Y FERDIO
error5 db  '----|    ',0dh, 0ah    
       db  '    o    ',0dh, 0ah
	   db  '    |    ',0dh, 0ah
       db  '  / | \  ',0dh, 0ah
       db  '   / \   ',0dh, 0ah, '$'
;TODAS LAS VARIABLES DEL USUARIO QUE TIENEN PARAR VER EL PROGRESO DEL JUEGO
pro db 'Progreso: ', 0dh, 0ah,24h,'$';Variable para almacenar el progreso que lleva
termina db 'Perdiste :o', 0dh, 0ah,24h,'$';termina el juego perdio
puntaje db 'Punteo: ', 0dh, 0ah,24h,'$';Almacen del tiempo que lleva
campeon db 'GANASTE!!! ', 0dh, 0ah,24h,'$'; termina el juego gano
posx db 10,13, 'Posicion en la que se encuentra $'
posx2 db 'si esta',0dh, 0ah,24h,'$';valida si la letra esta
posx3 db 'no esta',0dh, 0ah,24h,'$';valida que la letra no esta
letter db 'Ingrese una letra: ', 0dh, 0ah,24h,'$';Aqui ingresa las letras que seran validadas como buenas o malas
enters db 0dh, 0ah, 24h,'$'
resultado db 10,13,'Punteo actual: $';Punteo en el que lleva 
copia db 'Repitio la letra','$';escribio la misma letra
centenas db ? ,'$'
decenas db ? ,'$'
cero db 30h ,'$'

;almacen de las words que son utilizadas correctas en el hanged
word1 db 'canto','$';Palabra 1
word2 db 'patos','$';Palabra 2
word3 db 'robar','$';Palabra 3
word4 db 'mango','$';Palabra 4

;VARIABLES PARA IDENTIFICAR LAS PALABRAS O LAS LETRAS
progreso  db 5 DUP(?),'$' ;Progresso de la persona
No_muestra db '*****','$' ;LETRAS QUE NO PUEDE SER MOSTRADA EN EL AHORCADO
letra_adi db 5 DUP(?),'$' ;LA CANTIDAD DE LETRAS QUE EL JUGADOR TIENE QUE ADIVINARR (5)

;COMPROBAMOS NUESTRAS VARIABLES
cont db 0h
resWord db 4
resLetra db 5
caracter db ?
posicion db ?
valor db ?
paso db 0 

;--------------------------
;COMENZAMOS CON EL CODIGO
;--------------------------

.386
.code

main proc far
begin:
    mov ax, @data ;mover direccion dseg a ax
    mov ds,ax 
    mov es,ax
 
	MOV AH,00   
	;----FONDO DE PANTALLA VERDE
    MOV AL,03   ;SET DE COLORES EN EL PROGRAMA
    INT 10H
    MOV AH,09    ;MUESTRA TODO
    MOV BH,00    ;PAGINA 0
    MOV AL,20H   ; CODIGO ASCII
    MOV CX,1000H   ;REPETIR EL COLOR EN 800H
    MOV BL,2FH    ;COLOR
    INT 10H
    mov cx,5  
	mov ah, 09h
        lea dx,reglas
		  int 21H
		  mov ah, 09h
        lea dx,comp
		  int 21H
    lea si,word1 ;toma la primera letra y la convierte en la priemra palabra
    lea di,letra_adi
    rep movsb
  
  ;mostrando el progreso que se tiene si adivina o no
    mov cx,5    
    lea si,No_muestra
    lea di,progreso
    rep movsb

;LIMPIAR LA PANTALLA DEL JUEGO
input:
        cmp paso,1 ;condicion 
        je ganador;ganador
        mov cont,0;contador que se muestra cuando adivina
        cmp resLetra,0 ;compara las letras de la palabra
        je Cambiow;
        
		;COntamos los puntos que se tienen
        call mostrar_points
        lea dx, intact
        call output
        lea dx, enters
        call output
        lea dx,progreso;Mostramos como va el progreso del juego
        call output
        lea dx, enters
        call output
        lea dx, letter ;pedimos una letra al usuario
        call output
        lea dx, enters
        call output

        ;recibimos un caracter
        mov ah,10h 
        int 16h    ; se guarda el caracter
		cmp ax,2d00h ;ALT+X
		;SALIDAS
  		je salida
        mov cx,5   ;Verifica en la cadena si la letra ya fue ingresada
        lea di,progreso
        repne scasb 
        je repetir
        mov bx,5 ;largo de las cadenas (5)
Existe:

;Letras de verificacion
	cmp [letra_adi+bx],al
	je remp
	jne avanzar

 remp:
;Guardamos el progreso y lo almacenamos
	sub resLetra,1
	add cont,1                
	mov [progreso+bx],al

;avanzamos en el trabajo mostrado
 avanzar:

	sub bx,1
	cmp bx,0
	jge Existe
;varificar las palabras
 
verificar:

cmp cont,0
je No_exist
jne input

No_exist:
 
      ; mover el mensaje que si se encuentra la letra
        lea dx, enters
		call output
		inc intento
        ;no puede restar puntos menos de cero
        cmp points,10
        jl minun1
        jg max1
        max1:
        ;resta los puntos si tiene 10 o mas
        sub points,10
        minun1:
        lea dx, error1 ;SI VA EL PRIMER ERROR YA EMPIEZA A APARECER LA PRIMERA PARTE DEL CUERPO Y MANDA A LLAMAR EL MENSAJE
        cmp intento,1
        je imprime
        lea dx, error2
		;error2 CUANDO SE EQUIVOCA LA SEGUNDA VEZ SALE EL BRAZO DERECHO
        cmp intento,2
        je imprime
        lea dx, error3 ;CUANDO SE EQUIVOCA LA TERCERA VEZ SALE EL BRAZO IZQUIERDO
        cmp intento,3
        je imprime
        lea dx, error4 ;;CUANDO SE EQUIVOCA LA CUARTA VEZ SALE EL PIE DERECHO
        cmp intento,4
        je imprime
        lea dx, error5 ;CUANDO SE EQUIVOCA LA QUINTA VEZ SALE EL PIE DERECHO Y FERDIO
        cmp intento, 4
        jg fallos
		lea dx, enters
    
	;cambios
Cambiow:

;agregar los 100 puntos
add points, 100
;intentos cuando comienza es cero
mov intento,0
;quitar letra en la palabra
sub resWord,1
mov resLetra,5
;identificar que palabra le toca a las palabras
cmp resWord,0
je Dganador
cmp resWord,3
je avanzarW2
cmp resWord,2
je avanzarW3
cmp resWord,1
je avanzarW4

avanzarW2:    ;AVANAZA A LA SIGUIENTE PALABRA
;VOLVEMOS A REPETIR EL METODO
    mov cx,5  
    lea si,word2
    lea di,letra_adi
    rep movsb
    jmp copias

avanzarW3:     ;PASA A LA 3RA PALABRA
;REPETIMOS METODO DEL JUEGO
    mov cx,5  
    lea si,word3
    lea di,letra_adi
    rep movsb
    jmp copias

avanzarW4:     ;PASA A LAS 4TA PALABRA
;REPETIMOS PROCESO
    mov cx,5  
    lea si,word4
    lea di,letra_adi
    rep movsb
    jmp copias

copias:
    mov ah,06h
    mov al,00H
    mov bh,03h
    mov ch,00h
    mov cl, 00H
    mov dh, 18H
    mov dl,4fh
    int 10h
    ;sumarr los puntos
    ;lVOVLER A MOSTRAR LOS ASTERISCOS
    mov cx,5    
    lea si,No_muestra
    lea di,progreso
    rep movsb
	;MOVER EL REGISTRO CON EL MOVSB
    mov paso,1
    jmp input

imprime:

        ;imprimir un mensaje
        mov ah,9 
        int 21h ;escribe el mensaje 
        jmp input   

repetir: ;mostrar mensaje de la letra repetida y volver a input
    
	;devolver las letras
        lea dx, enters
        call output

        lea dx, intact
        call output
;las letraas copiadas

        lea dx, copia
        call output
        lea dx, enters
        call output
        jmp input 


ganador: ;mostrar letra adivinada y reiniciar juego
        lea dx, enters
        call output
        lea dx, campeon
        call output
		;agregando desde cero y comienza desde cero el juego
        lea dx, enters
        call output
        lea dx, comp
        call output
        mov paso,0
        jmp input     
   
Dganador: ;gana el jugador 
        lea dx, enters
        call output
        lea dx, campeon
        call output
        lea dx, enters
        call output
        lea dx, comp
        call output  
        call mostrar_points
        jmp salida
fallos:   
        ;disminuye la cantidad de oportunidades del jugador
        mov ah,9 
        int 21h ;escribir el mensaje anterior
        lea dx, termina ;mensaje de que perdio
        call output      
salida:
    mov ah,4ch
    int 21h
    
main endp

;PUNTAJES
mostrar_points proc near
         movzx ax, points  ;MOSTRAS LAS CENTENAS
         mov bl, 100
         div bl
         mov decenas, ah
         mov centenas, al
         add centenas, 30h
         movzx ax, decenas ;MOSTRAR LAS DECENAS
         mov bl, 10
         div bl
         mov decenas, al
         add decenas, 30h
        lea dx, enters
        call output
        lea dx, puntaje
        call output
        lea dx, centenas
        call output
        lea dx, decenas
        call output
        lea dx, cero
        call output
        ret
mostrar_points endp
;PROCEDIMIENTO PARA MOSTRAS LOS MENSAJES
output proc near
    push ax 
    mov ah, 09h
    int 21h
    pop ax
    ret 
output endp

end  main
22