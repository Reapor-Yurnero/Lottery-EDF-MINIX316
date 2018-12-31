! Translated from GNU to ACK by gas2ack
.sect .text; .sect .rom; .sect .data; .sect .bss
.sect .text
! 1 "klib386.o.tmp"
! 1 "klib386.S"


.sect .text; .sect .data; .sect .data; .sect .bss
! 3 "/usr/include/minix/config.h"
! 3 "/usr/include/minix/sys_config.h"
! 43 "/usr/include/minix/sys_config.h"
! 48 "/usr/include/minix/sys_config.h"
! 53 "/usr/include/minix/sys_config.h"
! 61 "/usr/include/minix/sys_config.h"
! 65 "/usr/include/minix/sys_config.h"
! 69 "/usr/include/minix/sys_config.h"
! 24 "/usr/include/minix/config.h"
! 1 "/usr/include/minix/const.h"
! 5 "/usr/include/minix/const.h"
! 81 "/usr/include/minix/const.h"
! 103 "/usr/include/minix/const.h"
! 1 "/usr/include/ibm/interrupt.h"
! 59 "/usr/include/ibm/interrupt.h"
! 1 "include/archconst.h"
! 1 "/usr/include/ibm/interrupt.h"
! 7 "/usr/include/ibm/memory.h"
! 7 "include/archconst.h"
! 146 "include/archconst.h"
! 1 "./../../const.h"
! 3 "/usr/include/minix/bitmap.h"
! 7 "./../../const.h"
! 3 "./../../config.h"
! 3 "./../../debug.h"
! 19 "/usr/include/ansi.h"
! 31 "/usr/include/ansi.h"
! 56 "/usr/include/ansi.h"
! 60 "/usr/include/ansi.h"
! 71 "/usr/include/ansi.h"
! 3 "/usr/include/minix/debug.h"
! 11 "/usr/include/minix/debug.h"
! 65 "./../../config.h"
! 13 "./../../debug.h"
! 43 "./../../debug.h"
! 55 "./../../debug.h"
! 64 "./../../debug.h"
! 71 "./../../debug.h"
! 77 "./../../debug.h"
! 82 "./../../debug.h"
! 88 "./../../debug.h"
! 10 "./../../const.h"
! 27 "./../../const.h"
! 43 "./../../const.h"
! 3 "./sconst.h"
! 1 "./../../const.h"
! 5 "./sconst.h"


	W = 4


	P_STACKBASE = 0
	GSREG = P_STACKBASE
	FSREG = GSREG+2
	ESREG = FSREG+2
	DSREG = ESREG+2
	DIREG = DSREG+2
	SIREG = DIREG+W
	BPREG = SIREG+W
	STREG = BPREG+W
	BXREG = STREG+W
	DXREG = BXREG+W
	CXREG = DXREG+W
	AXREG = CXREG+W
	RETADR = AXREG+W
	PCREG = RETADR+W
	CSREG = PCREG+W
	PSWREG = CSREG+W
	SPREG = PSWREG+W
	SSREG = SPREG+W
	P_STACKTOP = SSREG+W
	FP_SAVE_AREA_P = P_STACKTOP
	P_LDT_SEL = FP_SAVE_AREA_P+532
	P_CR3 = P_LDT_SEL+W
	P_LDT = P_CR3+W
	P_MISC_FLAGS = P_LDT+50
	Msize = 9
! 53 "./sconst.h"
! 73 "./sconst.h"
! 79 "./sconst.h"
! 85 "./sconst.h"
! 97 "./sconst.h"
! 105 "./sconst.h"
! 113 "./sconst.h"
! 137 "./sconst.h"
! 143 "./sconst.h"
! 11 "klib386.S"






.define	_monitor
.define	_int86
.define	_exit
.define	__exit
.define	___exit
.define	___main
.define	_phys_insw
.define	_phys_insb
.define	_phys_outsw
.define	_phys_outsb
.define	_phys_copy
.define	_phys_copy_fault
.define	_phys_copy_fault_in_kernel
.define	_phys_memset
.define	_mem_rdw
.define	_reset
.define	_halt_cpu
.define	_level0
.define	_read_cpu_flags
.define	_read_cr0
.define	_read_cr2
.define	_getcr3val
.define	_write_cr0
.define	_read_cr4
.define	_thecr3
.define	_write_cr4

.define	_catch_pagefaults
.define	_read_ds
.define	_read_cs
.define	_read_ss
.define	_idt_reload

.define	_fninit
.define	_fnstsw
.define	_fnstcw







.sect .text






_monitor:
	mov	esp, (_mon_sp)
	o16 mov	dx, 5*8
	mov	ds, dx
	mov	es, dx
	mov	fs, dx
	mov	gs, dx
	mov	ss, dx
	pop	edi
	pop	esi
	pop	ebp
	o16 retf






_int86:
	cmpb	(_mon_return), 0
	jne	0f
	movb	ah, 0x01
	movb	(_reg86+0), ah
	movb	(_reg86+13), ah
	ret
0:
	push	ebp
	push	esi
	push	edi
	push	ebx
	pushf
	cli

	inb	0xA1
	movb	ah, al
	inb	0x21
	push	eax
	mov	eax, (_irq_use)
	and	eax, ~[1<<0]
	outb	0x21
	movb	al, ah
	outb	0xA1

	mov	eax, 5*8
	mov	ss, ax
	xchg	esp, (_mon_sp)
	push	(_reg86+36)
	push	(_reg86+32)
	push	(_reg86+28)
	push	(_reg86+24)
	push	(_reg86+20)
	push	(_reg86+16)
	push	(_reg86+12)
	push	(_reg86+8)
	push	(_reg86+4)
	push	(_reg86+0)
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	push	cs
	push	return
	o16 jmpf	20+2*4+10*4+2*4(esp)
return:
	pop	(_reg86+0)
	pop	(_reg86+4)
	pop	(_reg86+8)
	pop	(_reg86+12)
	pop	(_reg86+16)
	pop	(_reg86+20)
	pop	(_reg86+24)
	pop	(_reg86+28)
	pop	(_reg86+32)
	pop	(_reg86+36)
	lgdt	(_gdt+1*8)
	jmpf	6*8:csinit
csinit:
	mov	eax, 3*8
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax
	xchg	esp, (_mon_sp)
	lidt	(_gdt+2*8)
! 183 "klib386.S"

	pop	eax
	outb	0x21
	movb	al, ah
	outb	0xA1

6:
	add	(_lost_ticks), ecx

	popf
	pop	ebx
	pop	edi
	pop	esi
	pop	ebp
	ret
! 261 "klib386.o.tmp"
_exit:
__exit:
___exit:
	sti
	jmp	___exit

___main:
	ret
! 279 "klib386.o.tmp"
_phys_insw:
	push	ebp
	mov	ebp, esp
	cld
	push	edi
	push	es

	mov	ecx, 4*8|1
	mov	es, cx
	mov	edx, 8(ebp)
	mov	edi, 12(ebp)
	mov	ecx, 16(ebp)
	shr	ecx, 1
	rep o16 ins
	pop	es
	pop	edi
	pop	ebp
	ret
! 307 "klib386.o.tmp"
_phys_insb:
	push	ebp
	mov	ebp, esp
	cld
	push	edi
	push	es

	mov	ecx, 4*8|1
	mov	es, cx
	mov	edx, 8(ebp)
	mov	edi, 12(ebp)
	mov	ecx, 16(ebp)
	rep insb
	pop	es
	pop	edi
	pop	ebp
	ret
! 334 "klib386.o.tmp"
.align	16
_phys_outsw:
	push	ebp
	mov	ebp, esp
	cld
	push	esi
	push	ds

	mov	ecx, 4*8|1
	mov	ds, cx
	mov	edx, 8(ebp)
	mov	esi, 12(ebp)
	mov	ecx, 16(ebp)
	shr	ecx, 1
	rep o16 outs
	pop	ds
	pop	esi
	pop	ebp
	ret
! 363 "klib386.o.tmp"
.align	16
_phys_outsb:
	push	ebp
	mov	ebp, esp
	cld
	push	esi
	push	ds

	mov	ecx, 4*8|1
	mov	ds, cx
	mov	edx, 8(ebp)
	mov	esi, 12(ebp)
	mov	ecx, 16(ebp)
	rep outsb
	pop	ds
	pop	esi
	pop	ebp
	ret
! 392 "klib386.o.tmp"
	PC_ARGS = 4+4+4+4


.align	16
_phys_copy:
	cld
	push	esi
	push	edi
	push	es

	mov	eax, 4*8|1
	mov	es, ax

	mov	esi, PC_ARGS(esp)
	mov	edi, PC_ARGS+4(esp)
	mov	eax, PC_ARGS+4+4(esp)

	cmp	eax, 10
	jb	pc_small
	mov	ecx, esi
	neg	ecx
	and	ecx, 3
	sub	eax, ecx

	rep eseg movsb
	mov	ecx, eax
	shr	ecx, 2

	rep eseg movs
	and	eax, 3
pc_small:
	xchg	ecx, eax

	rep eseg movsb

	mov	eax, 0
_phys_copy_fault:
	pop	es
	pop	edi
	pop	esi
	ret

_phys_copy_fault_in_kernel:
	pop	es
	pop	edi
	pop	esi
	mov	eax, cr2
	ret
! 450 "klib386.o.tmp"
.align	16
_phys_memset:
	push	ebp
	mov	ebp, esp
	push	esi
	push	ebx
	push	ds

	mov	esi, 8(ebp)
	mov	eax, 16(ebp)
	mov	ebx, 4*8|1
	mov	ds, bx
	mov	ebx, 12(ebp)
	shr	eax, 2
fill_start:
	mov	(esi), ebx
	add	esi, 4
	dec	eax
	jne	fill_start

	mov	eax, 16(ebp)
	and	eax, 3
remain_fill:
	cmp	eax, 0
	je	fill_done
	movb	bl, 12(ebp)
	movb	(esi), bl
	add	esi, 1
	inc	ebp
	dec	eax
	jmp	remain_fill
fill_done:
	pop	ds
	pop	ebx
	pop	esi
	pop	ebp
	ret
! 497 "klib386.o.tmp"
.align	16
_mem_rdw:
	mov	cx, ds
	mov	ds, 4(esp)
	mov	eax, 4+4(esp)
	movzx	eax, (eax)
	mov	ds, cx
	ret
! 515 "klib386.o.tmp"
_reset:
	lidt	(idt_zero)
	int	3
.sect .data
idt_zero:
.data4	0, 0
.sect .text
! 532 "klib386.o.tmp"
_halt_cpu:
	sti
	hlt
	cli
	ret









_level0:


	mov	ax, cs
	o16 cmp	ax, 6*8
	jne	0f


	mov	eax, 4(esp)
	call	eax
	ret



0:
	mov	eax, 4(esp)
	int	34
	ret








.align	16
_read_cpu_flags:
	pushf
	mov	eax, (esp)
	add	esp, 4
	ret

_read_ds:
	mov	eax, 0
	mov	ax, ds
	ret

_read_cs:
	mov	eax, 0
	mov	ax, cs
	ret

_read_ss:
	mov	eax, 0
	mov	ax, ss
	ret





_fninit:
	.data1 0xDB, 0xE3

	ret

_fnstsw:
	xor	eax, eax


	.data1 0xDF, 0xE0

	ret

_fnstcw:
	push	eax
	mov	eax, 8(esp)


	.data1 0xD9, 0x38

	pop	eax
	ret





_read_cr0:
	push	ebp
	mov	ebp, esp
	mov	eax, cr0
	pop	ebp
	ret





_write_cr0:
	push	ebp
	mov	ebp, esp
	mov	eax, 8(ebp)
	mov	cr0, eax
	jmp	0f
0:
	pop	ebp
	ret





_read_cr2:
	mov	eax, cr2
	ret





_read_cr4:
	push	ebp
	mov	ebp, esp


	.data1  0x0f, 0x20, 0xe0

	pop	ebp
	ret





_write_cr4:
	push	ebp
	mov	ebp, esp
	mov	eax, 8(ebp)


	.data1  0x0f, 0x22, 0xe0

	jmp	0f
0:
	pop	ebp
	ret




_getcr3val:
	mov	eax, cr3
	mov	(_thecr3), eax
	ret






.define	_ia32_msr_read
_ia32_msr_read:
	push	ebp
	mov	ebp, esp

	mov	ecx, 8(ebp)
	.data1 0x0f, 0x32

	mov	ecx, 12(ebp)
	mov	(ecx), edx
	mov	ecx, 16(ebp)
	mov	(ecx), eax

	pop	ebp
	ret






.define	_ia32_msr_write
_ia32_msr_write:
	push	ebp
	mov	ebp, esp

	mov	edx, 12(ebp)
	mov	eax, 16(ebp)
	mov	ecx, 8(ebp)
	.data1 0x0f, 0x30
.data1 0x0f, 0x30

	pop	ebp
	ret





.align	16
_idt_reload:
	lidt	(_gdt+2*8)
	ret
! 690 "klib386.S"

.define	_reload_ds
_reload_ds:
	mov	ax, ds; mov	ds, ax
	ret
