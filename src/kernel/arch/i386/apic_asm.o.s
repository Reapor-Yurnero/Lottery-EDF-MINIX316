! Translated from GNU to ACK by gas2ack
.sect .text; .sect .rom; .sect .data; .sect .bss
.sect .text
! 1 "apic_asm.o.tmp"
! 1 "apic_asm.S"
! 1 "include/archconst.h"
! 1 "/usr/include/ibm/interrupt.h"
! 59 "/usr/include/ibm/interrupt.h"
! 7 "/usr/include/ibm/memory.h"
! 7 "include/archconst.h"
! 146 "include/archconst.h"
! 3 "./apic.h"
! 159 "./apic.h"
! 3 "./sconst.h"
! 1 "./../../const.h"
! 3 "/usr/include/minix/config.h"
! 3 "/usr/include/minix/sys_config.h"
! 43 "/usr/include/minix/sys_config.h"
! 48 "/usr/include/minix/sys_config.h"
! 53 "/usr/include/minix/sys_config.h"
! 61 "/usr/include/minix/sys_config.h"
! 65 "/usr/include/minix/sys_config.h"
! 69 "/usr/include/minix/sys_config.h"
! 24 "/usr/include/minix/config.h"
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
! 3 "./apic_asm.h"
! 30 "./apic_asm.h"
! 41 "./apic_asm.h"
! 5 "apic_asm.S"

.define	_apic_hwint00
.define	_apic_hwint01
.define	_apic_hwint02
.define	_apic_hwint03
.define	_apic_hwint04
.define	_apic_hwint05
.define	_apic_hwint06
.define	_apic_hwint07
.define	_apic_hwint08
.define	_apic_hwint09
.define	_apic_hwint10
.define	_apic_hwint11
.define	_apic_hwint12
.define	_apic_hwint13
.define	_apic_hwint14
.define	_apic_hwint15
! 30 "apic_asm.S"
! 48 "apic_asm.S"


.align	16
_apic_hwint00:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	0; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	0; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint01:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	1; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	1; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint02:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	2; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	2; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint03:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	3; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	3; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint04:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	4; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	4; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint05:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	5; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	5; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint06:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	6; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	6; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint07:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	7; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	7; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint08:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	8; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	8; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint09:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	9; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	9; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint10:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	10; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	10; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint11:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	11; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	11; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint12:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	12; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	12; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint13:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	13; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	13; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint14:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	14; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	14; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.align	16
_apic_hwint15:

	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; push	15; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; push	15; call	_irq_handle; add	esp, 4; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret
! 136 "apic_asm.S"
! 154 "apic_asm.S"


.define	_lapic_bsp_timer_int_handler
_lapic_bsp_timer_int_handler:
	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; mov	eax, _bsp_timer_int_handler; call	eax; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; mov	eax, _bsp_timer_int_handler; call	eax; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret

.define	_lapic_ap_timer_int_handler
_lapic_ap_timer_int_handler:
	cmp	4(esp), 6*8; je	0f; push	ebp; mov	ebp, [20+4+0](esp); sseg mov	DSREG(ebp), ds; sseg mov	ESREG(ebp), es; sseg mov	FSREG(ebp), fs; sseg mov	GSREG(ebp), gs; sseg mov	AXREG(ebp), eax; sseg mov	CXREG(ebp), ecx; sseg mov	DXREG(ebp), edx; sseg mov	BXREG(ebp), ebx; sseg mov	SIREG(ebp), esi; sseg mov	DIREG(ebp), edi; pop	esi; sseg mov	BPREG(ebp), esi; mov	si, ss; mov	ds, si; mov	es, si; o16 mov	si, 0; mov	gs, si; mov	fs, si; mov	esi, [0+0](esp); mov	PCREG(ebp), esi; mov	esi, [4+0](esp); mov	CSREG(ebp), esi; mov	esi, [8+0](esp); mov	PSWREG(ebp), esi; mov	esi, [12+0](esp); mov	SPREG(ebp), esi; mov	STREG(ebp), esi; mov	esi, [16+0](esp); mov	SSREG(ebp), esi; push	ebp; call	_lazy_fpu; add	esp, 4; mov	ebp, 0; mov	eax, _ap_timer_int_handler; call	eax; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; jmp	_restart; 0:
	pusha; mov	eax, _ap_timer_int_handler; call	eax; mov	eax, (_lapic_eoi_addr); mov	(eax), 0; popa; iret



.sect .data
lapic_intr_dummy_handler_msg:
.ascii	"UNHABLED APIC interrupt vector %d\012"

.sect .text
! 177 "apic_asm.S"
! 181 "apic_asm.S"

.define	_lapic_intr_dummy_handles_start
_lapic_intr_dummy_handles_start:

.align	32; lapic_intr_dummy_handler_0:
	push	0; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_1:
	push	1; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_2:
	push	2; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_3:
	push	3; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_4:
	push	4; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_5:
	push	5; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_6:
	push	6; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_7:
	push	7; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_8:
	push	8; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_9:
	push	9; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_10:
	push	10; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_11:
	push	11; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_12:
	push	12; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_13:
	push	13; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_14:
	push	14; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_15:
	push	15; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_16:
	push	16; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_17:
	push	17; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_18:
	push	18; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_19:
	push	19; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_20:
	push	20; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_21:
	push	21; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_22:
	push	22; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_23:
	push	23; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_24:
	push	24; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_25:
	push	25; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_26:
	push	26; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_27:
	push	27; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_28:
	push	28; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_29:
	push	29; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_30:
	push	30; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_31:
	push	31; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_32:
	push	32; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_33:
	push	33; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_34:
	push	34; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_35:
	push	35; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_36:
	push	36; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_37:
	push	37; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_38:
	push	38; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_39:
	push	39; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_40:
	push	40; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_41:
	push	41; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_42:
	push	42; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_43:
	push	43; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_44:
	push	44; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_45:
	push	45; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_46:
	push	46; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_47:
	push	47; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_48:
	push	48; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_49:
	push	49; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_50:
	push	50; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_51:
	push	51; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_52:
	push	52; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_53:
	push	53; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_54:
	push	54; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_55:
	push	55; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_56:
	push	56; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_57:
	push	57; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_58:
	push	58; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_59:
	push	59; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_60:
	push	60; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_61:
	push	61; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_62:
	push	62; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_63:
	push	63; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_64:
	push	64; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_65:
	push	65; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_66:
	push	66; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_67:
	push	67; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_68:
	push	68; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_69:
	push	69; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_70:
	push	70; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_71:
	push	71; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_72:
	push	72; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_73:
	push	73; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_74:
	push	74; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_75:
	push	75; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_76:
	push	76; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_77:
	push	77; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_78:
	push	78; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_79:
	push	79; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_80:
	push	80; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_81:
	push	81; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_82:
	push	82; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_83:
	push	83; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_84:
	push	84; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_85:
	push	85; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_86:
	push	86; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_87:
	push	87; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_88:
	push	88; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_89:
	push	89; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_90:
	push	90; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_91:
	push	91; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_92:
	push	92; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_93:
	push	93; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_94:
	push	94; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_95:
	push	95; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_96:
	push	96; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_97:
	push	97; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_98:
	push	98; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_99:
	push	99; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_100:
	push	100; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_101:
	push	101; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_102:
	push	102; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_103:
	push	103; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_104:
	push	104; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_105:
	push	105; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_106:
	push	106; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_107:
	push	107; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_108:
	push	108; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_109:
	push	109; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_110:
	push	110; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_111:
	push	111; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_112:
	push	112; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_113:
	push	113; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_114:
	push	114; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_115:
	push	115; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_116:
	push	116; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_117:
	push	117; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_118:
	push	118; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_119:
	push	119; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_120:
	push	120; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_121:
	push	121; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_122:
	push	122; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_123:
	push	123; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_124:
	push	124; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_125:
	push	125; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_126:
	push	126; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_127:
	push	127; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_128:
	push	128; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_129:
	push	129; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_130:
	push	130; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_131:
	push	131; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_132:
	push	132; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_133:
	push	133; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_134:
	push	134; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_135:
	push	135; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_136:
	push	136; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_137:
	push	137; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_138:
	push	138; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_139:
	push	139; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_140:
	push	140; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_141:
	push	141; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_142:
	push	142; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_143:
	push	143; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_144:
	push	144; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_145:
	push	145; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_146:
	push	146; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_147:
	push	147; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_148:
	push	148; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_149:
	push	149; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_150:
	push	150; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_151:
	push	151; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_152:
	push	152; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_153:
	push	153; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_154:
	push	154; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_155:
	push	155; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_156:
	push	156; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_157:
	push	157; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_158:
	push	158; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_159:
	push	159; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_160:
	push	160; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_161:
	push	161; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_162:
	push	162; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_163:
	push	163; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_164:
	push	164; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_165:
	push	165; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_166:
	push	166; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_167:
	push	167; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_168:
	push	168; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_169:
	push	169; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_170:
	push	170; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_171:
	push	171; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_172:
	push	172; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_173:
	push	173; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_174:
	push	174; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_175:
	push	175; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_176:
	push	176; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_177:
	push	177; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_178:
	push	178; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_179:
	push	179; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_180:
	push	180; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_181:
	push	181; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_182:
	push	182; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_183:
	push	183; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_184:
	push	184; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_185:
	push	185; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_186:
	push	186; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_187:
	push	187; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_188:
	push	188; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_189:
	push	189; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_190:
	push	190; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_191:
	push	191; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_192:
	push	192; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_193:
	push	193; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_194:
	push	194; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_195:
	push	195; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_196:
	push	196; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_197:
	push	197; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_198:
	push	198; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_199:
	push	199; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_200:
	push	200; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_201:
	push	201; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_202:
	push	202; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_203:
	push	203; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_204:
	push	204; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_205:
	push	205; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_206:
	push	206; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_207:
	push	207; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_208:
	push	208; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_209:
	push	209; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_210:
	push	210; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_211:
	push	211; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_212:
	push	212; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_213:
	push	213; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_214:
	push	214; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_215:
	push	215; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_216:
	push	216; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_217:
	push	217; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_218:
	push	218; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_219:
	push	219; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_220:
	push	220; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_221:
	push	221; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_222:
	push	222; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_223:
	push	223; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_224:
	push	224; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_225:
	push	225; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_226:
	push	226; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_227:
	push	227; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_228:
	push	228; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_229:
	push	229; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_230:
	push	230; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_231:
	push	231; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_232:
	push	232; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_233:
	push	233; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_234:
	push	234; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_235:
	push	235; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_236:
	push	236; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_237:
	push	237; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_238:
	push	238; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_239:
	push	239; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_240:
	push	240; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_241:
	push	241; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_242:
	push	242; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_243:
	push	243; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_244:
	push	244; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_245:
	push	245; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_246:
	push	246; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_247:
	push	247; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_248:
	push	248; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_249:
	push	249; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_250:
	push	250; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_251:
	push	251; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_252:
	push	252; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_253:
	push	253; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_254:
	push	254; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b
.align	32; lapic_intr_dummy_handler_255:
	push	255; push	lapic_intr_dummy_handler_msg; call	_kprintf; 1:
	jmp	1b

.define	_lapic_intr_dummy_handles_end
_lapic_intr_dummy_handles_end:
