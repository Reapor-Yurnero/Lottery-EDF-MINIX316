! Translated from GNU to ACK by gas2ack
.sect .text; .sect .rom; .sect .data; .sect .bss
.sect .text
! 1 "mpx386.o.tmp"
! 1 "mpx386.S"
! 3 "./../../kernel.h"
! 54 "./../../kernel.h"
! 46 "mpx386.S"
! 5 "/usr/include/sys/vm_i386.h"
! 71 "/usr/include/sys/vm_i386.h"
! 50 "mpx386.S"


.sect .text
begtext:

.sect .rom
! 59 "mpx386.S"
begrom:
.sect .data
begdata:
.sect .bss
begbss:
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
! 25 "/usr/include/minix/com.h"
! 43 "/usr/include/minix/com.h"
! 172 "/usr/include/minix/com.h"
! 501 "/usr/include/minix/com.h"
! 525 "/usr/include/minix/com.h"
! 772 "/usr/include/minix/com.h"
! 796 "/usr/include/minix/com.h"
! 808 "/usr/include/minix/com.h"
! 998 "/usr/include/minix/com.h"
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
! 3 "./../../proc.h"
! 125 "./../../proc.h"
! 152 "./../../proc.h"
! 173 "./../../proc.h"
! 186 "./../../proc.h"
! 196 "./../../proc.h"
! 210 "./../../proc.h"
! 220 "./../../proc.h"
! 235 "./../../proc.h"
! 248 "./../../proc.h"
! 281 "./../../proc.h"
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
! 75 "mpx386.S"
! 139 "mpx386.o.tmp"
.define	_restart
.define	_reload_cr3
.define	_write_cr3

.define	_divide_error
.define	_single_step_exception
.define	_nmi
.define	_breakpoint_exception
.define	_overflow
.define	_bounds_check
.define	_inval_opcode
.define	_copr_not_available
.define	_double_fault
.define	_copr_seg_overrun
.define	_inval_tss
.define	_segment_not_present
.define	_stack_exception
.define	_general_protection
.define	_page_fault
.define	_copr_error
.define	_alignment_check
.define	_machine_check
.define	_simd_exception
.define	_params_size
.define	_params_offset
.define	_mon_ds
.define	_schedcheck
.define	_dirtypde
.define	_lazy_fpu

.define	_hwint00
.define	_hwint01
.define	_hwint02
.define	_hwint03
.define	_hwint04
.define	_hwint05
.define	_hwint06
.define	_hwint07
.define	_hwint08
.define	_hwint09
.define	_hwint10
.define	_hwint11
.define	_hwint12
.define	_hwint13
.define	_hwint14
.define	_hwint15

.define	_level0_call


.define	begbss
.define	begdata

.sect .text



.define	_MINIX
_MINIX:

	jmp	over_flags
.data2	12

flags:






.data2	0x01FD
	nop
over_flags:



	movzx	esp, sp
	push	ebp
	mov	ebp, esp
	push	esi
	push	edi
	cmp	4(ebp), 0
	je	noret
	inc	(_mon_return)
noret:
	mov	(_mon_sp), esp




	sgdt	(_gdt+1*8)
	mov	esi, (_gdt+1*8+2)
	mov	ebx, _gdt
	mov	ecx, 8*8
copygdt:
	eseg movb	al, (esi)
	movb	(ebx), al
	inc	esi
	inc	ebx
	loop	copygdt
	mov	eax, (_gdt+3*8+2)
	and	eax, 0x00FFFFFF
	add	eax, _gdt
	mov	(_gdt+1*8+2), eax
	lgdt	(_gdt+1*8)


	mov	ebx, 8(ebp)
	mov	edx, 12(ebp)
	mov	eax, 16(ebp)
	mov	(_aout), eax
	mov	ax, ds
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax
	mov	esp, _k_boot_stktop


	mov	(_params_size), edx
	mov	(_params_offset), ebx
	mov	(_mon_ds), 5*8


	push	edx
	push	ebx
	push	5*8
	push	3*8
	push	6*8
	call	_cstart
	add	esp, 5*4




	lgdt	(_gdt+1*8)
	lidt	(_gdt+2*8)

	jmpf	6*8:csinit
csinit:
	o16 mov	ax, 3*8
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax
	o16 mov	ax, 10*8
	ltr	ax
	push	0
	popf
	jmp	_main
! 249 "mpx386.S"
! 272 "mpx386.S"


.align	16
_hwint00:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	0; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	0; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret

.align	16
_hwint01:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	1; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	1; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret

.align	16
_hwint02:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	2; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	2; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret

.align	16
_hwint03:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	3; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	3; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret

.align	16
_hwint04:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	4; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	4; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret

.align	16
_hwint05:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	5; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	5; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret

.align	16
_hwint06:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	6; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	6; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret

.align	16
_hwint07:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	7; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; jmp	_restart; 0:
	pusha; push	7; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; popa; iret
! 337 "mpx386.S"


.align	16
_hwint08:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	8; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	8; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret

.align	16
_hwint09:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	9; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	9; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret

.align	16
_hwint10:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	10; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	10; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret

.align	16
_hwint11:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	11; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	11; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret

.align	16
_hwint12:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	12; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	12; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret

.align	16
_hwint13:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	13; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	13; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret

.align	16
_hwint14:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	14; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	14; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret

.align	16
_hwint15:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	15; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; jmp	_restart; 0:
	pusha; push	15; call	_irq_handle; add	esp, 4; movb	al, 0x20; outb	0x20; outb	0xA0; popa; iret




.align	16
.define	_syscall_entry
_syscall_entry:

	push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4


	push	ebp






	push	edx
	push	ebx
	push	eax
	push	ecx


	mov	ebp, 0

	call	_sys_call


	add	esp, 4*4
	pop	esi
	mov	AXREG(esi), eax

	jmp	_restart


.align	16






exception_entry:




	cmp	12(esp), 6*8; je	exception_entry_nested

exception_entry_from_user:

	cld

	push	ebp; mov	ebp, [20+4+8](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+8](esp); mov	PCREG(ebp), esi; mov	esi, [4+8](esp); mov	CSREG(ebp), esi; mov	esi, [8+8](esp); mov	PSWREG(ebp), esi; mov	esi, [12+8](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+8](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4


	mov	ebp, 0






	push	esp
	push	0
	call	_exception_handler

	jmp	_restart

exception_entry_nested:

	pusha
	mov	eax, esp
	add	eax, [8*4]
	push	eax
	push	1
	call	_exception_handler
	add	esp, 8
	popa


	add	esp, 8

	iret




_restart:
	call	_schedcheck


	mov	ebp, eax

	cmp	P_CR3(ebp), 0
	je	0f





	mov	eax, P_CR3(ebp)
	mov	ecx, cr3
	cmp	eax, ecx
	je	0f
	mov	cr3, eax
	mov	(_ptproc), ebp
	mov	(_dirtypde), 0
0:


	mov	eax, SSREG(ebp)
	push	eax
	mov	eax, SPREG(ebp)
	push	eax
	mov	eax, PSWREG(ebp)
	push	eax
	mov	eax, CSREG(ebp)
	push	eax
	mov	eax, PCREG(ebp)
	push	eax

	sseg mov	eax, AXREG(ebp); sseg mov	ecx, CXREG(ebp); sseg mov	edx, DXREG(ebp); sseg mov	ebx, BXREG(ebp); sseg mov	esi, SIREG(ebp); sseg mov	edi, DIREG(ebp)

	lldt	P_LDT_SEL(ebp)
	sseg o16 mov	ds, DSREG(ebp); sseg o16 mov	es, ESREG(ebp); sseg o16 mov	fs, FSREG(ebp); sseg o16 mov	gs, GSREG(ebp)

	sseg mov	ebp, BPREG(ebp)

	iret
! 517 "mpx386.S"
! 521 "mpx386.S"

_divide_error:
	push	0; push	0; jmp	exception_entry

_single_step_exception:
	push	0; push	1; jmp	exception_entry

_nmi:
! 540 "mpx386.S"






	o16 push	ds
	o16 push	es
	o16 push	fs
	o16 push	gs
	pusha





	mov	si, ss
	mov	ds, si
	mov	es, si

	push	esp
	call	_nmi_watchdog_handler
	add	esp, 4


	popa
	o16 pop	gs
	o16 pop	fs
	o16 pop	es
	o16 pop	ds

	iret


_breakpoint_exception:
	push	0; push	3; jmp	exception_entry

_overflow:
	push	0; push	4; jmp	exception_entry

_bounds_check:
	push	0; push	5; jmp	exception_entry

_inval_opcode:
	push	0; push	6; jmp	exception_entry

_copr_not_available:
	cmp	4(esp), 6*8; je	copr_not_available_in_kernel
	clts
	cld
	push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi
	lea	ebx, P_MISC_FLAGS(ebp)
	o16 mov	cx, (ebx)
	and	cx, 0x1000
	jne	0f
	o16 or	(ebx), 0x1000
	.data1 0xDB, 0xE3

	jmp	copr_return
0:
	sseg mov	eax, FP_SAVE_AREA_P(ebp)
	cmp	(_osfxsr_feature), 0
	je	fp_l_no_fxsr


	.data1 0x0F, 0xAE, 0x08

	jmp	copr_return
fp_l_no_fxsr:

	.data1 0xDD, 0x20

copr_return:
	o16 or	(ebx), 0x800
	jmp	_restart

copr_not_available_in_kernel:
	mov	4(esp), 0x8000
	mov	(esp), 0
	call	_minix_panic

_double_fault:
	push	8; jmp	exception_entry

_copr_seg_overrun:
	push	0; push	9; jmp	exception_entry

_inval_tss:
	push	10; jmp	exception_entry

_segment_not_present:
	push	11; jmp	exception_entry

_stack_exception:
	push	12; jmp	exception_entry

_general_protection:
	push	13; jmp	exception_entry

_page_fault:
	push	14; jmp	exception_entry

_copr_error:
	push	0; push	16; jmp	exception_entry

_alignment_check:
	push	0; push	17; jmp	exception_entry

_machine_check:
	push	0; push	18; jmp	exception_entry

_simd_exception:
	push	0; push	19; jmp	exception_entry









_lazy_fpu:
	push	ebp
	mov	ebp, esp
	push	eax
	push	ebx
	push	ecx
	cmp	(_fpu_presence), 0
	je	no_fpu_available
	mov	eax, 8(ebp)
	lea	ebx, P_MISC_FLAGS(eax)
	o16 mov	cx, (ebx)
	and	cx, 0x800
	je	0f
	sseg mov	eax, FP_SAVE_AREA_P(eax)
	cmp	(_osfxsr_feature), 0
	je	fp_s_no_fxsr


	.data1 0x0F, 0xAE, 0x00

	.data1 0xDB, 0xE3

	jmp	fp_saved
fp_s_no_fxsr:

	.data1 0xDD, 0x30

	.data1 0x9B

fp_saved:
	o16 and	(ebx), ~0x800
0:
	mov	eax, cr0
	or	eax, 0x00000008
	mov	cr0, eax
no_fpu_available:
	pop	ecx
	pop	ebx
	pop	eax
	pop	ebp
	ret





_write_cr3:
	push	ebp
	mov	ebp, esp
	mov	eax, 8(ebp)
	mov	ecx, cr3
	cmp	eax, ecx
	je	0f
	mov	cr3, eax
	mov	(_dirtypde), 0
0:
	pop	ebp
	ret




_level0_call:



	push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4

	mov	ebp, 0




	call	eax
	jmp	_restart






_reload_cr3:
	push	ebp
	mov	ebp, esp
	mov	(_dirtypde), 0
	mov	eax, cr3
	mov	cr3, eax
	pop	ebp
	ret






.sect .rom
! 753 "mpx386.S"
.data2	0x526F

.sect .bss




.define	_k_boot_stktop
k_boot_stack:
.space	4096
_k_boot_stktop:
