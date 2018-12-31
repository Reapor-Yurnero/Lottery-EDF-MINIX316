! Translated from GNU to ACK by gas2ack
.sect .text; .sect .rom; .sect .data; .sect .bss
.sect .text
! 1 "backdoor.S"
! Part of libhgfs - (c) 2009, D.C. van Moolenbroek

.define	___libhgfs_backdoor
.define	___libhgfs_backdoor_in
.define	___libhgfs_backdoor_out

.sect .text

	MAGIC = 0x564D5868
	BD_PORT = 0x5658
	IO_PORT = 0x5659

.align	16
___libhgfs_backdoor:
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, 4+16(esp)
	mov	eax, MAGIC
	mov	ebx, 4(ebp)
	mov	ecx, 8(ebp)
	mov	edx, 12(ebp)
	o16 mov	dx, BD_PORT
	mov	esi, 16(ebp)
	mov	edi, 20(ebp)
	in	dx
	mov	(ebp), eax
	mov	4(ebp), ebx
	mov	8(ebp), ecx
	mov	12(ebp), edx
	mov	16(ebp), esi
	mov	20(ebp), edi
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret

.align	16
___libhgfs_backdoor_in:
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	eax, 4+16(esp)
	mov	ebx, 4(eax)
	mov	ecx, 8(eax)
	mov	edx, 12(eax)
	o16 mov	dx, IO_PORT
	mov	esi, 16(eax)
	mov	edi, 20(eax)
	mov	ebp, 24(eax)
	mov	eax, MAGIC
	cld
	repe insb
	push	eax
	mov	eax, 4+20(esp)
	mov	4(eax), ebx
	mov	8(eax), ecx
	mov	12(eax), edx
	mov	16(eax), esi
	mov	20(eax), edi
	mov	24(eax), ebp
	pop	ebx
	mov	(eax), ebx
	mov	eax, (eax)
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret

.align	16
___libhgfs_backdoor_out:
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	eax, 4+16(esp)
	mov	ebx, 4(eax)
	mov	ecx, 8(eax)
	mov	edx, 12(eax)
	o16 mov	dx, IO_PORT
	mov	esi, 16(eax)
	mov	edi, 20(eax)
	mov	ebp, 24(eax)
	mov	eax, MAGIC
	cld
	repe outsb
	push	eax
	mov	eax, 4+20(esp)
	mov	4(eax), ebx
	mov	8(eax), ecx
	mov	12(eax), edx
	mov	16(eax), esi
	mov	20(eax), edi
	mov	24(eax), ebp
	pop	ebx
	mov	(eax), ebx
	mov	eax, (eax)
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret
