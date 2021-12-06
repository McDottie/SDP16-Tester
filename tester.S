	.equ STACK_SIZE,     64
	.equ UINT16_MAX,     0xFFFF
	.equ IO_ADDR,	     0x1234 
	.equ MIDWAY, 	     0x7FFE
	.equ KNOWN_PATTERN,  0xAAAA
	.equ NKNOWN_PATTERN, 0x5555
	
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

	.text
main:
	;bl test_leds
	;bl test_io
	;bl test_buttons
	mov	r0, MIDWAY & 0x00FF
	movt r0, (MIDWAY >> 8) & 0x00FF
	mov	r1, 0xFF
	movt r1, 0xFF
	
	bl test_memory
	bl migrate_code

test_memory: ;r0 start address | r1 finish address
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
	mov r0, #1
	b return_mem
	
	end_err_mem:
		mov	r0, #0
	return_mem:
		pop LR
		mov PC, LR

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

.data

stack_top_addr2:
	.word stack_top

main_addr2:
	.word main

	.section .bss


	.section .stack

stack_bottom:
	.space STACK_SIZE
stack_top:
