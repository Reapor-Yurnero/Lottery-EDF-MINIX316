# Lottery-EDF-MINIX316

Lottery and EDF scheduling for MINIX3.1.6 (VE482 project 3).

## Usage

* Simply remove the old src directory and copy the new one or apply the patch file.

* `make world` for the first time build in `/usr/src/` or `make clean` and `make fresh install` in `/usr/src/tools` for non-first time build

* reboot the system

* Press Esc at the booting stage to enter boot loader.

* type `scheduler=n` where n = 0 -> default scheduler, 1 -> lottery scheduler, 2->EDF scheduler

* type `boot` to boot-up

## Test

Two test cases `test1.c` `test2.c` were modified in `/usr/src/test`. Simply `make` and `./test1` or `./test2` to run the test.

* `test1` was designed to test the lottery scheduler. We use nice() system call to generate a few subprocesses with slightly different priority. With default scheduler, the sequence of execution is almost constant while with lottery scheduler, the sequence is somehow randomized.

* `test2` was designed to test the EDF scheduler. The main process is spawning 5 subprocesses which is declaring deadlines in descent order with the third subprocess as an exception which has a less urgent deadline. We could observe the execution sequence is following the principle that earliest deadline first if we run the test.

## Design Strategy

Scheduling is mainly implemented in `pick_proc()` function in `proc.c`.

* Lottery scheduling is naive. Certain amount of tickets are dispatched to each processes according to their priority and a random draft is executed.

* EDF scheduling reads the declared deadlines of all processes in priority queue 7, which is the user-space process queue of the highest priority and reserved for real-time processes. Processes can declare their deadlines with a new library function `chdeadline()`. Process which miss its deadline will be killed and announced.

* Boot option for each scheduler is implemented in `start.c`. This is where the booting process is called and before the kernel is built up.

## Credit

This project is the team effort of Xiaohan Fu and Wenda Tang.
