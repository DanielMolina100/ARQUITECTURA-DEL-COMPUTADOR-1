;'LABORATORIO 1'
;'ARQUITECTURA DEL COMPUTADOR 1'
;'Daniel Molina 1007420'
;'Ihosem Orozco 1047920'
;'Daniel Fonseca 1243020'
;El programa para el laboratorio #1, consiste en emplear los 4 metodos de direccionamiento 
;descritos en la misma, los cuales incluyen el direccionamiento directo, direccionamiento
;indirecto y 2 formas de emplear el direccionamiento con escalar. En el programa, se declaran 
;4 variables de texto, las cuales describen el tipo de direccionamiento que se esta empleando y 
;que luego, su texto es mostrado segun su direccionamiento. Asi tambien otras tres variables (TEXT1, TEXT2, TEXT3) 
;las cuales guardan palabras que se trabajan con el metodo de direccionamiento escalar, 
;indicando la posicion de la letra que se quiere mostrar o modificar.

TITLE "Programa 1"
.MODEL SMALL
.STACK 64; 'Declaración del segmento stack'
.DATA; Declaracion del segmento de datos

DSEG    SEGMENT ;Declaracion de segmento de data
MESS    DB   'Ejemplo de direccionamiento directo' ,0DH,0AH,24H,'$'
MESS2   DB   'Ejemplo de direccionamiento indirecto' ,0DH,0AH,24H,'$'
MESS3   DB   'Ejemplo 1 de direccionamiento con escalar' ,0DH,0AH,24H,'$'
EJEM1   DB   'Laboratorio 1 de arquitectura del computador1!' ,0DH,0AH,24H,'$'
TEXT1	DB   'BANCO' ,0DH,0AH,24H,'$'
TEXT2	DB   'PERRO' ,0DH,0AH,24H,'$'
TEXT3	DB   'COMER' ,0DH,0AH,24H,'$'
TEXT4	DB   'MIEDO' ,0DH,0AH,24H,'$'
DSEG    ENDS




SSEG    SEGMENT PARA STACK  ;Declaracion de segmento de pila
        DW  256 DUP(?)
SSEG    ENDS

CSEG    SEGMENT ;Declaracion de segmento de codigo
        ASSUME  CS:CSEG,DS:DSEG ;Indicar que esos segmentos pueden tomarse como los registros CS y DS
BEGIN:  
	;DIRECCIONAMIENTTO DIRECTO
		MOV AX,DSEG ;Mover direccion DSEG a AX
        MOV DS,AX ;Mover direccion de DSEG a DS
        MOV DX,OFFSET MESS ;Mover mensaje a DX
        MOV AH,9 
        INT 21H ;Escribir el mensaje
        MOV DX,OFFSET EJEM1 ;Mover mensaje a DX
        MOV AH,9 
        INT 21H ;Escribir el mensaje		
    
		;DIRECCIONAMIENTO INDIRECTO
	   LEA DX, MESS2 
	   MOV AH,9
	   INT 21H;
	   LEA DX,[EJEM1+17] ;leer el mensaje indirecto
	   MOV AH,9
	   INT 21H
      
		;DIRECCIONAMIENTTO ESCALAR
		 LEA DX, MESS3 
	   MOV AH,9
	   INT 21H;
		LEA DX, [TEXT1 + 9*2] ;lee la tercer variable
		  MOV AH,9
	     INT 21H;
		
		
		;DIRECCIONAMIENTO ESCALAR 2
		
		MOV [EJEM1+12], '2' ;REEMPLAZANDO EL 1 DEL TITULO 
	    LEA DX, [EJEM1]  ;ESCRIBIENDO VARIABLE
		MOV AH,9
	    INT 21H
		
		LEA DX, [TEXT1 + 9*3] ;lee la cuarta variable
		  MOV AH,9
	     INT 21H;
		 MOV AH,4CH; ;TERMINAR OPERACION
		 INT 21H;
		
CSEG    ENDS
        END  BEGIN
	
	 


