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

;BEGIN THE CODE FOR THE FSM 


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
	ADD R0, R0, R4		;set state to 1, only if char is A
	BRnp loop
	BR set1			;if it's any other character, go back to loop
state1	LD R4, negU	
	ADD R0, R0, R4		;checking if char is a U
	BRz set2
	ADD R0, R0, #10
	ADD R0, R0, #10		;checking if char is A in state1
	BRnp set0		;loops back if there's another eg ('AA')
	BR loop
state2	LD R4, negG	
	ADD R0, R0, R4
	BRnp set0
	LD R0, pipe		;Puts the pipe if we are at state 2 and a 'G' is encountered
	PUTC
	BR set3
		
FSM1	LDI R0, letter		;separate FSM code once the start codon is intitialized
	BRz FSM1
	PUTC
	AND R1, R1, #0
	STI R1, letter
	ADD R4, R5, #-3		;checking if state is 3 
	BRz state3
	ADD R4, R5, -4		;checking if state is 4
	BRz state4		
	ADD R4, R5, -5		;checking if state is 5
	BRz state5
	ADD R4, R5, -6		;checking if state is 6
	BRz state6		

state3	LD R4, negU
	ADD R0, R0, R4		;checking if char is a U
	BRz set4	
	BR FSM1

state4	LD R4, negA		;'U' has already been found
	ADD R0, R0, R4		;checking if char is an A
	BRz set5		
	ADD R0, R0, #-6		;checking if char is a G
	BRz set6		
	ADD R0, R0, #-14	;checking if char is a U
	BRnp set3
	BR FSM1

state5				; "UA-" looking for A or G
	LD R4, negA
	ADD R0, R0, R4
	BRz end
	ADD R0, R0, -6
	BRz end
	BR set3

state6	LD R4, negA		; "UG-" looking for A
	ADD R0, R0, R4
	BRz end
	BR set4

end	TRAP x25		;ending the code if state6 is entered
	

	
;HERE WE BRANCH TO THESE FUNCTIONS TO SET THE STATE BIT. THIS MAKES OUR CODE EASIER TO FOLLOW. 


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
BR FSM1

set4
AND R5, R5, #0
ADD R5, R5, #4
BR FSM1

set5
AND R5, R5, #0
ADD R5, R5, #5
BR FSM1

set6
AND R5, R5, #0
ADD R5, R5, #6
BR FSM1




stack .FILL x4000
IVT   .FILL x0180
Interrupt .FILL x2600
KBSR .FILL xFE00
letter .FILL x4600
negA 	.FILL x-41
negU 	.FILL x-55
negG	.FILL x-47   	;never check for 'C' in our code
pipe	.STRINGZ "|"

		.END
