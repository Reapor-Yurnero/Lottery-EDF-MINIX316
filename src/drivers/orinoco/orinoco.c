/*
 * orinoco.c
 *
 * This file contains a wireless device driver for Prism based wireless
 * cards. 
 *
 * Created by Stevens Le Blond <slblond@few.vu.nl> 
 *        and Michael Valkering <mjvalker@cs.vu.nl>
 *
 * * The valid messages and their parameters are:
 *
 *   m_type	  DL_PORT    DL_PROC   DL_COUNT   DL_MODE   DL_ADDR   DL_GRANT
 * |------------+----------+---------+----------+---------+---------+---------|
 * | HARDINT	|          |         |          |         |         |	      |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_WRITE	| port nr  | proc nr | count    | mode    | address |	      |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_WRITEV	| port nr  | proc nr | count    | mode    | address |	      |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_WRITEV_S| port nr  | proc nr | count    | mode    |         |  grant  |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_READ	| port nr  | proc nr | count    |         | address |	      |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_READV	| port nr  | proc nr | count    |         | address |	      |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_READV_S	| port nr  | proc nr | count    |         |         |  grant  |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_CONF	| port nr  | proc nr |          | mode    | address |	      |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_GETSTAT	| port nr  | proc nr |          |         | address |	      |
 * |------------|----------|---------|----------|---------|---------|---------|
 * |DL_GETSTAT_S| port nr  | proc nr |          |         |         |  grant  |
 * |------------|----------|---------|----------|---------|---------|---------|
 * | DL_STOP	| port_nr  |         |          |         |         |         |
 * |------------|----------|---------|----------|---------|---------|---------|
 *
 * The messages sent are:
 *
 *   m_type	  DL_PORT    DL_PROC   DL_COUNT   DL_STAT   DL_CLCK
 * |------------|----------|---------|----------|---------|---------|
 * |DL_TASK_REPL| port nr  | proc nr | rd-count | err|stat| clock   |
 * |------------|----------|---------|----------|---------|---------|
 *
 *   m_type	  m3_i1     m3_i2       m3_ca1
 * |------------|---------|-----------|---------------|
 * |DL_CONF_REPL| port nr | last port | ethernet addr |
 * |------------|---------|-----------|---------------|
 *
 *   m_type	  DL_PORT    DL_STAT       
 * |------------|---------|-----------|
 * |DL_STAT_REPL| port nr |   err     |
 * |------------|---------|-----------|
 *
 */

#include 	"../drivers.h" 
#include	<string.h>
#include	<minix/syslib.h>
#include	<minix/type.h>
#include	<minix/sysutil.h>
#include	<timers.h>
#include	<ibm/pci.h>
#include 	<minix/ds.h>
#include	<minix/endpoint.h>
#include	"../../kernel/const.h"
#include	"../../kernel/config.h"
#include	"../../kernel/type.h"

#define		tmra_ut			timer_t
#define		tmra_inittimer(tp)	tmr_inittimer(tp)
#define		VERBOSE		1	/* display message during init */

PRIVATE struct pcitab {
	u16_t vid;
	u16_t did;
	int checkclass;
} pcitab[]=
{
	{ 0x1260, 0x3873, 0 },	
	{ 0x1186, 0x1300, 0 },	
	{ 0x0000, 0x0000, 0 }
};


static tmra_ut or_watchdog;

#include 	<stdio.h>
#include	<stdlib.h>
#include	<minix/com.h>
#include	<minix/portio.h>
#include	<net/hton.h>
#include	<net/gen/ether.h>
#include	<net/gen/eth_io.h>
#include	<sys/vm_i386.h>
#include	<sys/types.h>
#include 	<unistd.h>
#include	<errno.h>

#include	"assert.h"
#include	"hermes.h"
#include	"hermes_rid.h"
#include	"orinoco.h"

#define 	ERR -1

#define		debug 0

#define		OR_M_ENABLED 1
#define		OR_M_DISABLED 0
#define		OR_F_EMPTY 0
#define		OR_F_MULTI 1
#define		OR_F_BROAD (1<<1)
#define		OR_F_ENABLED (1<<2)
#define		OR_F_PROMISC (1<<3)
#define		OR_F_READING (1<<4)
#define		OR_F_SEND_AVAIL (1<<5)
#define		OR_F_PACK_SENT (1<<6)
#define		OR_F_PACK_RECV (1<<7)
#define 	ORINOCO_INTEN ( HERMES_EV_RX | HERMES_EV_ALLOC |\
					HERMES_EV_WTERR | HERMES_EV_TXEXC|\
					HERMES_EV_INFO | HERMES_EV_INFDROP|\
					HERMES_EV_TX)

#define		NO_FID (-1)
#define		ETH_ALEN 6
#define		USER_BAP 0
#define 	IRQ_BAP 1
#define		ETH_HLEN		14

static int or_nr_task = ANY;
static t_or or_table[OR_PORT_NR];

struct ethhdr {
	u8_t h_dest[ETH_ALEN];
	u8_t h_src[ETH_ALEN];
	u16_t h_proto;
};

struct header_struct {
	/* 802.3 */
	u8_t dest[ETH_ALEN];
	u8_t src[ETH_ALEN];
	u16_t len;
	/* 802.2 */
	u8_t dsap;
	u8_t ssap;
	u8_t ctrl;
	/* SNAP */
	u8_t oui[3];
	u16_t ethertype;
};

#define			RUP_EVEN(x)	(((x) + 1) & (~1))

u8_t encaps_hdr[] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
#define	ENCAPS_OVERHEAD	(sizeof (encaps_hdr) + 2)

/********************************************************************
 *              Data tables                                         *
 ********************************************************************/

/* The frequency of each channel in MHz */
const long channel_frequency[] = {
	2412, 2417, 2422, 2427, 2432, 2437, 2442,
	2447, 2452, 2457, 2462, 2467, 2472, 2484
};

#define NUM_CHANNELS (sizeof(channel_frequency) / sizeof(channel_frequency[0]))

/* This tables gives the actual meanings of the bitrate IDs returned by the 
 * firmware. Not used yet */
struct {
	int bitrate;		/* in 100s of kilobits */
	int automatic;
	u16_t txratectrl;
} bitrate_table[] =
{
	{110, 1, 15},		/* Entry 0 is the default */
	{10, 0, 1},
	{10, 1, 1},
	{20, 0, 2},
	{20, 1, 3},
	{55, 0, 4},
	{55, 1, 7},
	{110, 0, 8},};

#define BITRATE_TABLE_SIZE (sizeof(bitrate_table) / sizeof(bitrate_table[0]))


_PROTOTYPE (static void or_writev, (message * mp, int from_int, int vectored));
_PROTOTYPE (static void or_readv, (message * mp, int from_int, int vectored));
_PROTOTYPE (static void or_writev_s, (message * mp, int from_int));
_PROTOTYPE (static void or_readv_s, (message * mp, int from_int));
_PROTOTYPE (static void reply, (t_or * orp, int err, int may_block));
_PROTOTYPE (static int  or_probe, (t_or *));
_PROTOTYPE (static void or_ev_info, (t_or *));
_PROTOTYPE (static void or_init, (message *));
_PROTOTYPE (static void or_pci_conf, (void));
_PROTOTYPE (static void or_init_struct, (t_or *));
_PROTOTYPE (static void map_hw_buffer, (t_or *));
_PROTOTYPE (static void or_init_hw, (t_or *));
_PROTOTYPE (static void or_check_ints, (t_or *));
_PROTOTYPE (static void or_writerids, (hermes_t *, t_or *));
_PROTOTYPE (static void or_readrids, (hermes_t *, t_or *));
_PROTOTYPE (static void or_rec_mode, (t_or *));
_PROTOTYPE (static void mess_reply, (message *, message *));
_PROTOTYPE (static u32_t or_get_bar, (int devind, t_or * orp));
_PROTOTYPE (static void or_getstat, (message * mp));
_PROTOTYPE (static void or_getstat_s, (message * mp));
_PROTOTYPE (static void print_linkstatus, (t_or * orp, u16_t status));
_PROTOTYPE (static int  or_get_recvd_packet, (t_or *orp, u16_t rxfid, 
					u8_t *databuf));
_PROTOTYPE (static void orinoco_stop, (void));
_PROTOTYPE (static void or_reset, (void));
_PROTOTYPE (static void or_watchdog_f, (timer_t *tp) );
_PROTOTYPE (static void setup_wepkey, (t_or *orp, char *wepkey0) );
_PROTOTYPE (static void or_getstat, (message *m));
_PROTOTYPE (static int  do_hard_int, (void));
_PROTOTYPE (static void check_int_events, (void));
_PROTOTYPE (static void or_getname, (message *m));
_PROTOTYPE (static int or_handler, (t_or *orp));
_PROTOTYPE (static void or_dump, (message *m));

/* The message used in the main loop is made global, so that rl_watchdog_f()
 * can change its message type to fake an interrupt message.
 */
PRIVATE message m;
PRIVATE int int_event_check;		/* set to TRUE if events arrived */

u32_t system_hz;

static char *progname;
extern int errno;

/* SEF functions and variables. */
FORWARD _PROTOTYPE( void sef_local_startup, (void) );
FORWARD _PROTOTYPE( int sef_cb_init_fresh, (int type, sef_init_info_t *info) );
EXTERN int env_argc;
EXTERN char **env_argv;

/*****************************************************************************
 *            main                                                           *
 *                                                                           *
 *                                                                           *
 * The main function of the driver, receiving and processing messages        *
 *****************************************************************************/
int main(int argc, char *argv[]) {
	int r;

	/* SEF local startup. */
	env_setargs(argc, argv);
	sef_local_startup();

	while (TRUE) {
		if ((r = sef_receive (ANY, &m)) != OK)
			panic(__FILE__, "orinoco: sef_receive failed", NO_NUM);

		if (is_notify(m.m_type)) {
			switch (_ENDPOINT_P(m.m_source)) {
				case CLOCK:
					or_watchdog_f(NULL);     
					break;		 
				case HARDWARE:
					do_hard_int();
					if (int_event_check)
						check_int_events();
					break ;
				case TTY_PROC_NR: 
					or_dump(&m);	
					break;
				case PM_PROC_NR:
				{
					sigset_t set;

					if (getsigset(&set) != 0) break;

					if (sigismember(&set, SIGTERM))
						orinoco_stop();

					break;
				}
				default:
					panic(__FILE__,
						"orinoco: illegal notify from:",
						m.m_source);
			}

			/* done, get new message */
			continue;
		}

		switch (m.m_type) {
		case DL_WRITEV:
			or_writev (&m, FALSE, TRUE);
			break;
		case DL_WRITEV_S:
			or_writev_s (&m, FALSE);
			break;
		case DL_WRITE:
			or_writev (&m, FALSE, FALSE);
			break;
		case DL_READ:
			or_readv (&m, FALSE, FALSE);
			break;
		case DL_READV:
			or_readv (&m, FALSE, TRUE);
			break;
		case DL_READV_S:
			or_readv_s (&m, FALSE);
			break;
		case DL_CONF:
			or_init (&m);
			break;
		case DL_GETSTAT:
			or_getstat (&m);
			break;
		case DL_GETSTAT_S:
			or_getstat_s (&m);
			break;
		case DL_GETNAME: 
			or_getname(&m);
			break;
		default:
			panic(__FILE__,"orinoco: illegal message:", m.m_type);
		}
	}
}

/*===========================================================================*
 *			       sef_local_startup			     *
 *===========================================================================*/
PRIVATE void sef_local_startup()
{
  /* Register init callbacks. */
  sef_setcb_init_fresh(sef_cb_init_fresh);
  sef_setcb_init_restart(sef_cb_init_fresh);

  /* No live update support for now. */

  /* Let SEF perform startup. */
  sef_startup();
}

/*===========================================================================*
 *		            sef_cb_init_fresh                                *
 *===========================================================================*/
PRIVATE int sef_cb_init_fresh(int type, sef_init_info_t *info)
{
/* Initialize the orinoco driver. */
	int fkeys, sfkeys, r;
	u32_t inet_proc_nr;

	system_hz = sys_hz();

	(progname=strrchr(env_argv[0],'/')) ? progname++
		: (progname=env_argv[0]);

	/* Observe some function key for debug dumps. */
	fkeys = sfkeys = 0; bit_set(sfkeys, 11);
	if ((r=fkey_map(&fkeys, &sfkeys)) != OK) 
	    printf("Warning: orinoco couldn't observe F-key(s): %d\n",r);

	/* Try to notify INET that we are present (again). If INET cannot
	 * be found, assume this is the first time we started and INET is
	 * not yet alive. */
	r = ds_retrieve_label_num("inet", &inet_proc_nr);
	if (r == OK) 
		notify(inet_proc_nr);
	else if (r != ESRCH)
		printf("orinoco: ds_retrieve_label_num failed for 'inet': %d\n", r);

	return(OK);
}

/*****************************************************************************
 *                    check_int_events                                       *
 *                                                                           *
 * If a hard interrupt message came in, call the or_check_ints for the right *
 * card                                                                      *
 *****************************************************************************/
static void check_int_events(void) {
	int i;
	t_or *orp;

	/* the interrupt message doesn't contain information about the port, try
	 * to find it */
	for (orp = or_table;
		 orp < or_table + OR_PORT_NR; orp++) {
		if (orp->or_mode != OR_M_ENABLED)
			continue;
		if (!orp->or_got_int)
			continue;
		orp->or_got_int = 0;
		assert (orp->or_flags & OR_F_ENABLED);
		or_check_ints (orp);
	}

}

/****************************************************************************
 *                    or_getname                                            *
 *                                                                          *
 * Gets the drivers name, orinoco                                           *
 ****************************************************************************/
static void or_getname(message *mp) {
	int r;
	
	strncpy(mp->DL_NAME, progname, sizeof(mp->DL_NAME));
	mp->DL_NAME[sizeof(mp->DL_NAME) - 1] = '\0';
	mp->m_type = DL_NAME_REPLY;

	r = send(mp->m_source, mp);
	if(r != OK) {
		panic(__FILE__, "or_getname: send failed", r);
	}
}

/*****************************************************************************
 *                do_hard_int                                                *
 *                                                                           *
 * Process the interrupts which the card generated                           *
 *****************************************************************************/
static int do_hard_int(void) {
	u16_t evstat;
	hermes_t *hw;
	int i,s;
	t_or *orp;

	for (i=0; i < OR_PORT_NR; i ++) {
		/* Run interrupt handler at driver level. */
		or_handler( &or_table[i]);

		/* Reenable interrupts for this hook. */
		if ((s=sys_irqenable(&or_table[i].or_hook_id)) != OK) {
			printf("orinoco: error, couldn't enable");
			printf(" interrupts: %d\n", s);
		}
	}
}



/*****************************************************************************
 *                orinoco_stop                                               *
 *                                                                           *
 * Stops the card. The signal to the card itself is not implemented yet.     *
 *****************************************************************************/
static void orinoco_stop () {
	int i;
	t_or *orp;

	for (i= 0, orp= &or_table[0]; i<OR_PORT_NR; i++, orp++) {
		if (orp->or_mode != OR_M_ENABLED)
			continue;
		/* TODO: send a signal to the card to shut it down */
	}
	exit(0);
}

/*****************************************************************************
 *                or_reset                                                   *
 *                                                                           *
 * Sometime the card gets screwed, behaving erratically. Solution: reset the *
 * card. This is actually largely redoing the initialization                 *
 *****************************************************************************/
static void or_reset() {
	static clock_t last_reset, now;	
	t_or *orp;
	int i, j, r;
	u16_t irqmask;

	if (OK != (r = getuptime(&now)))
		panic(__FILE__, "orinoco: getuptime() failed:", r);

	if(now - last_reset < system_hz * 10) {
		printf("Resetting card too often. Going to reset driver\n");
		exit(1);
	}
	
	for (i = 0, orp = or_table; orp < or_table + OR_PORT_NR; i++, orp++) {
		if(orp->or_mode == OR_M_DISABLED) 
			printf("orinoco port %d is disabled\n", i);
		
		if(orp->or_mode != OR_M_ENABLED) {
			continue;
		}

		orp->or_need_reset = 0;
		or_init_hw(orp);

		orp->rx_last = orp->rx_first = 0;
		for(j = 0; j < NR_RX_BUFS; j++) {
			orp->rx_length[0] = 0;
		}

		if(orp->or_flags & OR_F_SEND_AVAIL) {
			orp->or_tx.ret_busy = FALSE;
		 	orp->or_send_int = TRUE;
		}
	}

	last_reset = now;

}

/*****************************************************************************
 *                or_dump                                                    *
 *                                                                           *
 * Dump interesting information about the card on F-key pressed.             *
 * Not implemented yet                                                       *
 *****************************************************************************/
static void or_dump (message *m) {
	t_or *orp;
	int i, err;
	u16_t evstat =0, d;

	for (i = 0, orp = or_table; orp < or_table + OR_PORT_NR; i++, orp++) {
		if(orp->or_mode == OR_M_DISABLED) {
			printf("%s is disabled\n", orp->or_name);
		}
		
		if(orp->or_mode != OR_M_ENABLED)
			continue;

		m->m_type = FKEY_CONTROL;
		m->FKEY_REQUEST = FKEY_EVENTS;
		if(OK!=(sendrec(TTY_PROC_NR,m)) )
			printf("Contacting the TTY failed\n");
		
		if(bit_isset(m->FKEY_SFKEYS, 11)) {
			print_linkstatus(orp, orp->last_linkstatus);
		}
	}
}

/*****************************************************************************
 *                or_init                                                    *
 *                                                                           *
 * The main initialization function, called when a DL_INIT message comes in. *
 *****************************************************************************/
static void or_init (message * mp) {
	int port, err, i;
	t_or *orp;
	message reply;
	static int first_time = 1;
	hermes_t *hw;
	clock_t t0,t1;

	if (first_time) {
		first_time = 0;
		or_pci_conf ();	/* Configure PCI devices. */
	
		tmra_inittimer(&or_watchdog);
		/* Use a synchronous alarm instead of a watchdog timer. */
		sys_setalarm(system_hz, 0);
	}	

	port = mp->DL_PORT;
	if (port < 0 || port >= OR_PORT_NR)	{
		/* illegal port in message */
		reply.m_type = DL_CONF_REPLY;
		reply.m3_i1 = ENXIO;
		mess_reply (mp, &reply);
		return;
	}

	/* the port resolves to the main orinoco structure */
	orp = &or_table[port];
	/* resolving to the main hardware structure */
	hw = &(orp->hw);

	if (orp->or_mode == OR_M_DISABLED) {
		/* Initialize the orp structure */
		or_init_struct (orp);
		if (orp->or_mode == OR_M_DISABLED) {
			reply.m_type = DL_CONF_REPLY;
			reply.m3_i1 = ENXIO;
			mess_reply (mp, &reply);
			return;
		}
		if (orp->or_mode == OR_M_ENABLED) {
			/* initialize card, hardware/firmware */
			orp->or_flags |= OR_F_ENABLED;
			or_init_hw (orp);
		}
	}

	assert (orp->or_mode == OR_M_ENABLED);
	assert (orp->or_flags & OR_F_ENABLED);

	/* Not supported by the driver yet, but set a couple of options:
	 * multicasting, promiscuity, broadcasting, depending on the users 
         * needs */
	orp->or_flags &= ~(OR_F_PROMISC | OR_F_MULTI | OR_F_BROAD);
	if (mp->DL_MODE & DL_PROMISC_REQ)
		orp->or_flags |= OR_F_PROMISC;
	if (mp->DL_MODE & DL_MULTI_REQ)
		orp->or_flags |= OR_F_MULTI;
	if (mp->DL_MODE & DL_BROAD_REQ)
		orp->or_flags |= OR_F_BROAD;

	orp->or_client = mp->m_source;
	or_rec_mode (orp);

	/* reply the caller that the configuration succeeded */
	reply.m_type = DL_CONF_REPLY;
	reply.m3_i1 = mp->DL_PORT;
	reply.m3_i2 = OR_PORT_NR;
	*(ether_addr_t *) reply.m3_ca1 = orp->or_address;
	mess_reply (mp, &reply);
}

/*****************************************************************************
 *                or_pci_conf                                                *
 *                                                                           *
 * Configure the pci related issues of the card, e.g. finding out where the  *
 * card is in the pci configuration, it's assigned irq, etc. This can be     *
 * done if the boot monitor is provided with information, or the pci bus     *
 * can be searched (at the end: or_probe function)                           *
 *****************************************************************************/
static void or_pci_conf () {
	long v;
	t_or *orp;
	int i, h;
	static char envfmt[] = "*:d.d.d";
	static char envvar[] = OR_ENVVAR "#";
	static char val[128];

	/* extract information from the boot monitor about the pci 
	 * configuration if provided */
	for (i = 0, orp = or_table; i < OR_PORT_NR; i++, orp++)	{
		strncpy (orp->or_name, OR_NAME, sizeof(OR_NAME));
		orp->or_name[sizeof(OR_NAME) - 2] = i + '0';
		orp->or_seen = FALSE;
		/* whats this envvar; whats the definition;*/
		/* i guess this whole loop could be removed*/
		envvar[sizeof (OR_ENVVAR) - 1] = '0' + i;
		if (0 == env_get_param(envvar, val, sizeof(val)) && 
			! env_prefix(envvar, "pci")) {
			env_panic(envvar);
		}
		v = 0;
		(void) env_parse (envvar, envfmt, 1, &v, 0, 255);
		orp->or_pci_bus = v;
		v = 0;
		(void) env_parse (envvar, envfmt, 2, &v, 0, 255);
		orp->or_pci_dev = v;
		v = 0;
		(void) env_parse (envvar, envfmt, 3, &v, 0, 255);
		orp->or_pci_func = v;
	}

	/* Initialize the pci bus, bridges and cards, if not yet done */
	pci_init ();
	
	/* Try to find out where the card(s) are in the pci bus */
	for (h = 1; h >= 0; h--)
		for (i = 0, orp = or_table; i < OR_PORT_NR; i++, orp++)	{
			if (((orp->or_pci_bus | orp->or_pci_dev |
			      orp->or_pci_func) != 0) != h)	{
				continue;
			}
			if (or_probe (orp))
				orp->or_seen = TRUE;
		}
}

/*****************************************************************************
 *                or_probe                                                   *
 *                                                                           *
 * Try to find the card based on information provided by pci and get irq and *
 * bar                                                                       *
 *****************************************************************************/
static int or_probe (t_or * orp) {
	u8_t ilr;
	u32_t bar, reg, cpuspace_bar;
	char *dname;
	u16_t vid, did;
	int i, r, devind, just_one;

	if ((orp->or_pci_bus | orp->or_pci_dev | orp->or_pci_func) != 0) {
		/* The monitor has provided us with clues about where the 
                 * device is. Try to find it at that place */
		r = pci_find_dev (orp->or_pci_bus, orp->or_pci_dev,
				  orp->or_pci_func, &devind);
		if (r == 0)	{
			printf ("%s: no PCI found at %d.%d.%d\n",
				orp->or_name, orp->or_pci_bus,
				orp->or_pci_dev, orp->or_pci_func);
			return (0);
		}
		/* get the information about the card, vendor id and device
		 * id */
		pci_ids (devind, &vid, &did);
		just_one = TRUE;
	} else {
		/* no clue where the card is. Start looking from the
		 * beginning */
		r = pci_first_dev (&devind, &vid, &did);
		if (r == 0)
			return (0);
		just_one = FALSE;
	}

	while (TRUE) {
		/* loop through the pcitab to find a maching entry. The match
		 * being between one of the values in pcitab and the 
		 * information provided by the pci bus */
		for (i = 0; pcitab[i].vid != 0; i++) {
			if (pcitab[i].vid != vid)
				continue;
			if (pcitab[i].did != did)
				continue;
			if (pcitab[i].checkclass) {
                           panic(__FILE__, "or_probe:class check not implmnted", 
                                 NO_NUM);
			}
			/* we have found the card in the pci bus */
			break;
		}
		if (pcitab[i].vid != 0)
			break;

		if (just_one) {
			printf ("%s: wrong PCI device", orp->or_name);
			printf (" (%04x/%04x) found at %d.%d.%d\n", vid, did,
				orp->or_pci_bus, orp->or_pci_dev,
				orp->or_pci_func);
			return (0);
		}

		/* if the pci device which was under consideration was not
		 * of the desired brand or type, get the next device */
		r = pci_next_dev (&devind, &vid, &did);
		if (!r)
			return (0);
	}

	/* Get the name as advertised by pci */
	dname = pci_dev_name (vid, did);
	if (!dname)
		dname = "unknown device";
	printf ("%s: %s (%04x/%04x) at %s\n",
		orp->or_name, dname, vid, did, pci_slot_name (devind));

	pci_reserve (devind);

	orp->devind = devind;	
	/* Get the irq */
	ilr = pci_attr_r8 (devind, PCI_ILR);
	orp->or_irq = ilr;

	/* Get the base address */
	bar = or_get_bar (devind, orp);
	orp->or_base_port = bar;

	map_hw_buffer(orp);
	return TRUE;
}

/*****************************************************************************
 *                map_hw_buffer                                              *
 *                                                                           *
 * Map the memory mapped registers into user space memory                    *
 *****************************************************************************/
static void map_hw_buffer(t_or *orp) {
	int r;
	size_t o, size, reg_size;
	char *buf, *abuf;	
	hermes_t *hw = &(orp->hw);	

	/* This way, the buffer will be at least I386_PAGE_SIZE big: see 
	 * calculation with the offset */
	size = 2 * I386_PAGE_SIZE;	

	buf = (char *)malloc(size);
	if(buf == NULL) 
		panic(__FILE__, "map_hw_buffer: cannot malloc size:", size);

	/* Let the mapped memory by I386_PAGE_SIZE aligned */
	o = I386_PAGE_SIZE - ((vir_bytes)buf % I386_PAGE_SIZE);
	abuf = buf + o;

#if 0
	r = sys_vm_map(SELF, 1, (vir_bytes)abuf, 
			1 * I386_PAGE_SIZE, (phys_bytes)orp->or_base_port);
#else
	r = ENOSYS;
#endif

	if(r!=OK) 
		panic(__FILE__, "map_hw_buffer: sys_vm_map failed:", r);


	hw->locmem = abuf;
}



/*****************************************************************************
 *                or_get_bar                                                 *
 *                                                                           *
 * Get the base address from pci (from Base Address Register) and find out   * 
 * whether the card is memory mapped or in I/O space. Currently, only        *
 * memmory mapped is supported.                                              *
 *****************************************************************************/
static u32_t or_get_bar (int devind, t_or * orp) {

	u32_t bar, desired_bar;
	int is_iospace, i;
	u16_t check, check2;
	hermes_t *hw = &(orp->hw);

	/* bit 1 off the PCI_BAR register indicates whether the cards registers
	 * are mapped in io-space or shared memory */
	is_iospace = pci_attr_r32 (devind, PCI_BAR) & 1;

	if (is_iospace)	{
		/* read where the base address is in I/O space */
		bar = pci_attr_r32 (devind, PCI_BAR) & 0xffffffe0;

		if ((bar & 0x3ff) >= 0x100 - 32 || bar < 0x400)
			panic(__FILE__,"base address isn't properly configured",
                              NO_NUM);

		/* In I/O space registers are 2 bytes wide, without any spacing
		 * in between */
		hermes_struct_init (hw, bar, is_iospace,
				    HERMES_16BIT_REGSPACING);

		if (debug) {
			printf ("%s: using I/O space address 0x%lx, IRQ %d\n",
				orp->or_name, bar, orp->or_irq);
		}

		panic(__FILE__, "Not implemente yet", NO_NUM);
		/* Although we are able to find the desired bar and irq for an 
		 * I/O spaced card, we haven't implemented the right register 
 		 * accessing functions. This wouldn't be difficult, but we were
		 * not able to test them. Therefore, give an alert here */

		return bar;
	} else {
		/* read where the base address is in shared memory */
		bar = pci_attr_r32 (devind, PCI_BAR) & 0xfffffff0;
		/* maybe some checking whether the address is legal... */

		/* Memory mapped registers are 2 bytes wide, aligned on 4 
		 * bytes */
		hermes_struct_init (hw, bar, is_iospace,
				    HERMES_32BIT_REGSPACING);

		if (debug){
			printf ("%s: using shared memory address",
				orp->or_name);
			printf (" 0x%lx, IRQ %d\n", bar, orp->or_irq);
		}

		return bar;

	}
}

/*****************************************************************************
 *                or_init_struct                                             *
 *                                                                           *
 * Set the orinoco structure to default values                               *
 *****************************************************************************/
static void or_init_struct (t_or * orp) {
	int i = 0;
	static eth_stat_t empty_stat = { 0, 0, 0, 0, 0, 0 };

	orp->or_mode = OR_M_DISABLED;

	if (orp->or_seen)
		orp->or_mode = OR_M_ENABLED;

	if (orp->or_mode != OR_M_ENABLED)
		return;

	orp->or_got_int = 0;
	orp->or_link_up = -1;
	orp->or_send_int = 0;
	orp->or_clear_rx = 0;
	orp->or_tx_alive = 0;
	orp->or_need_reset = 0;

	orp->or_read_s = 0;
	orp->or_tx_head = 0;
	orp->or_tx_tail = 0;
	orp->connected = 0;
 	
	orp->or_tx.ret_busy = FALSE;
	orp->or_tx.or_txfid = NO_FID;

	for(i = 0; i < NR_RX_BUFS; i++) {
		orp->rxfid[i] = NO_FID;
		orp->rx_length[i] = 0;
	}
	orp->rx_current = 0;
	orp->rx_first = 0;
	orp->rx_last = 0;
	
	orp->or_stat = empty_stat;
	orp->or_flags = OR_F_EMPTY;

	/* Keep an administration in the driver whether the internal
	   buffer is in use. That's what ret_busy is for */
	orp->or_tx.ret_busy = FALSE;

	orp->or_nicbuf_size = IEEE802_11_FRAME_LEN + ETH_HLEN;

}

/*****************************************************************************
 *                or_init_hw                                                 *
 *                                                                           *
 * Initialize hardware and prepare for intercepting the interrupts. At the   *
 * end, the card is up and running                                           *
 *****************************************************************************/
static void or_init_hw (t_or * orp) {
	int i, err, s;
	hermes_t *hw = &(orp->hw);
	static int first_time = TRUE;

	/* first step in starting the card */
	if (hermes_cor_reset(hw) != 0) {
		printf ("%s: Failed to start the card\n", orp->or_name);
	}

	/* here begins the real things, yeah! ;) */
	if (err = hermes_init (hw))	{
		printf ("error value of hermes_init(): %d\n", err);
	}

	/* Get the MAC address (which is a data item in the card)*/
	or_readrids (hw, orp);

	/* Write a few rids to the card, e.g. WEP key*/
	or_writerids (hw, orp);

	if (debug) {
		printf ("%s: Ethernet address ", orp->or_name);
		for (i = 0; i < 6; i++)	{
			printf ("%x%c", orp->or_address.ea_addr[i],
				i < 5 ? ':' : '\n');
		}
	}

	/* Prepare internal TX buffer in the card */
	err = hermes_allocate (hw,
				   orp->or_nicbuf_size,
				   &(orp->or_tx.or_txfid));

	if (err)
		printf ("%s:Error %d allocating Tx buffer\n",
			orp->or_name, err);

	/* Establish event handle */
	if(first_time) {
		orp->or_hook_id = orp->or_irq;	
		if ((s=sys_irqsetpolicy(orp->or_irq, 0, 
			&orp->or_hook_id)) != OK)
			printf("orinoco: couldn't set IRQ policy: %d\n", s);

		if ((s=sys_irqenable(&orp->or_hook_id)) != OK)
			printf("orinoco: couldn't enable interrupts: %d\n", s);
		first_time = FALSE;
	}

	/* Tell the card which events should raise an interrupt to the OS */
	hermes_set_irqmask (hw, ORINOCO_INTEN);

	/* Enable operation */
	err = hermes_docmd_wait (hw, HERMES_CMD_ENABLE, 0, NULL);
	if (err) {
		printf ("%s: Error %d enabling MAC port\n", orp->or_name, err);
	}
}


/*****************************************************************************
 *                or_readrids                                                *
 *                                                                           *
 * Read some default rids from the card. A rid (resource identifier)         *
 * is a data item in the firmware, some configuration variable.              *
 * In our case, we are mostly interested in the MAC address for now          *
 *****************************************************************************/

static void or_readrids (hermes_t * hw, t_or * orp) {
	int err, len, i;
	struct hermes_idstring nickbuf;
	u16_t reclen, d;

	/* Read the MAC address */
	err = hermes_read_ltv (hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
			       ETH_ALEN, NULL, &orp->or_address);
	if (err) {
		printf ("%s: failed to read MAC address!\n", orp->or_name);
		return;
	}

}

/*****************************************************************************
 *                or_writerids                                               *
 *                                                                           *
 * Write some default rids to the card. A rid (resource identifier)          *
 * is a data item in the firmware, some configuration variable, e.g. WEP key *
 *****************************************************************************/
static void or_writerids (hermes_t * hw, t_or * orp) {
	int err;
	struct hermes_idstring idbuf;
	u16_t port_type, max_data_len, reclen;
	static char essid[IW_ESSID_MAX_SIZE + 1];
	static char wepkey0[LARGE_KEY_LENGTH + 1];

	/* Set the MAC port */
	port_type = 1;
	err = hermes_write_wordrec (hw, USER_BAP, HERMES_RID_CNFPORTTYPE,
				    port_type);
	if (err) {
		printf ("%s: Error %d setting port type\n", orp->or_name, err);
		return;
	}

	if (OK != env_get_param("essid", essid, sizeof(essid))) {
		essid[0] = 0;
	}

	if(strlen(essid) == 0) {
		printf("%s: no essid provided in boot monitor!\n",
			orp->or_name);
		printf("Hope you'll connect to the right network... \n");
	}

	/* Set the desired ESSID */
	idbuf.len = strlen (essid);
	memcpy (&idbuf.val, essid, sizeof (idbuf.val));

	err = hermes_write_ltv (hw, USER_BAP, HERMES_RID_CNFDESIREDSSID,
				HERMES_BYTES_TO_RECLEN (strlen (essid) + 2),
                                &idbuf);
	if (err) {
		printf ("%s: Error %d setting DESIREDSSID\n", 
				orp->or_name, err);
		return;
	}

	if (OK != env_get_param("wep", wepkey0, sizeof(wepkey0))) {
		wepkey0[0] = 0;
	}

	switch(strlen(wepkey0)) {
		case 0:
			/* No key found in monitor, using no encryption */
		break;
		case LARGE_KEY_LENGTH:
			setup_wepkey(orp, wepkey0);
		break;
		default:
			printf("Invalid key provided. Has to be 13 chars\n");
		break;
	}
}

/*****************************************************************************
 *                setup_wepkey                                               *
 *                                                                           *
 * If a wepkey is provided in the boot monitor, set the necessary rids so    *
 * that the card will decrypt received data and encrypt data to send by      *
 * by default with this key.                                                 *
 * It appears that there is a severe bug in setting up WEP. If the driver    *
 * doesnt function properly, please turn WEP off.                            *
 *****************************************************************************/
static void setup_wepkey(t_or *orp, char *wepkey0) {
	int default_key = 0, err = 0;
	hermes_t *hw = &(orp->hw);

	err = hermes_write_wordrec (hw, USER_BAP,
					HERMES_RID_CNFWEPDEFAULTKEYID,
					default_key);
	if (err)
		printf ("%s: Error %d setting the default WEP-key entry\n",
				orp->or_name, err);	
	
	err = hermes_write_ltv (hw, USER_BAP, 
				HERMES_RID_CNFDEFAULTKEY0,
				HERMES_BYTES_TO_RECLEN(LARGE_KEY_LENGTH),
				wepkey0);
	if (err) 
		printf ("%s: Error %d setting the WEP-key0\n",
				orp->or_name, err);	
	
	err = hermes_write_wordrec (hw, USER_BAP, 
					HERMES_RID_CNFAUTHENTICATION,
					HERMES_AUTH_OPEN);
	if (err)
		printf ("%s: Error %d setting the authentication flag\n",
			orp->or_name, err);	

	err = hermes_write_wordrec (hw, USER_BAP, 
					HERMES_RID_CNFWEPFLAGS_INTERSIL,
					HERMES_WEP_PRIVACY_INVOKED);
	if (err)
		printf ("%s: Error %d setting the master wep setting flag\n",
			orp->or_name, err);	
	
}


/*****************************************************************************
 *                or_rec_mode                                                *
 *                                                                           *
 * Set the desired receive mode, e.g. promiscuous mode. Not implemented yet   *
 *****************************************************************************/
static void or_rec_mode (t_or * orp) {
	/* TODO */
}

/*****************************************************************************
 *                or_handler                                                 *
 *                                                                           *
 * The handler which is called when the card generated an interrupt. Events  *
 * like EV_INFO and EV_RX have to be handled before an acknowledgement for   *
 * the event is returned to the card. See also the documentation             *
 *****************************************************************************/
static int or_handler (t_or *orp) {
	int i, err, length, nr = 0;
	u16_t evstat, events, fid;
	hermes_t *hw;
	struct hermes_tx_descriptor desc;
	
	hw = &(orp->hw);
	
beginning:
	/* Retrieve which kind of event happened */
	evstat = hermes_read_reg (hw, HERMES_EVSTAT);
	events = evstat;

	/* There are plenty of events possible. The more interesting events
	   are actually implemented. Whether the following events actually
	   raise an interrupt depends on the value of ORINOCO_INTEN. For more
	   information about the events, see the specification in pdf */

	/* Occurs at each tick of the auxiliary time */
	if (events & HERMES_EV_TICK) {
		events &= ~HERMES_EV_TICK;
	}
	/* Occurs when a wait time-out error is detected */
	if (events & HERMES_EV_WTERR) {
		events &= ~HERMES_EV_WTERR;
	}

	/* Occurs when an info frame is dropped because there is not enough
	   buffer space available */
	if (events & HERMES_EV_INFDROP) {
		events &= ~(HERMES_EV_INFDROP);
	}
	
	/* This AP-only event will be asserted at the beacon interval prior to 
	   the DTIM interval */
	if (events & HERMES_EV_DTIM) {
		events &= ~(HERMES_EV_DTIM);
	}

 	/* Occurs when a command execution is completed */
	if (events & HERMES_EV_CMD) {
		events &= ~(HERMES_EV_CMD);
	}

	/* Occurs when the asynchronous transmission process is unsuccessfully
	   completed */
	if (events & HERMES_EV_TXEXC) {

		/* What buffer generated the event? Represented by an fid */
		fid = hermes_read_reg(hw, HERMES_TXCOMPLFID);
		if(fid == 0xFFFF) {
			/* Illegal fid found */
			printf("unexpected txexc_fid interrupted\n");
		}

		orp->or_tx.ret_busy = FALSE;

		if(orp->or_flags & OR_F_SEND_AVAIL)	{
		 	orp->or_send_int = TRUE;
			if (!orp->or_got_int){
				orp->or_got_int = TRUE;
				int_event_check = TRUE;
			}
		}

		/* To detect illegal fids */
		hermes_write_reg(hw, HERMES_TXCOMPLFID, 0xFFFF);
		events &= ~(HERMES_EV_TXEXC);
		/* We don't do anything else yet. 
		 * Could be used for statistics */
	}

	/* Occurs when the asynchronous transmission process is successfully
	   completed */
	if (events & HERMES_EV_TX) {
		events &= ~(HERMES_EV_TX);
		/* Which buffer was sent, represented by an fid */
		fid = hermes_read_reg (hw, HERMES_TXCOMPLFID);
		if(fid == 0xFFFF) {
			/* Illegal fid found */
			printf("unexpected tx_fid interrupted\n");
		}

		orp->or_tx.ret_busy = FALSE;

		if(orp->or_flags & OR_F_SEND_AVAIL)	{
		 	orp->or_send_int = TRUE;
			if (!orp->or_got_int){
				orp->or_got_int = TRUE;
				int_event_check = TRUE;
			}
		}

		/* To detect illegal fids */
		hermes_write_reg(hw, HERMES_TXCOMPLFID, 0xFFFF);
		/* We don't do anything else when such event happens */
	}

	/* Occurs when an info frame is available in the card */
	if (events & HERMES_EV_INFO) {
		events &= ~(HERMES_EV_INFO);
		/* Process the information, inside the handler (!) */
		or_ev_info(orp);
	}

	/* Occurs when a TX buffer is available again for usage */
	if (events & HERMES_EV_ALLOC) {
		/* Which frame is now marked as free? */
		fid = hermes_read_reg (hw, HERMES_ALLOCFID);
		if (fid == 0xFFFF){
			/* An illegal frame identifier is found. Ignore */
			printf("Allocate event on unexpected fid\n");
			return ;
		}

		/* To be able to detect illegal fids */
		hermes_write_reg(hw, HERMES_ALLOCFID, 0xFFFF);
		
		events &= ~(HERMES_EV_ALLOC);
	}


	/* Occurs when a frame is received by the asynchronous reception 
	 * process */

	if (events & HERMES_EV_RX) {
		orp->or_ev_rx = TRUE;
		events &= ~(HERMES_EV_RX);

		/* If the last buffer is still filled with data, then we don't 
		 * have any buffers available to store the data */
		if(orp->rx_length[orp->rx_last] != 0) {
			/* indeed, we are going to overwrite information
			 * in a buffer */
		}

		/* Which buffer is storing the data (represented by a fid) */
		orp->rxfid[orp->rx_last]
				 = hermes_read_reg (hw, HERMES_RXFID);

		/* Get the packet from the card and store it in 
		 * orp->rx_buf[orp->rx_last]. The length is returned by this 
		 * function */
		length = or_get_recvd_packet(orp, orp->rxfid[orp->rx_last],
						(orp->rx_buf[orp->rx_last]));

		if(length < 0) {
			/* Error happened. */
			printf("length < 0\n");
			goto next;
		} else {
			orp->rx_length[orp->rx_last] = length;
		}

		/* The next buffer will be used the next time, circularly */
		orp->rx_last++;
 		orp->rx_last %= NR_RX_BUFS;

		if (!orp->or_got_int){
			orp->or_got_int = TRUE;
		}
		int_event_check = TRUE;
	}
next:
	if (events)	{
		printf("Unknown event: 0x%x\n", events);
	}

	/* Acknowledge to the card that the events have been processed. After 
	 * this the card will assume we have processed any buffer which were in
	 * use for this event. */
	hermes_write_reg (hw, HERMES_EVACK, evstat);

	evstat = hermes_read_reg (hw, HERMES_EVSTAT);
	if(evstat != 0 && !(evstat & HERMES_EV_TICK)) {
		goto beginning;
	}

	return (1);
}


/*****************************************************************************
 *                or_watchdog_f                                              *
 *                                                                           *
 * Will be called regularly to see whether the driver has crashed. If that   *
 * condition is detected, reset the driver and card                          *
 *****************************************************************************/
static void or_watchdog_f(timer_t *tp) {
	int i;
	t_or *orp;
	
	/* Use a synchronous alarm instead of a watchdog timer. */
	sys_setalarm(system_hz, 0);

	for (i= 0, orp = &or_table[0]; i<OR_PORT_NR; i++, orp++) {
		if (orp->or_mode != OR_M_ENABLED)
			continue;

		if (!(orp->or_flags & OR_F_SEND_AVAIL))	{
			/* Assume that an idle system is alive */
			orp->or_tx_alive= TRUE;
			continue;
		}

		if (orp->connected == 0) {
			orp->or_tx_alive= TRUE;
			continue;
		}
		if (orp->or_tx_alive) {
			orp->or_tx_alive= FALSE;
			continue;
		}
		
		printf("or_watchdog_f: resetting port %d\n", i);
		
		orp->or_need_reset= TRUE;
		orp->or_got_int= TRUE;
		check_int_events();
	}
}

/*****************************************************************************
 *                mess_reply                                                 *
 *****************************************************************************/

static void mess_reply (message * req, message * reply_mess) {
	if (send (req->m_source, reply_mess) != 0)
		panic(__FILE__, "orinoco: unable to mess_reply", NO_NUM);

}

/*****************************************************************************
 *                or_writev                                                  *
 *                                                                           *
 * As far as we can see, this function is never called from 3.1.3. However,  *
 * it is still in rtl8139, so we'll keep it here as well. It's almost a copy *
 * of or_writev_s. We left out the comments. For an explanation, see         *
 * or_writev_s                                                               *
******************************************************************************/
static void or_writev (message * mp, int from_int, int vectored) {
	int port, or_client, count, size, err, data_len, data_off, tx_head;
	int o, j, n, i, s, p, cps ;
	struct ethhdr *eh;
	t_or *orp;
	clock_t timebefore, t0;	
	phys_bytes phys_user;
	hermes_t *hw;
	struct hermes_tx_descriptor desc;
	struct header_struct hdr;

	iovec_t *iovp;
	phys_bytes phys_databuf;
	u16_t txfid;
	static u8_t databuf[IEEE802_11_DATA_LEN + ETH_HLEN + 2 + 1];
	memset (databuf, 0, IEEE802_11_DATA_LEN + ETH_HLEN + 3);

	port = mp->DL_PORT;
	count = mp->DL_COUNT;
	if (port < 0 || port >= OR_PORT_NR)
		panic(__FILE__, "orinoco: illegal port", NO_NUM);
	
	or_client = mp->DL_PROC;
	orp = &or_table[port];
	orp->or_client = or_client;
	hw = &(orp->hw);

	if (from_int) {
		assert (orp->or_flags & OR_F_SEND_AVAIL);
		orp->or_flags &= ~OR_F_SEND_AVAIL;
		orp->or_send_int = FALSE;
		orp->or_tx_alive = TRUE;
	}

	if (orp->or_tx.ret_busy) {
		assert(!(orp->or_flags & OR_F_SEND_AVAIL));
		orp->or_flags |= OR_F_SEND_AVAIL;
		goto suspend_write;
	}

	assert (orp->or_mode == OR_M_ENABLED);
	assert (orp->or_flags & OR_F_ENABLED);

	if (vectored) {

		int iov_offset = 0;
		size = 0;
		o = 0;

		for (i = 0; i < count; i += IOVEC_NR,
			 iov_offset += IOVEC_NR * sizeof (orp->or_iovec[0])) {

			n = IOVEC_NR;
			if (i + n > count)
				n = count - i;
			cps = sys_vircopy(or_client, D, 
				((vir_bytes) mp->DL_ADDR) + iov_offset,
				SELF, D, (vir_bytes) orp->or_iovec,
				n * sizeof(orp->or_iovec[0]));
			if (cps != OK) printf("sys_vircopy failed: %d\n", cps);

			for (j = 0, iovp = orp->or_iovec; j < n; j++, iovp++) {
				s = iovp->iov_size;
				if (size + s > ETH_MAX_PACK_SIZE_TAGGED) {
					printf("invalid packet size\n");
				}
				cps = sys_vircopy(or_client, D, iovp->iov_addr,
					SELF, D, (vir_bytes) databuf + o, s);
				if (cps != OK) 
					printf("sys_vircopy failed: %d\n",cps);

				size += s;
				o += s;
			}
		}
		if (size < ETH_MIN_PACK_SIZE)
			printf("invalid packet size %d\n", size);
	} else {
		size = mp->DL_COUNT;
		if (size < ETH_MIN_PACK_SIZE
		    || size > ETH_MAX_PACK_SIZE_TAGGED)
			printf("invalid packet size %d\n", size);

		cps = sys_vircopy(or_client, D, (vir_bytes)mp->DL_ADDR, 
			SELF, D, (vir_bytes) databuf, size);
		if (cps != OK) printf("sys_abscopy failed: %d\n", cps);
	}

	memset (&desc, 0, sizeof (desc));
	desc.tx_control = HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX;

	err = hermes_bap_pwrite (hw, USER_BAP, &desc, sizeof (desc), txfid,
				 0);
	if (err) {
		or_reset();
		goto fail;
	}

	eh = (struct ethhdr *) databuf;
	if (ntohs (eh->h_proto) > 1500) {

		data_len = size - ETH_HLEN;
		data_off = HERMES_802_3_OFFSET + sizeof (hdr);

		memcpy (hdr.dest, eh->h_dest, ETH_ALEN);
		memcpy (hdr.src, eh->h_src, ETH_ALEN);
		hdr.len = htons (data_len + ENCAPS_OVERHEAD);

		memcpy (&hdr.dsap, &encaps_hdr, sizeof (encaps_hdr));
		hdr.ethertype = eh->h_proto;

		err = hermes_bap_pwrite (hw, USER_BAP, &hdr, sizeof (hdr),
					 txfid, HERMES_802_3_OFFSET);
		if (err) {
			printf ("%s: Error %d writing packet header to BAP\n",
				orp->or_name, err);
			goto fail;
		}

		p = ETH_HLEN;
	} else {
		data_len = size + ETH_HLEN;
		data_off = HERMES_802_3_OFFSET;
		p = 0;
	}

	err = hermes_bap_pwrite (hw, USER_BAP,
				 (void *) &(databuf[p]), RUP_EVEN (data_len),
				 txfid, data_off);
	if (err) {
		printf ("hermes_bap_pwrite(data): error %d\n", err);
		goto fail;
	}

	orp->or_tx.ret_busy = TRUE;
	
	err = hermes_docmd_wait (hw, HERMES_CMD_TX | HERMES_CMD_RECL,
				 txfid, NULL);
	if (err) {
		orp->or_tx.ret_busy = FALSE;
		printf ("hermes_docmd_wait(TX|RECL): error %d\n", err);
		goto fail;
	}

fail:
	orp->or_flags |= OR_F_PACK_SENT;

	if (from_int) {
		return;
	}

	reply (orp, OK, FALSE);
	return;

suspend_write:
	orp->or_tx_mess = *mp;
	reply (orp, OK, FALSE);
	return;
}



/*****************************************************************************
 *                or_writev_s                                                *
 *                                                                           *
 * Write data which is denoted by the message to the card and send it.       *
 *****************************************************************************/
static void or_writev_s (message * mp, int from_int) {
	int port, or_client, count, size, err, data_len, data_off, tx_head;
	int o, j, n, i, s, p, cps ;
	struct ethhdr *eh;
	t_or *orp;
	clock_t timebefore, t0;	
	phys_bytes phys_user;
	hermes_t *hw;
	struct hermes_tx_descriptor desc;
	int iov_offset = 0;
	struct header_struct hdr;
	iovec_s_t *iovp;
	phys_bytes phys_databuf;
	u16_t txfid;

	/* We need space for the max packet size itself, plus an ethernet
	 * header, plus 2 bytes so we can align the IP header on a
	 * 32bit boundary, plus 1 byte so we can read in odd length
	 * packets from the card, which has an IO granularity of 16
	 * bits */
	static u8_t databuf[IEEE802_11_DATA_LEN + ETH_HLEN + 2 + 1];
	memset (databuf, 0, IEEE802_11_DATA_LEN + ETH_HLEN + 3);

	port = mp->DL_PORT;
	count = mp->DL_COUNT;
	if (port < 0 || port >= OR_PORT_NR)
		panic(__FILE__, "orinoco: illegal port", NO_NUM);

	or_client = mp->DL_PROC;
	orp = &or_table[port];
	orp->or_client = or_client;
	hw = &(orp->hw);

	/* Switch off interrupts. The card is accessable via 2 BAPs, one for
	 * reading and one for writing. In theory these BAPs should be 
	 * independent, but in practice, the are not. By switching off the
	 * interrupts of the card, the chances of one interfering with the
	 * other should be less */
	if (from_int){
		/* We were called with from_int, meaning that the last time we 
		 * were called, no tx buffers were available, and we had to 
		 * suspend. Now, we'll try again to find an empty buffer in the
		 * card */
		assert (orp->or_flags & OR_F_SEND_AVAIL);
		orp->or_flags &= ~OR_F_SEND_AVAIL;
		orp->or_send_int = FALSE;
		orp->or_tx_alive = TRUE;
	}

	txfid = orp->or_tx.or_txfid;

	if (orp->or_tx.ret_busy || orp->connected == 0) {
		/* there is no buffer in the card available */
		assert(!(orp->or_flags & OR_F_SEND_AVAIL));
		/* Remember that there is a packet to be sent available */
		orp->or_flags |= OR_F_SEND_AVAIL;
		goto suspend_write_s;
	}

	assert (orp->or_mode == OR_M_ENABLED);
	assert (orp->or_flags & OR_F_ENABLED);


	/* Copy the data to be send from the vector to the databuf */
	size = 0;
	o = 0;
	for (i = 0; i < count; i += IOVEC_NR,
		 iov_offset += IOVEC_NR * sizeof (orp->or_iovec_s[0])) {

		n = IOVEC_NR;
		if (i + n > count)
			n = count - i;

		cps = sys_safecopyfrom(or_client, mp->DL_GRANT, iov_offset,
			(vir_bytes) orp->or_iovec_s, 
			n * sizeof(orp->or_iovec_s[0]), D);
		if (cps != OK) 
			printf("orinoco: sys_safecopyfrom failed: %d\n", cps);

		for (j = 0, iovp = orp->or_iovec_s; j < n; j++, iovp++)	{
			s = iovp->iov_size;
			if (size + s > ETH_MAX_PACK_SIZE_TAGGED) {
				printf("Orinoco: invalid pkt size\n");
			}

			cps = sys_safecopyfrom(or_client, iovp->iov_grant, 0,
						(vir_bytes) databuf + o, s, D);
			if (cps != OK) 
				printf("orinoco: sys_safecopyfrom failed:%d\n",
						cps);

			size += s;
			o += s;
		}
	}

	assert(size >= ETH_MIN_PACK_SIZE); 

	memset (&desc, 0, sizeof (desc));
	/* Reclaim the tx buffer once the data is sent (OK), or it is clear 
	 * that transmission failed (EX). Reclaiming means that we can reuse 
	 * the buffer again for transmission */
	desc.tx_control = HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX;
	/* Actually, this reclaim bit is the only thing which needs to be set 
	 * in the descriptor */
	err = hermes_bap_pwrite (hw, USER_BAP, &desc, sizeof (desc), txfid,
				 0);
	if (err) {
		printf("hermes_bap_pwrite() descriptor error:resetting card\n");
		/* When this happens, the card is quite confused: it will not 
		 * recover. Reset it */
		or_reset();
		goto fail;
	}

	eh = (struct ethhdr *) databuf;
	/* Encapsulate Ethernet-II frames */
	if (ntohs (eh->h_proto) > 1500)	{
		/* Ethernet-II frame */
		data_len = size - ETH_HLEN;
		data_off = HERMES_802_3_OFFSET + sizeof (hdr);

		/* 802.3 header */
		memcpy (hdr.dest, eh->h_dest, ETH_ALEN);
		memcpy (hdr.src, eh->h_src, ETH_ALEN);
		hdr.len = htons (data_len + ENCAPS_OVERHEAD);

		/* 802.2 header */
		memcpy (&hdr.dsap, &encaps_hdr, sizeof (encaps_hdr));
		hdr.ethertype = eh->h_proto;

		err = hermes_bap_pwrite (hw, USER_BAP, &hdr, sizeof (hdr),
					 txfid, HERMES_802_3_OFFSET);
		if (err) {
			printf ("%s: Error %d writing packet header to BAP\n",
				orp->or_name, err);
			goto fail;
		}

		p = ETH_HLEN;
	} else {
		/* IEEE 802.3 frame */
		data_len = size + ETH_HLEN;
		data_off = HERMES_802_3_OFFSET;
		p = 0;
	}

	/* Round up for odd length packets */
	err = hermes_bap_pwrite (hw, USER_BAP,
				 (void *) &(databuf[p]), RUP_EVEN (data_len),
				 txfid, data_off);
	if (err) {
		printf ("hermes_bap_pwrite(data): error %d\n", err);
		goto fail;
	}

	/* this should be before the docmd_wait. Cause otherwise the bit can 
		be cleared in the handler (if irq's not off) before it is set
		and then 1 reset (ret_busy=false) is lost */
	orp->or_tx.ret_busy = TRUE;

	/* Send the packet which was constructed in txfid */
	err = hermes_docmd_wait (hw, HERMES_CMD_TX | HERMES_CMD_RECL,
				 txfid, NULL);
	if (err) {
		printf ("hermes_docmd_wait(TX|RECL): error %d\n", err);
		/* Mark the buffer as available again */
		orp->or_tx.ret_busy = FALSE;
		goto fail;
	} 
	
fail:
	/* If the interrupt handler called, don't send a reply. The reply
	 * will be sent after all interrupts are handled. 
	 */
	orp->or_flags |= OR_F_PACK_SENT;

	if (from_int) {
		return;
	}

	reply (orp, OK, FALSE);
	return;

suspend_write_s:
	orp->or_tx_mess = *mp;

	reply (orp, OK, FALSE);
	return;
}


/*****************************************************************************
 *                reply                                                      *
 *                                                                           *
 * Send a message back to the caller, informing it about the data received   *
 * or sent                                                                   *
 *****************************************************************************/
static void reply (t_or * orp, int err, int may_block) {
	message reply;
	int status = 0, r;
	clock_t now;

	if (orp->or_flags & OR_F_PACK_SENT)
		status |= DL_PACK_SEND;
	if (orp->or_flags & OR_F_PACK_RECV)
		status |= DL_PACK_RECV;

	reply.m_type = DL_TASK_REPLY;
	reply.DL_PORT = orp - or_table;
	assert(reply.DL_PORT == 0);
	reply.DL_PROC = orp->or_client;
	reply.DL_STAT = status | ((u32_t) err << 16);
	reply.DL_COUNT = orp->or_read_s;

	if (OK != (r = getuptime(&now)))
		panic(__FILE__, "orinoco: getuptime() failed:", r);

	reply.DL_CLCK = now;
	r = send (orp->or_client, &reply);

	if (r == ELOCKED && may_block) {
		return;
	}

	if (r < 0)
		panic(__FILE__, "orinoco: send failed:", r);

	orp->or_read_s = 0;
	orp->or_flags &= ~(OR_F_PACK_SENT | OR_F_PACK_RECV);
}



/*****************************************************************************
 *                or_ev_info                                                 *
 *                                                                           *
 * Process information which comes in from the card                          *
 *****************************************************************************/
static void or_ev_info (t_or * orp) {
	u16_t infofid;
	int err, len, type, i;
	hermes_t *hw = &orp->hw;

	struct {
		u16_t len;
		u16_t type;
	} info;

	infofid = hermes_read_reg (hw, HERMES_INFOFID);
	err = hermes_bap_pread (hw, IRQ_BAP, &info, sizeof (info), infofid,
				0);
	if (err) {
		printf ("%s: error %d reading info frame.\n", orp->or_name,
			err);
		return;
	}

	len = HERMES_RECLEN_TO_BYTES (info.len);
	type = info.type;

	switch (type) {
	case HERMES_INQ_TALLIES:
		{
			struct hermes_tallies_frame tallies;

			if (len > sizeof (tallies))	{
				printf ("%s: Tallies frame too long ",
					orp->or_name);
				printf ("(%d bytes)\n", len);
				len = sizeof (tallies);
			}
			hermes_read_words (hw, HERMES_DATA1,
					   (void *) &tallies, len / 2);
			/* TODO: do something with the tallies structure */
		}
		break;

	case HERMES_INQ_LINKSTATUS: {
			u16_t newstatus;
			struct hermes_linkstatus linkstatus;

			if (len != sizeof (linkstatus))	{
				printf ("%s: Unexpected size for linkstatus ",
					orp->or_name);
				printf ("frame (%d bytes)\n", len);
			}

			hermes_read_words (hw, HERMES_DATA1,
					   (void *) &linkstatus, len / 2);
			newstatus = linkstatus.linkstatus;

			if ((newstatus == HERMES_LINKSTATUS_CONNECTED)
			    || (newstatus == HERMES_LINKSTATUS_AP_CHANGE)
			    || (newstatus == HERMES_LINKSTATUS_AP_IN_RANGE)) {
				orp->connected = 1;

		if(orp->or_flags & OR_F_SEND_AVAIL)	{
		 	orp->or_send_int = TRUE;
			orp->or_got_int = TRUE;
			int_event_check = TRUE;
		}


			}
			else if ((newstatus ==
				  HERMES_LINKSTATUS_NOT_CONNECTED)
				 || (newstatus ==
				     HERMES_LINKSTATUS_DISCONNECTED)
				 || (newstatus ==
				     HERMES_LINKSTATUS_AP_OUT_OF_RANGE)
				 || (newstatus ==
				     HERMES_LINKSTATUS_ASSOC_FAILED)) {
				orp->connected = 0;
			}

			if (newstatus != orp->last_linkstatus)
				print_linkstatus(orp, newstatus);

			orp->last_linkstatus = newstatus;
		}
		break;
	default:
		printf ("%s:Unknown information frame received(type %04x).\n",
			orp->or_name, type);
		break;
	}
}

/*****************************************************************************
 *                or_print_linkstatus                                        *
 *                                                                           *
 * Process information which comes in from the card                          *
 *****************************************************************************/
static void print_linkstatus (t_or * orp, u16_t status) {
	int err;
	u16_t d;
	char *s;
	hermes_t *hw = &(orp->hw);

	switch (status) {
	case HERMES_LINKSTATUS_NOT_CONNECTED:
		s = "Not Connected";
		break;
	case HERMES_LINKSTATUS_CONNECTED:
		s = "Connected";
		break;
	case HERMES_LINKSTATUS_DISCONNECTED:
		s = "Disconnected";
		break;
	case HERMES_LINKSTATUS_AP_CHANGE:
		s = "AP Changed";
		break;
	case HERMES_LINKSTATUS_AP_OUT_OF_RANGE:
		s = "AP Out of Range";
		break;
	case HERMES_LINKSTATUS_AP_IN_RANGE:
		s = "AP In Range";
		break;
	case HERMES_LINKSTATUS_ASSOC_FAILED:
		s = "Association Failed";
		break;
	default:
		s = "UNKNOWN";
	}

	printf ("%s: link status: %s, ", orp->or_name, s);

	err = hermes_read_wordrec (hw, USER_BAP, 
			HERMES_RID_CURRENTCHANNEL, &d);
	if (err) {
		printf ("%s: Error %d \n", orp->or_name, err);
		return;
	}
	printf("channel: %d, freq: %d MHz ", 
		d, (channel_frequency[d-1]));

}


/*****************************************************************************
 *                or_check_ints                                              *
 *                                                                           *
 * Process events which have been postponed in the interrupt handler         *
 *****************************************************************************/
static void or_check_ints (t_or * orp) {
	int or_flags;
	hermes_t *hw = &orp->hw;

	if (orp->or_need_reset)
		or_reset();
	if ((orp->rx_first!=orp->rx_last) && (orp->or_flags & OR_F_READING)) {
		orp->or_ev_rx = 0;
		if (orp->or_rx_mess.m_type == DL_READV) {
			or_readv (&orp->or_rx_mess, TRUE, TRUE);
		} else if(orp->or_rx_mess.m_type == DL_READV_S) {
			or_readv_s (&orp->or_rx_mess, TRUE);
		} else {
			assert(orp->or_rx_mess.m_type == DL_READ);
			or_readv (&orp->or_rx_mess, TRUE, FALSE);
		}
	}

	if (orp->or_send_int) {
		if (orp->or_tx_mess.m_type == DL_WRITEV) {
			or_writev (&orp->or_tx_mess, TRUE, TRUE);
		}
		else if(orp->or_tx_mess.m_type == DL_WRITEV_S) {
			or_writev_s (&orp->or_tx_mess, TRUE);
		} else {
			assert(orp->or_tx_mess.m_type == DL_WRITE);
			or_writev (&orp->or_tx_mess, TRUE, FALSE);
		}
	}

	if (orp->or_flags & (OR_F_PACK_SENT | OR_F_PACK_RECV)) {
		reply (orp, OK, TRUE);
	}
}


/*****************************************************************************
 *                is_ethersnap                                               *
 *                                                                           *
 * is there an LLC and SNAP header in the ethernet packet? The inet task     *
 * isn't very interested in it...                                            *
 *****************************************************************************/
static int is_ethersnap(struct header_struct *hdr)  {

	/* We de-encapsulate all packets which, a) have SNAP headers
	 * (i.e. SSAP=DSAP=0xaa and CTRL=0x3 in the 802.2 LLC header
	 * and where b) the OUI of the SNAP header is 00:00:00 or
	 * 00:00:f8 - we need both because different APs appear to use
	 * different OUIs for some reason */
	return (memcmp(&hdr->dsap, &encaps_hdr, 5) == 0)
		&& ( (hdr->oui[2] == 0x00) || (hdr->oui[2] == 0xf8) );
}
	
/*****************************************************************************
 *                or_readv                                                   *
 *                                                                           *
 * As far as we can see, this function is never called from 3.1.3. However,  *
 * it is still in rtl8139, so we'll keep it here as well. It's almost a copy *
 * of or_readv_s. We left out the comments. For an explanation, see          *
 * or_readv_s                                                                *
 *****************************************************************************/
static void or_readv (message * mp, int from_int, int vectored) {
	int i, j, n, o, s, s1, dl_port, or_client, count, size, err, yep, cps;
	port_t port;
	clock_t timebefore;
	unsigned amount, totlen, packlen;
	struct hermes_rx_descriptor desc;
	phys_bytes dst_phys;
	u16_t d_start, d_end, rxfid, status;
	struct header_struct hdr;
	int length, offset;
	u32_t l, rxstat;
	struct ethhdr *eh;
	struct header_struct *h;
	t_or *orp;
	hermes_t *hw;
	iovec_t *iovp;
	u8_t *databuf;

	dl_port = mp->DL_PORT;
	count = mp->DL_COUNT;
	if (dl_port < 0 || dl_port >= OR_PORT_NR)
		panic(__FILE__, "orinoco: illegal port:", dl_port);

	orp = &or_table[dl_port];
	or_client = mp->DL_PROC;
	orp->or_client = or_client;
	hw = &(orp->hw);

	assert (orp->or_mode == OR_M_ENABLED);
	assert (orp->or_flags & OR_F_ENABLED);

	if (!from_int && (orp->rx_first==orp->rx_last)) {
		goto suspend_readv;
	}

	rxfid = orp->rxfid[orp->rx_first];
	databuf = &(orp->rx_buf[orp->rx_first][0]);
	length = orp->rx_length[orp->rx_first];

	orp->rxfid[orp->rx_first] = NO_FID;
	orp->rx_length[orp->rx_first] = 0;

	orp->rx_first++;
	orp->rx_first %= NR_RX_BUFS;

	o = 0;
	
	if (vectored) {
		int iov_offset = 0;
		size = 0;

		for (i = 0; i < count; i += IOVEC_NR,
			iov_offset += IOVEC_NR * sizeof(orp->or_iovec[0])) {

			n = IOVEC_NR;
			if (i + n > count)
				n = count - i;
			
			cps = sys_vircopy(or_client, D, 
					(vir_bytes) mp->DL_ADDR + iov_offset,
					SELF, D, (vir_bytes) orp->or_iovec, 
					n * sizeof(orp->or_iovec[0]));
			if (cps != OK) printf("sys_vircopy failed: %d (%d)\n", 
							cps, __LINE__);

			for (j = 0, iovp = orp->or_iovec; j < n; j++, iovp++) {
				s = iovp->iov_size;
				if (size + s > length) {
					assert (length > size);
					s = length - size;
				}

				cps = sys_vircopy(SELF, D, 
						(vir_bytes) databuf + o,
						or_client, D, 
						iovp->iov_addr, s);
				if (cps != OK) 
					printf("sys_vircopy failed:%d (%d)\n", 
						cps, __LINE__);

				size += s;
				if (size == length)
					break;
				o += s;
			}
			if (size == length)
				break;
		}
		assert (size >= length);
	} 

	orp->or_stat.ets_packetR++;
	orp->or_read_s = length;
	orp->or_flags &= ~OR_F_READING;
	orp->or_flags |= OR_F_PACK_RECV;

	if (!from_int)
		reply (orp, OK, FALSE);

	return;

suspend_readv :
	if (from_int) {
		assert (orp->or_flags & OR_F_READING);
		return;
	}

	orp->or_rx_mess = *mp;
	assert (!(orp->or_flags & OR_F_READING));
	orp->or_flags |= OR_F_READING;

	reply (orp, OK, FALSE);
}


/*****************************************************************************
 *                or_readv_s                                                 *
 *                                                                           *
 * Copy the data which is stored in orp->rx_buf[orp->rx_first] in the vector *
 * which was given with the message *mp                                      *
 *****************************************************************************/
static void or_readv_s (message * mp, int from_int) {
	int i, j, n, o, s, s1, dl_port, or_client, count, size, err, cps;
	int iov_offset = 0, length, offset;
	port_t port;
	clock_t timebefore;
	unsigned amount, totlen, packlen;
	struct hermes_rx_descriptor desc;
	phys_bytes dst_phys;
	u16_t d_start, d_end, rxfid, status;
	struct header_struct hdr;
	u32_t l, rxstat;
	struct ethhdr *eh;
	struct header_struct *h;
	t_or *orp;
	hermes_t *hw;

	iovec_s_t *iovp;
	phys_bytes databuf_phys;

	u8_t *databuf;

	dl_port = mp->DL_PORT;
	count = mp->DL_COUNT;
	if (dl_port < 0 || dl_port >= OR_PORT_NR)
		panic(__FILE__, "orinoco: illegal port:", dl_port);

	orp = &or_table[dl_port];
	or_client = mp->DL_PROC;
	orp->or_client = or_client;
	hw = &(orp->hw);

	assert (orp->or_mode == OR_M_ENABLED);
	assert (orp->or_flags & OR_F_ENABLED);

	if (!from_int && (orp->rx_first==orp->rx_last))

	{
	/* if we are not called from a hard int (data is not yet available) and
	 * there are no buffers (or->rx_buf[x]) which contain any data, we cant
	 * copy any data to the inet server. Goto suspend, and wait for data 
	 * to arrive */
		goto suspend_readv_s;
	}
	


	/* get the buffer which contains new data */
	rxfid = orp->rxfid[orp->rx_first];
	/* and store the pointer to this data in databuf */
	databuf = &(orp->rx_buf[orp->rx_first][0]);
	length = orp->rx_length[orp->rx_first];

	orp->rxfid[orp->rx_first] = NO_FID;
	orp->rx_length[orp->rx_first] = 0;

	/* Next time, the next buffer with data will be retrieved */
	orp->rx_first++;
	orp->rx_first %= NR_RX_BUFS;

	o = 0;
	/* The data which we want to be copied to the vector starts at 
	 * *databuf and will be copied to the vecor below */
	size = 0;
	for (i = 0; i < count; i += IOVEC_NR,
		iov_offset += IOVEC_NR * sizeof(orp->or_iovec_s[0])) {
		n = IOVEC_NR;
		if (i + n > count)
			n = count - i;

		cps = sys_safecopyfrom(or_client, mp->DL_GRANT, iov_offset, 
				(vir_bytes)orp->or_iovec_s,
				n * sizeof(orp->or_iovec_s[0]), D);
		if (cps != OK) 
			panic(__FILE__, 
			"orinoco: warning, sys_safecopytp failed:", cps);

		for (j = 0, iovp = orp->or_iovec_s; j < n; j++, iovp++)	{
			s = iovp->iov_size;
			if (size + s > length) {
				assert (length > size);
				s = length - size;
			}
			cps = sys_safecopyto(or_client, iovp->iov_grant, 0, 
					(vir_bytes) databuf + o, s, D);
			if (cps != OK) 
				panic(__FILE__, 
				"orinoco: warning, sys_safecopy failed:", 
				cps);

			size += s;
			if (size == length)
				break;
			o += s;
		}
		if (size == length)
			break;
	}

	assert(size >= length);

	orp->or_stat.ets_packetR++;
drop:
	orp->or_read_s = length;
	orp->or_flags &= ~OR_F_READING;
	orp->or_flags |= OR_F_PACK_RECV;

	if (!from_int) {
		/* There was data in the orp->rx_buf[x] which is now copied to 
		 * the inet sever. Tell the inet server */
		reply (orp, OK, FALSE);
	}

	return;
suspend_readv_s:
	if (from_int) {
		assert (orp->or_flags & OR_F_READING);
		/* No need to store any state */
		return;
	}

	/* We want to store the message, so that next time when we are called 
	 * by hard int, we know where to copy the received data */
	orp->or_rx_mess = *mp;
	assert (!(orp->or_flags & OR_F_READING));
	orp->or_flags |= OR_F_READING;

	reply (orp, OK, FALSE);

}


/*****************************************************************************
 *            or_get_recvd_packet                                            *
 *                                                                           *
 * The card has received data. Retrieve the data from the card and put it    *
 * in a buffer in the driver (in the orp structure)                          *
 *****************************************************************************/
static int or_get_recvd_packet(t_or *orp, u16_t rxfid, u8_t *databuf) {
	struct hermes_rx_descriptor desc;
	hermes_t *hw;
	struct header_struct hdr;
	int err, length, offset;
	struct ethhdr *eh;
	u16_t status;
	
	memset(databuf, 0, IEEE802_11_FRAME_LEN);

	hw = &(orp->hw);

	/* Read the data from the buffer in the card which holds the data. 
	 * First get the descriptor which will tell us whether the packet is 
	 * healthy*/
	err = hermes_bap_pread (hw, IRQ_BAP, &desc, sizeof (desc), rxfid, 0);
	if (err) {
		printf("Orinoco: error %d reading Rx descriptor. "
			"Frame dropped\n", err);
		orp->or_stat.ets_recvErr++;
		return -1;
	}

	status = desc.status;

	if (status & HERMES_RXSTAT_ERR)	{
		if (status & HERMES_RXSTAT_UNDECRYPTABLE) {
			printf("Error reading Orinoco Rx descriptor.Dropped");
		} else {
			orp->or_stat.ets_CRCerr++;
			printf("Orinoco: Bad CRC on Rx. Frame dropped\n");
		}
		orp->or_stat.ets_recvErr++;
		return -1;
	}

	/* For now we ignore the 802.11 header completely, assuming
	   that the card's firmware has handled anything vital. The only
	   thing we want to know is the length of the received data */
	err = hermes_bap_pread (hw, IRQ_BAP, &hdr, sizeof (hdr),
				rxfid, HERMES_802_3_OFFSET);

	if (err) {
		printf("Orinoco: error %d reading frame header. "
			"Frame dropped\n", err);
		orp->or_stat.ets_recvErr++;
		return -1;
	}

	length = ntohs (hdr.len);
	
	/* Sanity checks */
	if (length < 3)	{
		/* No for even an 802.2 LLC header */
		printf("Orinoco: error in frame length: length = %d\n",
			length);
		/* orp->or_stat.ets_recvErr++; */
		return -1;
	}

	if (length > IEEE802_11_DATA_LEN) {
		printf("Orinoco: Oversized frame received (%d bytes)\n",
			length);
		orp->or_stat.ets_recvErr++;
		return -1;
	}

	length += sizeof (struct ethhdr);
	offset = HERMES_802_3_OFFSET;

	/* Read the interesting parts of the data to the drivers memory. This
	 * would be everything from the 802.3 layer and up */
	err = hermes_bap_pread (hw,
				IRQ_BAP, (void *) databuf, RUP_EVEN (length),
				rxfid, offset);

	if (err) {
		printf("Orinoco: error doing hermes_bap_pread()\n");
		orp->or_stat.ets_recvErr++;
		return -1;
	}

	/* Some types of firmware give us the SNAP and OUI headers. Remove these.
	 */
	if (is_ethersnap(&hdr))	{
		eh = (struct ethhdr *) databuf;
		length -= 8;

		
		memcpy (databuf + ETH_ALEN * 2, 
			databuf + sizeof(struct header_struct) - 2, 
			length - ETH_ALEN * 2);
	}

	if(length<60) length=60;
	
	return length;
}

/*****************************************************************************
 *            or_getstat                                                     *
 *                                                                           *
 * Return the statistics structure. The statistics aren't updated until now, *
 * so this won't return much interesting yet.                                *
 *****************************************************************************/
static void or_getstat (message * mp) {
	int r, port;
	eth_stat_t stats;
	t_or *orp;

	port = mp->DL_PORT;
	if (port < 0 || port >= OR_PORT_NR)
		panic(__FILE__, "orinoco: illegal port:", port);
	orp = &or_table[port];
	orp->or_client = mp->DL_PROC;

	assert (orp->or_mode == OR_M_ENABLED);
	assert (orp->or_flags & OR_F_ENABLED);

	stats = orp->or_stat;

	r = sys_datacopy(SELF, (vir_bytes)&stats, mp->DL_PROC,
			(vir_bytes) mp->DL_ADDR, sizeof(stats));
	if(r != OK) {
		panic(__FILE__, "or_getstat: send failed:", r);	
	}

	mp->m_type = DL_STAT_REPLY;
	mp->DL_PORT = port;
	mp->DL_STAT = OK;

	r = send(mp->m_source, mp);
	if(r != OK)
		panic(__FILE__, "orinoco: getstat failed:", r);

	/*reply (orp, OK, FALSE);*/

}

/*****************************************************************************
 *            or_getstat_s                                                   *
 *                                                                           *
 * Return the statistics structure. The statistics aren't updated until now, *
 * so this won't return much interesting yet.                                *
 *****************************************************************************/
static void or_getstat_s (message * mp) {
	int r, port;
	eth_stat_t stats;
	t_or *orp;

	port = mp->DL_PORT;
	if (port < 0 || port >= OR_PORT_NR)
		panic(__FILE__, "orinoco: illegal port:", port);
	assert(port==0);
	orp = &or_table[port];
	orp->or_client = mp->DL_PROC;

	assert (orp->or_mode == OR_M_ENABLED);
	assert (orp->or_flags & OR_F_ENABLED);

	stats = orp->or_stat;

	r = sys_safecopyto(mp->DL_PROC,	mp->DL_GRANT, 0, 
				(vir_bytes) &stats, sizeof(stats), D);
	if(r != OK) {
		panic(__FILE__, "or_getstat_s: sys_safecopyto failed:", r);
	}

	mp->m_type = DL_STAT_REPLY;
	mp->DL_PORT = port;
	mp->DL_STAT = OK;

	r = send(mp->m_source, mp);
	if(r != OK)
		panic(__FILE__, "orinoco: getstat_s failed:", r);
}

