.sect .text
.extern	__chdeadline
.define	_chdeadline
.align 2

_chdeadline:
	jmp	__chdeadline
