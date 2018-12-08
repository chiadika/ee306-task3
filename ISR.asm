; ISR.asm
; Name: Austin Rath & Chiadika Obinwa
; UTEid: ar63736 & co8922
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x4600
               .ORIG x2600
;save registers
ST R0, regZero
ST R1, regOne


LDI R0, KBDR
LD R1, negA
ADD R1, R0, R1
BRz store			;store A
ADD R1, R1, #-2
BRz store			;store C
ADD R1, R1, #-4		
BRz store			;store G
ADD R1, R1, #-14		
BRz store 			;store U
BR end
store
STI R0, letter




;load registers
end
LD R0, regZero
LD R1, regOne

	RTI
negA .FILL -65
KBDR .FILL xFE02
letter .FILL x4600
regZero	.BLKW 1
regOne	.BLKW 1
		.END
