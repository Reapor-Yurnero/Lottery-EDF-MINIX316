/* The kernel call implemented in this file:
 * m_type:	SYS_CHDEADLINE
 *
 * The parameters for this kernel call are:
 *    m2_i1: a process
 *    m2_l1: deadline
 */

#include <stdio.h>
#include "../system.h"
#include <signal.h>

#if USE_CHDEADLINE

/*===========================================================================*
 *				do_chdeadline				     *
 *===========================================================================*/
void reach_deadline(timer_t * time_p){
	printf("Process %d reaches deadline\n", time_p->tmr_arg.ta_int);
	cause_sig(time_p->tmr_arg.ta_int, SIGTERM);
	return;
}

PUBLIC int do_chdeadline(m_ptr)
register message *m_ptr;
{
	struct proc *rp;
	timer_t *time_p;
	rp = proc_addr(m_ptr->m2_i1);
	RTS_LOCK_SET(rp,RTS_SYS_LOCK);
	if(rp->p_deadline.tmr_exp_time > 0){
		reset_timer(&rp->p_deadline);
		rp->p_deadline.tmr_exp_time = 0;
	}
	if (m_ptr->m2_l1!=0){
		time_p = &rp->p_deadline;
		time_p->tmr_exp_time = m_ptr->m2_l1*60 + get_uptime();
		time_p->tmr_func = reach_deadline;
		time_p->tmr_arg.ta_int = rp->p_nr;
		printf("Timer of process %d set and deadline = %d\n",time_p->tmr_arg.ta_int,time_p->tmr_exp_time);
		set_timer(time_p,time_p->tmr_exp_time,time_p->tmr_func);
	}
	RTS_LOCK_UNSET(rp,RTS_SYS_LOCK);
	return (OK);
}

#endif
