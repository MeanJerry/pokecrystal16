FarCall    EQU $08
Bankswitch EQU $10
JumpTable  EQU $28

MACRO farcall ; bank, address
	ld a, BANK(\1)
	ld hl, \1
	rst FarCall
ENDM

MACRO callfar ; address, bank
	ld hl, \1
	ld a, BANK(\1)
	rst FarCall
ENDM

MACRO homecall
	ldh a, [hROMBank]
	push af
	ld a, BANK(\1)
	rst Bankswitch
	call \1
	pop af
	rst Bankswitch
ENDM
