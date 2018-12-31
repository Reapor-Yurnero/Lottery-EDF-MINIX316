#define NOT 0
#define ISREAD 1
#define ISWRITE 2
#define ISEXEC 3
#define ISFILE 4
#define ISDIR 5
#define ISCHAR 6
#define ISBLOCK 7
#define ISFIFO 8
#define ISSETUID 9
#define ISSETGID 10
#define ISSTICKY 11
#define ISSLINK 12
#define ISSIZE 13
#define ISTTY 14
#define NULSTR 15
#define STRLEN 16
#define OR1 17
#define OR2 18
#define AND1 19
#define AND2 20
#define STREQ 21
#define STRNE 22
#define NEWER 23
#define EQ 24
#define NE 25
#define GT 26
#define LT 27
#define LE 28
#define GE 29
#define PLUS 30
#define MINUS 31
#define TIMES 32
#define DIVIDE 33
#define REM 34
#define MATCHPAT 35

#define FIRST_BINARY_OP 17

#define OP_INT 1		/* arguments to operator are integer */
#define OP_STRING 2		/* arguments to operator are string */
#define OP_FILE 3		/* argument is a file name */

extern char *const unary_op[];
extern char *const binary_op[];
extern const char op_priority[];
extern const char op_argflag[];
