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


loop	LDI R0, letter
	BRz loop
	PUTC
	AND R1, R1, #0
	STI R1, letter
	BR loop
	



stack .FILL x4000
IVT   .FILL x0180
Interrupt .FILL x2600
KBSR .FILL xFE00
letter .FILL x4600

		.END
