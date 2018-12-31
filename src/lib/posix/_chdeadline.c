#include <lib.h>
#define chdeadline _chdeadline
#include <unistd.h>

PUBLIC int chdeadline (long deadline){
	message m;
	m.m2_l1 = deadline;
	alarm ((unsigned int)deadline);
	return(_syscall(MM,CHDEADLINE,&m));
}
