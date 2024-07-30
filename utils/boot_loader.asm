BDOS:		equ 0x0005
FCB:		equ 0x005c
FN_PRINT:	equ 9
FN_OUT:		equ 2
FN_OPEN_FILE:	equ 15
FN_READ_SEQ:	equ 20
FN_SET_DMA:	equ 26

WRTE_SEC:	equ 66

emt: .macro routine
rst 0x30
defb &routine
.endm

org 0x100

		ld c,FN_OPEN_FILE
		ld de,FCB
		call BDOS
		inc a
		jr z,not_found

read_loop:	ld c,FN_SET_DMA
		ld de,(dma_buffer)
		call BDOS

		ld c,FN_READ_SEQ
		ld de,FCB
		call BDOS
		cp 0
		jr nz,write_loop

		ld hl,sector_count
		inc (hl)
		ld hl,(dma_buffer)
		ld bc,128
		add hl,bc
		ld (dma_buffer),hl
		jr read_loop

write_loop:	xor a
		ld hl,sector_count
		cp (hl)
		jr z,finished
		dec (hl)
		
		ld ix,unit
		emt WRTE_SEC

		inc (ix+2)
		ld hl,(address)
		ld bc,128
		add hl,bc
		ld (address),hl

		jr write_loop

not_found:	ld c,FN_PRINT
		ld de,error_msg
		call BDOS

finished:	ret

dma_buffer:	defw 0x1000
sector_count:	defb 0

error_msg:	defm "File not found$"

unit:		defb 0x01
track:		defb 0
sector:		defb 1
address:	defw 0x1000



