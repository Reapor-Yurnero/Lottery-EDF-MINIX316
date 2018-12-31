#Generated from ./stdtime/Makefile.in
all: all-ack

all-ack:
all-gnu:

makefiles: Makefile
Makedepend-ack Makedepend-gnu: 
	sh .././generate.sh ./stdtime ../obj-ack ../obj-gnu

Makefile: Makefile.in Makedepend-ack Makedepend-gnu
	sh .././generate.sh ./stdtime ../obj-ack ../obj-gnu
	@echo
	@echo *Attention*
	@echo Makefile is regenerated... rerun command to see changes
	@echo *Attention*
	@echo

depend: depend-ack
all-ack: ../obj-ack/libc.a

../obj-ack/libc.a: ../obj-ack/libc.a(ftime.o)
../obj-ack/libc.a: ../obj-ack/libc.a(asctime.o)
../obj-ack/libc.a: ../obj-ack/libc.a(localtime.o)
../obj-ack/libc.a: ../obj-ack/libc.a(strftime.o)

../obj-ack/libc.a:
	ar cr ../obj-ack/libc.a ../obj-ack/./stdtime/*.o
	rm ../obj-ack/./stdtime/*.o

../obj-ack/libc.a(ftime.o): ftime.c
	cc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-ack/./stdtime/ftime.o ftime.c
../obj-ack/libc.a(asctime.o): asctime.c
	cc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-ack/./stdtime/asctime.o asctime.c
../obj-ack/libc.a(localtime.o): localtime.c
	cc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-ack/./stdtime/localtime.o localtime.c
../obj-ack/libc.a(strftime.o): strftime.c
	cc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-ack/./stdtime/strftime.o strftime.c

all-gnu: ../obj-gnu/libc.a

../obj-gnu/libc.a: ../obj-gnu/./stdtime/ftime.o
../obj-gnu/libc.a: ../obj-gnu/./stdtime/asctime.o
../obj-gnu/libc.a: ../obj-gnu/./stdtime/localtime.o
../obj-gnu/libc.a: ../obj-gnu/./stdtime/strftime.o

../obj-gnu/libc.a:
	gar cr ../obj-gnu/libc.a $?

../obj-gnu/./stdtime/ftime.o: ftime.c
	gcc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-gnu/./stdtime/ftime.o ftime.c

../obj-gnu/./stdtime/asctime.o: asctime.c
	gcc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-gnu/./stdtime/asctime.o asctime.c

../obj-gnu/./stdtime/localtime.o: localtime.c
	gcc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-gnu/./stdtime/localtime.o localtime.c

../obj-gnu/./stdtime/strftime.o: strftime.c
	gcc -D_MINIX -D_POSIX_SOURCE -D__USG -I../../commands/zoneinfo -c -o ../obj-gnu/./stdtime/strftime.o strftime.c




clean::
	rm -f ../obj-ack/./stdtime/*
	rm -f ../obj-gnu/./stdtime/*

include Makedepend-ack
include .depend-ack

include Makedepend-gnu
include .depend-gnu
