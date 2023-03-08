.model small
.stack 100h
.data
salto db 0DH,0AH,'$'
;-------------------MENU--------------------------
selecopcion db 'Elija una opcion:',0DH,0AH,24H
op1 db '1) Opcion 1 ',0DH,0AH,24H
op2 db '2) Opcion 2 ',0DH,0AH,24H
salir db ' Pulsa "D" o "d" para Salir ',0DH,0AH,24H

;-------------------OPCION 1--------------------------
mensaje1 db '   Ingrese un caracter: ',0DH,0AH,24H
resultado db ' Es una letra ',0DH,0AH,24H
min db 'minuscula.',0DH,0AH,24H
may db 'mayuscula.',0DH,0AH,24H

;-------------------OPCION 2--------------------------


.code
start:
  mov ax,@data
  mov ds,ax

  lea dx,selecopcion
  call escribir

  lea dx,op1
  call escribir
  lea dx,op2
  call escribir

  lea dx,salir
  call escribir
  call leer
  cmp al,'1'
  je opcion1
  cmp al,'2'
  je opcion2
  
  cmp al,'D' OR 'd'
  je salida
  jmp start
  
opcion1 PROC NEAR ; ------------------- Inicia codigo para la opcion 1

 lea dx,mensaje1
  call escribir1
  call leer1
  cmp al,'A'
  jl esMayuscula
  cmp al,'Z'
  jg esMinuscula
  jmp esMayuscula
  
	esMinuscula:
  lea dx,resultado
  call escribir1
  lea dx,min
  call escribir1
  jmp fin
  
	esMayuscula:
  lea dx,resultado
  call escribir1
  lea dx,may
  call escribir1
	fin:
  ; codigo para finalizar el programa
  mov ax,4c00h
  int 21h
	escribir1:
  mov ah,9
  int 21h
  ret
	leer1:
  mov ah,1
  int 21h
  ret
endp opcion1 ; -------------------  Finaliza codigo para la opcion 1
  
  jmp start
opcion2:
  ; aqui iria el codigo para la opcion 2
  jmp start
salida:
  ; codigo para salir del programa
  mov ax,4c00h
  int 21h
escribir:
  mov ah,9
  int 21h
  ret
leer:
  mov ah,1
  int 21h
  ret
end start
