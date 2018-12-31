#Generated from ./gnu/rts/Makefile.in
all: all-ack

all-ack:
all-gnu:

makefiles: Makefile
Makedepend-ack Makedepend-gnu: 
	sh ../.././generate.sh ./gnu/rts ../../obj-ack ../../obj-gnu

Makefile: Makefile.in Makedepend-ack Makedepend-gnu
	sh ../.././generate.sh ./gnu/rts ../../obj-ack ../../obj-gnu
	@echo
	@echo *Attention*
	@echo Makefile is regenerated... rerun command to see changes
	@echo *Attention*
	@echo

depend: depend-ack
all-gnu: ../../obj-gnu/libc.a

../../obj-gnu/libc.a: ../../obj-gnu/./gnu/rts/__setjmp.o
../../obj-gnu/libc.a: ../../obj-gnu/./gnu/rts/longjmp.o

../../obj-gnu/libc.a:
	gar cr ../../obj-gnu/libc.a $?

../../obj-gnu/./gnu/rts/__setjmp.o: __setjmp.gs
	gas -o ../../obj-gnu/./gnu/rts/__setjmp.o __setjmp.gs

../../obj-gnu/./gnu/rts/longjmp.o: longjmp.gs
	gas -o ../../obj-gnu/./gnu/rts/longjmp.o longjmp.gs




clean::
	rm -f ../../obj-gnu/./gnu/rts/*

include Makedepend-ack
include .depend-ack

include Makedepend-gnu
include .depend-gnu
