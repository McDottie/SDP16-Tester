; Ficheiro:  mem.S
; Descricao: Programa que realiza o teste da memória da placa SDP16
; Autor:     Jose Filipe Cruz dos Santos (josefilipe.s@deetc.isel.ipl.pt)
; Data:      19-12-2021

; Definicao dos valores dos simbolos utilizados no programa
;
	.equ STACK_SIZE,     64		; Dimensao do stack - 64 B
	.equ UINT16_MAX,     0xFFFF	; Maior número de 16 bits sem sinal
	.equ MIDWAY, 		 0x3FFE	; Metade da memória
	.equ KNOWN_PATTERN,  0xAAAA	; Padrao conhecido
	.equ NKNOWN_PATTERN, 0x5555	; Negado bit a bit de um padrao conhecido

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
; Descricao: chama uma rotina de teste para a memória move o código para essa parte da memória e testa o restante
main:
	ldr	r2, start_addr_addr
	ldr r3, end_addr_addr
	
	ldr r0, [r2]
	ldr r1, [r3]
	
	push r2
	push r3
	bl test_memory
	pop r3
	pop r2

	mov r0, #0
	mov	r1, MIDWAY & 0x00FF
	movt r1, (MIDWAY >> 8) & 0x00FF

	str r0, [r2]
	str r1, [r3]

	bl migrate_code

end_addr_addr:
	.word end_addr

start_addr_addr:
	.word start_addr

; Rotina:    test_memory
; Descricao: Testa o porto de input colocando um valor no output e lendo o input
;            Interface exemplo: int test_memory(int start, int end);
; Entradas:  r0 - Endereco de inicio de teste.
;			 r1 - Endereco de memória onde termina o teste. 
; Saidas: 	 r0 - Sucesso ou erro.
test_memory:
	mov	r2, KNOWN_PATTERN & 0x00FF
	movt r2, (KNOWN_PATTERN >> 8) & 0x00FF
	push LR

	push r0
	push r1

	bl test_memory_aux
	mov r3, #1
	cmp r0, r3
	bne end_err_mem
	pop r1
	pop r0

	mov	r2, NKNOWN_PATTERN & 0x00FF
	movt r2, (NKNOWN_PATTERN >> 8) & 0x00FF

	bl test_memory_aux
	mov r3, #1
	cmp r0, r3
	bne end_err_mem
	mov r0, #0
	b return_mem
	
	end_err_mem:
		mov	r0, #1
	return_mem:
		pop LR
		mov PC, LR

; Rotina:    test_memory_aux
; Descricao: Funcao auxiliar utilizada pela funcao test_memory que escreve padroes na memoria e le de seguida.
;            Interface exemplo: int test_memory_aux(int start, int end, int pattern);
; Entradas:  r0 - Endereco de inicio de teste.
; 			 r1 - Endereco de memória onde termina o teste. 
;			 r2 - Padrao a ser escrito na memoria.
; Saidas: 	 r0 - Sucesso ou erro.
test_memory_aux:
	sub r1, r1, r0
	mov r3, #0
	for1_mem_aux:
		cmp r3, r1
		bhs end_for1_mem
		str r2, [r0, r3]
		ldr r4, [r0, r3]
		cmp r2, r4
		bne end_err_mem_aux
		add r3, r3, #2
		b for1_mem_aux
	end_for1_mem:
		mov r0, #1
		b return_mem_aux
	end_err_mem_aux:
		mov r0, #0
	return_mem_aux:
		mov PC, LR


; Rotina:    migrate_code
; Descricao: Funcao que migra o código para a segunda metade da memoria de forma a possibilitar o teste da parte superior da memoria.
;            Interface exemplo: void migrate_code();
migrate_code:
	push r6
	
	ldr r0, main_addr2
	ldr r1, stack_top_addr2
	sub r2, r1, r0
	mov	r3, MIDWAY & 0x00FF
	movt r3, (MIDWAY >> 8) & 0x00FF
	mov r6, #0
	for_migrate:
		ldr r4, [r0, r6]
		str r4, [r3, r6]
		add r6, r6, #2
		cmp r6, r2
		bhs end_for_migrate
		b for_migrate
	end_for_migrate:
	pop r6
	mov pc, r3

; Seccao:    .data
; Descricao: Guarda as variáveis globais com um valor inicial definido
;
.data

stack_top_addr2:
	.word stack_top

main_addr2:
	.word main

start_addr:
	.word MIDWAY

end_addr:
	.word 0x7FFE

; Seccao:    .stack
; Descricao: Implementa a pilha com o tamanho definido pelo simbolo STACK_SIZE
;
	.section .stack

stack_bottom:
	.space STACK_SIZE
stack_top:
