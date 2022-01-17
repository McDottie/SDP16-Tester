; Ficheiro:  output.S
; Descricao: Programa que realiza o teste do porto de output da placa SDP16
; Autor:     Jose Filipe Cruz dos Santos (josefilipe.s@deetc.isel.ipl.pt)
; Data:      19-12-2021

; Definicao dos valores dos simbolos utilizados no programa
;

	.equ STACK_SIZE,     64		; Dimensao do stack - 64 B
	.equ IO_ADDR,	     0xFF00 ; Endereço de memoria dos portos de IO

; Seccao:    .startup
; Descricao: Guarda o código de arranque do sistema
;
	.section .startup
	b	_start
	b	.

_start:
	ldr	sp, stack_top_addr
	ldr	pc, main_addr

stack_top_addr:
	.word stack_top
main_addr:
	.word main

; Seccao:    .text
; Descricao: Guarda o código do programa
;
	.text

; Rotina:    main
; Descricao: chama uma rotina de teste do output
main:
	bl test_output
    b .

; Rotina:    test_output
; Descricao: Testa o porto de output colocando um valor incrementado a cada 500ms
;            Interface exemplo: void test_output();
test_output:
    push LR

	mov r0, #1
    mov	r1, IO_ADDR & 0x00FF
	movt r1, (IO_ADDR >> 8) & 0x00FF
    mov r2, 0x0FF
    test_io_for:
        str r0, [r1] 
        add r0, r0, #1
        cmp r0, r2

		push r0
		push r1
		push r2
		mov r0, #200
		bl delay
		pop r2
		pop r1
		pop r0
		
        b  test_io_for

    test_io_for_end:
	pop LR
    mov PC, LR

; Rotina:    delay
; Descricao: Faz um delay
;            Interface exemplo: void delay( uint8_t ciclos );
; Entradas:  r0 - valor em ciclos de delay
delay:
	mov r1, #0
	delay_for:
		sub r0, r0, #1
		cmp r0, r1
		bne delay_for
	delay_for_end:
	mov PC, LR

; Seccao:    .data
; Descricao: Guarda as variáveis globais com um valor inicial definido
;
.data

; Seccao:    .stack
; Descricao: Implementa a pilha com o tamanho definido pelo simbolo STACK_SIZE
;
	.section .stack

stack_bottom:
	.space STACK_SIZE
stack_top:
