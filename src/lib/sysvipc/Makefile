#Generated from ./sysvipc/Makefile.in
all: all-ack

all-ack:
all-gnu:

makefiles: Makefile
Makedepend-ack Makedepend-gnu: 
	sh .././generate.sh ./sysvipc ../obj-ack ../obj-gnu

Makefile: Makefile.in Makedepend-ack Makedepend-gnu
	sh .././generate.sh ./sysvipc ../obj-ack ../obj-gnu
	@echo
	@echo *Attention*
	@echo Makefile is regenerated... rerun command to see changes
	@echo *Attention*
	@echo

depend: depend-ack
all-ack: ../obj-ack/libc.a

../obj-ack/libc.a: ../obj-ack/libc.a(ftok.o)
../obj-ack/libc.a: ../obj-ack/libc.a(sem.o)
../obj-ack/libc.a: ../obj-ack/libc.a(shm.o)

../obj-ack/libc.a:
	ar cr ../obj-ack/libc.a ../obj-ack/./sysvipc/*.o
	rm ../obj-ack/./sysvipc/*.o

../obj-ack/libc.a(ftok.o): ftok.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../obj-ack/./sysvipc/ftok.o ftok.c
../obj-ack/libc.a(sem.o): sem.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../obj-ack/./sysvipc/sem.o sem.c
../obj-ack/libc.a(shm.o): shm.c
	cc -O -D_MINIX -D_POSIX_SOURCE -c -o ../obj-ack/./sysvipc/shm.o shm.c

all-gnu: ../obj-gnu/libc.a

../obj-gnu/libc.a: ../obj-gnu/./sysvipc/ftok.o
../obj-gnu/libc.a: ../obj-gnu/./sysvipc/sem.o
../obj-gnu/libc.a: ../obj-gnu/./sysvipc/shm.o

../obj-gnu/libc.a:
	gar cr ../obj-gnu/libc.a $?

../obj-gnu/./sysvipc/ftok.o: ftok.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../obj-gnu/./sysvipc/ftok.o ftok.c

../obj-gnu/./sysvipc/sem.o: sem.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../obj-gnu/./sysvipc/sem.o sem.c

../obj-gnu/./sysvipc/shm.o: shm.c
	gcc -O -D_MINIX -D_POSIX_SOURCE -c -o ../obj-gnu/./sysvipc/shm.o shm.c




clean::
	rm -f ../obj-ack/./sysvipc/*
	rm -f ../obj-gnu/./sysvipc/*

include Makedepend-ack
include .depend-ack

include Makedepend-gnu
include .depend-gnu
