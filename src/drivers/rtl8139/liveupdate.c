#include "rtl8139.h"

/* State management variables. */
EXTERN re_t re_table[RE_PORT_NR];

/* Custom states definition. */
#define RL_STATE_READ_PROTOCOL_FREE     (SEF_LU_STATE_CUSTOM_BASE + 0)
#define RL_STATE_WRITE_PROTOCOL_FREE    (SEF_LU_STATE_CUSTOM_BASE + 1)
#define RL_STATE_IS_CUSTOM(s) \
    ((s) >= RL_STATE_READ_PROTOCOL_FREE && (s) <= RL_STATE_WRITE_PROTOCOL_FREE)

/* State management helpers. */
PRIVATE int is_reading;
PRIVATE int is_writing;
PRIVATE void load_state_info(void)
{
  int i, found_processing;
  re_t *rep;

  /* Check if we are reading or writing. */
  is_reading = FALSE;
  is_writing = FALSE;
  found_processing = FALSE;
  for (i= 0; i<RE_PORT_NR && !found_processing; i++) {
      rep = &re_table[i];

      if (rep->re_flags & REF_READING) {
          is_reading = TRUE;
      }

      if (rep->re_flags & REF_SEND_AVAIL) {
          is_writing = TRUE;
      }

      found_processing = (is_reading && is_writing);
  }
}

/*===========================================================================*
 *       			 sef_cb_lu_prepare 	 	             *
 *===========================================================================*/
PUBLIC void sef_cb_lu_prepare(int state)
{
  int is_ready;

  /* Load state information. */
  load_state_info();

  /* Check if we are ready for the target state. */
  is_ready = FALSE;
  switch(state) {
      /* Standard states. */
      case SEF_LU_STATE_REQUEST_FREE:
          is_ready = TRUE;
      break;

      case SEF_LU_STATE_PROTOCOL_FREE:
          is_ready = (!is_reading && !is_writing);
      break;

      /* Custom states. */
      case RL_STATE_READ_PROTOCOL_FREE:
          is_ready = (!is_reading);
      break;

      case RL_STATE_WRITE_PROTOCOL_FREE:
          is_ready = (!is_writing);
      break;
  }

  /* Tell SEF if we are ready. */
  if(is_ready) {
      sef_lu_ready(OK);
  }
}

/*===========================================================================*
 *      		  sef_cb_lu_state_isvalid		             *
 *===========================================================================*/
PUBLIC int sef_cb_lu_state_isvalid(int state)
{
  return SEF_LU_STATE_IS_STANDARD(state) || RL_STATE_IS_CUSTOM(state);
}

/*===========================================================================*
 *      		   sef_cb_lu_state_dump         	             *
 *===========================================================================*/
PUBLIC void sef_cb_lu_state_dump(int state)
{
  /* Load state information. */
  load_state_info();

  sef_lu_dprint("rtl8139: live update state = %d\n", state);
  sef_lu_dprint("rtl8139: is_reading = %d\n", is_reading);
  sef_lu_dprint("rtl8139: is_writing = %d\n", is_writing);

  sef_lu_dprint("rtl8139: SEF_LU_STATE_WORK_FREE(%d) reached = %d\n", 
      SEF_LU_STATE_WORK_FREE, TRUE);
  sef_lu_dprint("rtl8139: SEF_LU_STATE_REQUEST_FREE(%d) reached = %d\n", 
      SEF_LU_STATE_REQUEST_FREE, TRUE);
  sef_lu_dprint("rtl8139: SEF_LU_STATE_PROTOCOL_FREE(%d) reached = %d\n", 
      SEF_LU_STATE_PROTOCOL_FREE, (!is_reading && !is_writing));
  sef_lu_dprint("rtl8139: RL_STATE_READ_PROTOCOL_FREE(%d) reached = %d\n", 
      RL_STATE_READ_PROTOCOL_FREE, (!is_reading));
  sef_lu_dprint("rtl8139: RL_STATE_WRITE_PROTOCOL_FREE(%d) reached = %d\n", 
      RL_STATE_WRITE_PROTOCOL_FREE, (!is_writing));
}

