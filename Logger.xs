#define PERL_EXT_XS_LOG

#define PERL_NO_GET_CONTEXT
#include <EXTERN.h>
#define PERLIO_NOT_STDIO 1
#include <perl.h>
#include <XSUB.h>
#include "logger.h"
#ifdef I_UNISTD
#  include <unistd.h>
#endif
#if defined(I_FCNTL) || defined(HAS_FCNTL)
#  include <fcntl.h>
#endif

/* c internal functions */
/* this needs to go to our .h file */

/* typedef enum { xfalse, xtrue } xbool; */

typedef enum {
		LOG_DEBUG, /* 0 */
		LOG_INFO,  /* 1 */
		LOG_WARN,  /* 2 */
		LOG_ERROR, /* 3 */
		LOG_FATAL  /* 4 */
} logLevel;

typedef struct {
	int x;
	int y;
	int fd; /* FIXME improve style -- maybe do not need to use is_open */
	bool is_open;
	char *filepath;
	logLevel level;
} MyLogger;

/* function exposed to the module */
/* maybe a bad idea to use a prefix */
MODULE = XS__Logger    PACKAGE = XS::Logger PREFIX = xlog_

SV*
xlog_new(class, x, y)
    char* class
    int x
    int y
PREINIT:
	    MyLogger* mylogger;
	    SV*            obj;
CODE:
{
	    mylogger = malloc(sizeof(MyLogger)); /* malloc our object */
	    RETVAL = newSViv(0);
	    obj = newSVrv(RETVAL, class); /* bless our object */
	    mylogger->x = x;
	    mylogger->y = y;
	    /* ... */

	    sv_setiv(obj, PTR2IV(mylogger)); /* get a pointer to our malloc object */
	    SvREADONLY_on(obj);
}
OUTPUT:
	RETVAL

void DESTROY(obj)
    SV* obj
PREINIT:
	    I32* temp;
	    MyLogger* mylogger;
PPCODE:
{
	    temp = PL_markstack_ptr++;
	    mylogger = INT2PTR(MyLogger*, SvIV(SvRV(obj)));
	    free(mylogger);
	    if (PL_markstack_ptr != temp) {
	        /* truly void, because dXSARGS not invoked */
	        PL_markstack_ptr = temp;
	        XSRETURN_EMPTY;
	        /* return empty stack */
	    }  /* must have used dXSARGS; list context implied */
	    return;  /* assume stack size is correct */
}


SV*
xlog_helpers()
     ALIAS:
     XS::Logger::info                 = 1
     XS::Logger::warn                 = 2
     XS::Logger::die                  = 3
     XS::Logger::panic                = 4
PREINIT:
     SV *ret;
CODE:
{
     int i = 0;
     switch (ix) {
         case 1:
             i = 10; /* sizeof( struct xpvhv_aux ); */
         break;
         case 2:
             i = 20;
         break;
         default:
             i = ix * 100 + ix;

     }
     RETVAL = newSViv( i );
}
OUTPUT:
	RETVAL

BOOT:
{
	HV *stash;

	stash = gv_stashpvn("XS::Logger", 10, TRUE);
	newCONSTSUB(stash, "_loaded", newSViv(1) );
}