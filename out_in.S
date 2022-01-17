; Ficheiro:  out_in.S
; Descricao: Programa que realiza o teste do porto de input da placa SDP16
; Autor:     Jose Filipe Cruz dos Santos (josefilipe.s@deetc.isel.ipl.pt)
; Data:      19-12-2021

; Definicao dos valores dos simbolos utilizados no programa
;
	.equ STACK_SIZE,     64		; Dimensao do stack - 64 B
	.equ IN_ADDR,	     0xFF00 ; Endereço de memoria dos portos de input
    .equ OUT_ADDR,	     0xFF00	; Endereço de memoria dos portos de output

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
; Descricao: chama uma rotina de teste para o input
main:
	bl test_in_out
    b .

; Rotina:    test_in_output
; Descricao: Testa o porto de input colocando um valor no output e lendo o input
;            Interface exemplo: int test_in_output();
; Saidas:    r0 - valor correspondente ao valor que não foi possivel de escrever.
test_in_out:
    push r4
    mov	r0, IN_ADDR & 0x00FF
	movt r0, (IN_ADDR >> 8) & 0x00FF
    mov	r1, OUT_ADDR & 0x00FF
	movt r1, (OUT_ADDR >> 8) & 0x00FF
    mov r2, #1
    mov r4, 0xFF
	test_in_out_for:
        cmp r0, r4
        bhs test_in_out_for_end
		ldr r2, [r0]
		str r3, [r1]
        cmp r2, r3
        bne return_err
        add r0, r0, #1
		b test_in_out_for
	test_in_out_for_end:
        mov r0, #0
        b return
    return_err:
        mov r0, r2
    return:
        pop r4
        mov pc, lr


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
