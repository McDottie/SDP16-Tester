	.equ STACK_SIZE,     64
	.equ IO_ADDR,	     0x1234
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
	bl test_output
    b .

test_output:
    mov r0, #1
    mov	r1, IO_ADDR & 0x00FF
	movt r1, (IO_ADDR >> 8) & 0x00FF
    mov r2, 0x0FF
    test_io_for:
        ldr r0, [r1] 
        add r0, r0, #1
        cmp r0, r2
        bl  test_io_for

    test_io_for_end:
    mov PC, LR

.data

	.section .bss


	.section .stack

stack_bottom:
	.space STACK_SIZE
stack_top:
