#Generated from ./i386/math/Makefile.in
all: all-ack

all-ack:
all-gnu:

makefiles: Makefile
Makedepend-ack Makedepend-gnu: 
	sh ../.././generate.sh ./i386/math ../../obj-ack ../../obj-gnu

Makefile: Makefile.in Makedepend-ack Makedepend-gnu
	sh ../.././generate.sh ./i386/math ../../obj-ack ../../obj-gnu
	@echo
	@echo *Attention*
	@echo Makefile is regenerated... rerun command to see changes
	@echo *Attention*
	@echo

depend: depend-ack
all-ack: ../../obj-ack/libc.a

../../obj-ack/libc.a: ../../obj-ack/libc.a(arch_compare.o)
../../obj-ack/libc.a: ../../obj-ack/libc.a(arch_round.o)
../../obj-ack/libc.a: ../../obj-ack/libc.a(fpu_cw.o)
../../obj-ack/libc.a: ../../obj-ack/libc.a(fpu_sw.o)
../../obj-ack/libc.a: ../../obj-ack/libc.a(fpu_round.o)
../../obj-ack/libc.a: ../../obj-ack/libc.a(fegetround.o)
../../obj-ack/libc.a: ../../obj-ack/libc.a(feholdexcept.o)
../../obj-ack/libc.a: ../../obj-ack/libc.a(fesetround.o)

../../obj-ack/libc.a:
	ar cr ../../obj-ack/libc.a ../../obj-ack/./i386/math/*.o
	rm ../../obj-ack/./i386/math/*.o

../../obj-ack/libc.a(arch_compare.o): arch_compare.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/arch_compare.o arch_compare.c
../../obj-ack/libc.a(arch_round.o): arch_round.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/arch_round.o arch_round.c
../../obj-ack/libc.a(fpu_cw.o): fpu_cw.s
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/fpu_cw.o fpu_cw.s
../../obj-ack/libc.a(fpu_sw.o): fpu_sw.s
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/fpu_sw.o fpu_sw.s
../../obj-ack/libc.a(fpu_round.o): fpu_round.s
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/fpu_round.o fpu_round.s
../../obj-ack/libc.a(fegetround.o): fegetround.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/fegetround.o fegetround.c
../../obj-ack/libc.a(feholdexcept.o): feholdexcept.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/feholdexcept.o feholdexcept.c
../../obj-ack/libc.a(fesetround.o): fesetround.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-ack/./i386/math/fesetround.o fesetround.c

all-gnu: ../../obj-gnu/libc.a

../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/arch_compare.o
../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/arch_round.o
../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/fpu_cw.o
../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/fpu_sw.o
../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/fpu_round.o
../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/fegetround.o
../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/feholdexcept.o
../../obj-gnu/libc.a: ../../obj-gnu/./i386/math/fesetround.o

../../obj-gnu/libc.a:
	gar cr ../../obj-gnu/libc.a $?

../../obj-gnu/./i386/math/arch_compare.o: arch_compare.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-gnu/./i386/math/arch_compare.o arch_compare.c

../../obj-gnu/./i386/math/arch_round.o: arch_round.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-gnu/./i386/math/arch_round.o arch_round.c

../../obj-gnu/./i386/math/fpu_cw.o: fpu_cw.s
	gcc -O -D_MINIX -D_POSIX_SOURCE -E -x assembler-with-cpp -I. fpu_cw.s | asmconv -mi386 ack gnu > ../../obj-gnu/./i386/math/fpu_cw.s.gnu
	gas -o ../../obj-gnu/./i386/math/fpu_cw.o ../../obj-gnu/./i386/math/fpu_cw.s.gnu

../../obj-gnu/./i386/math/fpu_sw.o: fpu_sw.s
	gcc -O -D_MINIX -D_POSIX_SOURCE -E -x assembler-with-cpp -I. fpu_sw.s | asmconv -mi386 ack gnu > ../../obj-gnu/./i386/math/fpu_sw.s.gnu
	gas -o ../../obj-gnu/./i386/math/fpu_sw.o ../../obj-gnu/./i386/math/fpu_sw.s.gnu

../../obj-gnu/./i386/math/fpu_round.o: fpu_round.s
	gcc -O -D_MINIX -D_POSIX_SOURCE -E -x assembler-with-cpp -I. fpu_round.s | asmconv -mi386 ack gnu > ../../obj-gnu/./i386/math/fpu_round.s.gnu
	gas -o ../../obj-gnu/./i386/math/fpu_round.o ../../obj-gnu/./i386/math/fpu_round.s.gnu

../../obj-gnu/./i386/math/fegetround.o: fegetround.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-gnu/./i386/math/fegetround.o fegetround.c

../../obj-gnu/./i386/math/feholdexcept.o: feholdexcept.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-gnu/./i386/math/feholdexcept.o feholdexcept.c

../../obj-gnu/./i386/math/fesetround.o: fesetround.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../../obj-gnu/./i386/math/fesetround.o fesetround.c




clean::
	rm -f ../../obj-ack/./i386/math/*
	rm -f ../../obj-gnu/./i386/math/*

include Makedepend-ack
include .depend-ack

include Makedepend-gnu
include .depend-gnu
