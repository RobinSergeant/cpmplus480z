OUTC:	equ 0x01
KBDW:   equ 0x21

emt: .macro routine
rst 0x30
defb &routine
.endm

org 0x80

ld a, 12	; clear screen
emt OUTC

ld c,0
ld b,LEN
ld hl,TEND
otdr

emt KBDW

rst 0x38

text:	defm 'Welcome to the boot loader!'
LEN:	equ $-text
TEND:	equ $-1
dummy:	defb 0x44
