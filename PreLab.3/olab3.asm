;DANIEL MOLINA, IHOSEM OROZCO, DANIEL FONSECA
;programa que sirve de ayuda para comprender el proyecto y añadir nuevas tecnicas de uso en el que el programa nos ayuda a entender el manejo de paginas
title LAB3
.model small
.stack 64
.data

mensaje1 db 'Bienvenido al laboratorio 3', 0Ah, '$'
mensaje2 db 'MANEJO DE PAGINAS', 0Ah, '$'
mensaje3 db 'IHOSEM', 0Ah, '$'
mensaje4 db 'DANIEL MOLINA', 0Ah, '$'
mensaje5 db 'DANIEL FONSECA', 0Ah, '$'


;ALMACENAMOS LAS VARIABLES QUE VAN A HACER UTILIZADAS
hoja DB	0
almacenamiento DB 0
salto DB 0DH, 0AH, '$' 
contador DB 0 ; 
copia db 0;ALMACENAMOS LAS PALABRASSRAS
centenas db ? ,'$'
decenas db ? ,'$'
cero db 30h ,'$'
contador2 DB 0 ;
PALABRASS db 240 dup(' '), 24H
PALABRASS2 db 240 dup(' '), 24H
PALABRASS3 db 240 dup(' '), 24H
.386
.CODE

;EMPEZAMOS A PROGRAMAR CONTAMOS ESPACIOS
SIMPLE1	PROC FAR
	MOV	AX, @DATA
	MOV	DS,AX
	MOV	ES,AX
	MOV SI, 0 
	 mov ah, 9
        lea dx, mensaje1
        int 21h

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
SIMPLE2:	    
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
      jmp control     	    
      control:;MANDAMOS A LLAMAR EL CONTROL DE LAS PAGINA 
	CALL CONTROLES ; CAMBIAMOS DE LA PAGINAS         
	CALL MOVIMIENTO ;LIMPIAMOS PAGINAS
	CALL CURSORMOV ; MOVEMOS LOS CURSORES 
      CMP contador, 1 ;CONTAMOS LAS VECES
      JE MANEJO   ;MANEJO DE LOS DATOS
      CALL RECONOCIMIENTO
      jmp MANEJO     	    
      MANEJO:     ;MANDAMOS A LOS MOVIMIENTOS DEL CURSOR       
      CALL CONTROLADOR                                             
	INC hoja ;AUMENTAMOS EL NUMERO DE LAS PAGINAS      
	CALL CONTROLES ;SALTO DE PAGINA     
	CALL MOVIMIENTO2 ;COLORES DE LA PANTALLA
      CALL FUERA_SALTO                                                                   
      CALL TEXTOS  ; MOSTRAR LOS TEXTOS DE LA PANTALLA                                    
      CMP contador, 1 
      JE SALTAR        
	CALL RECONOCIMIENTO2    ;RECONOCER LOS TEXTOS 		
      SALTAR:      
	MOV hoja, 0		
SIMPLE3:
    CALL CONTROLES ;CAMBIAMOS DE LA PAGINAS   	
	MOV AH, 10H 
	INT 16H ;ASCCI
    CMP hoja,1
	JE HOJACERO	
	CMP AX, 1900H;alt p
	JE AUMENTOHOJA       							  						 
	CMP AX, 2D00H; alt x
	JE EXITS       						    
HOJACERO: 									
	MOV hoja, 0
	JMP SIMPLE3	
	;AUMENTAMOS LA HOJA
AUMENTOHOJA:									
	INC hoja      
	JMP SIMPLE3

;CLOSE DE PROGRAMA	
EXITS:									
	MOV	AX,4C00H
	INT	21H	
SIMPLE1	ENDP
CURSORMOV	PROC NEAR
      MOV DL, 0
      MOV DH, 0
	  MOV BH, hoja
  	  MOV AH, 02H
	  INT	10H           			 
	  RET
CURSORMOV ENDP

; CAPTURAR PALABRASS
RECONOCIMIENTO PROC NEAR
INC contador2
SALTAMOSLOOP:
MOV AH, 01H 
INT 21H 
CMP AH, 18H   		            
CMP AL, 00H   
JE MANEJO 	
mov PALABRASS[si], al
inc si 
jmp SALTAMOSLOOP
RET 
RECONOCIMIENTO ENDP
RECONOCIMIENTO2 PROC NEAR
mov si, 0; 
INC contador
SALTAMOSLOOP2:
MOV AH, 01H 
INT 21H 
CMP AH, 18H   	            
CMP AL, 00H  
JE control
mov PALABRASS2[si], al
inc si 
jmp SALTAMOSLOOP2
RET 
RECONOCIMIENTO2 ENDP

TEXTOS PROC NEAR
mov ah, 09h
lea dx, PALABRASS
int 21h 
TEXTOS ENDP 

CONTROLADOR PROC NEAR
mov ah, 09h
lea dx, PALABRASS2
int 21h 
CONTROLADOR ENDP 
IMPRIME PROC NEAR
	PUSH AX
	MOV AH, 13H
	MOV CX, 8
	MOV AL, 00
	MOV BH, hoja
	INT 10H            				
	POP AX
	RET
IMPRIME ENDP
MOVIMIENTO	PROC NEAR
	MOV AH, 06H
	MOV AL, 00H 				 
	MOV BH, 07H 					
	MOV CX, 00
	MOV DX, 184FH
	INT 10H           			 	
	RET
MOVIMIENTO	ENDP

MOVIMIENTO2	PROC NEAR
	MOV AH, 06H
	MOV AL, 00H 				
	MOV BH, 20H						
	MOV CX, 0000H					
	MOV DX, 014FH
	INT 10H            				
  		;COLORES AZUL Y VERDE EN LOS QUE UBICAMOS EN LA PANTALLA		
	MOV AH, 06H
	MOV AL, 00H 					
	MOV BH, 12H						 
	MOV CX, 1200H                             
	MOV DX, 184FH
	INT 10H            				      
	RET
MOVIMIENTO2	ENDP
OUTPUT PROC NEAR
	PUSH AX
	MOV AH, 09H
	INT 21H
	POP AX
	RET
OUTPUT ENDP
FUERA_SALTO PROC NEAR
	PUSHA
	LEA DX, salto
	CALL OUTPUT
	POPA
	RET
FUERA_SALTO ENDP
CONTROLES	PROC NEAR
	MOV AH, 05H
	MOV AL, hoja						
	INT 10H             			
	RET
CONTROLES ENDP
END SIMPLE1