; Main.asm
; Name: Austin Rath & Chiadika Obinwa
; UTEid: ar63736 & co8922
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
; initialize the stack pointer

LD R6, stack



; set up the keyboard interrupt vector table entry

LD R1, Interrupt
STI R1, IVT

; enable keyboard interrupts

AND R0, R0, #0
LD R1, stack
ADD R0, R0, R1
STI R0, KBSR



; start of actual program
AND R0, R0, #0
STI R0, letter


reset	AND R5, R5, #0		; clearing state register
loop	LDI R0, letter
	BRz loop
	PUTC
	AND R1, R1, #0
	STI R1, letter
	ADD R4, R5, #0		;checking if state is 0 
	BRz state0
	ADD R4, R5, -1		;checking if state is 1
	BRz state1		
	ADD R4, R5, -2		;checking if state is 2
	BRz state2
state0	LD R4, negA	
	ADD R0, R0, R4		;set state to 1,
	BRnp loop
	BR set1			;if it's any other character, go back to loop
state1	LD R4, negU	
	ADD R0, R0, R4		;checking if char is a U
	BRz set2
	ADD R0, R0, #10
	ADD R0, R0, #10		;checking if char is A in state1
	BRnp set0
	BR loop
state2	LD R4, negG	
	ADD R0, R0, R4
	BRnp set0
	LD R0, pipe
	PUTC
	TRAP x25		
		

	BR loop			; R0 still holds char at this point
	

	

set0
AND R5, R5, #0
BR loop

set1
AND R5, R5, #0
ADD R5, R5, #1
BR loop

set2
AND R5, R5, #0
ADD R5, R5, #2
BR loop

set3
AND R5, R5, #0
ADD R5, R5, #3
BR loop
	
	



stack .FILL x4000
IVT   .FILL x0180
Interrupt .FILL x2600
KBSR .FILL xFE00
letter .FILL x4600
negA 	.FILL x-41
negU 	.FILL x-55
negG	.FILL x-47
pipe	.STRINGZ "|"

		.END
