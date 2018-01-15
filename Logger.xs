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
		LOG_ERROR, /* 3 or also DIE */
		LOG_FATAL  /* 4 or also PANIC */
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
xlog_new(class, ...)
    char* class
PREINIT:
	    MyLogger* mylogger;
	    SV*            obj;
	    HV*           opts = NULL;
	    SV **svp;
CODE:
{

	/* mylogger = malloc(sizeof(MyLogger)); */ /* malloc our object */
	Newxz( mylogger, 1, MyLogger);
	RETVAL = newSViv(0);
	obj = newSVrv(RETVAL, class); /* bless our object */

	if( items > 1 ) { /* could also probably use va_start, va_list, ... */
		SV *extra = (SV*) ST(1);
		if ( SvROK(extra) && SvTYPE(SvRV(extra)) == SVt_PVHV )
			opts = (HV*) SvRV( extra );
	}
	if ( opts ) {
		if ( hv_existss( opts, "x" ) ) {
			if ( svp = hv_fetchs(opts, "x", FALSE) ) {
				mylogger->x =  SvIV(*svp);
			}
		}
		if ( hv_existss( opts, "y" ) ) {
			if ( svp = hv_fetchs(opts, "y", FALSE) ) {
				mylogger->y =  SvIV(*svp);
			}
		}
	}

	/* ... */

	sv_setiv(obj, PTR2IV(mylogger)); /* get a pointer to our malloc object */
	SvREADONLY_on(obj);
}
OUTPUT:
	RETVAL

SV*
xlog_getters(self)
    SV* self
ALIAS:
     XS::Logger::get_x                 = 1
     XS::Logger::get_y                 = 2
PREINIT:
	MyLogger* mylogger;
CODE:
{
	mylogger = INT2PTR(MyLogger*, SvIV(SvRV(self)));
     int i = 0;
     switch (ix) {
         case 1:
             RETVAL = newSViv( mylogger->x );
         break;
         case 2:
             RETVAL = newSViv( mylogger->y );
         break;
         default:
             XSRETURN_EMPTY;

     }
}
OUTPUT:
	RETVAL


SV*
xlog_loggers(self)
     SV* self
ALIAS:
	    XS::Logger::info                 = 1
	    XS::Logger::warn                 = 2
	    XS::Logger::error                = 3
	    XS::Logger::die                  = 4
	    XS::Logger::panic                = 5
	    XS::Logger::fatal                = 6
	    XS::Logger::debug                = 7
PREINIT:
     	SV *ret;
CODE:
{
     logLevel level = 0;
     switch (ix) {
         case 1: /* info */
             level = LOG_INFO;
         break;
         case 2: /* warn */
             level = LOG_WARN;
         break;
         case 3: /* error */
         case 4: /* die */
            level = LOG_ERROR;
         break;
         case 5: /* panic */
         case 6: /* fatal */
            level = LOG_FATAL;
         break;
         case 7:
            level = LOG_DEBUG;
         break;
         default:
             level = 0;

     }

     RETVAL = newSViv( level );
}
OUTPUT:
	RETVAL


SV*
xlog_helpers()
     ALIAS:
     XS::Logger::xinfo                 = 1
     XS::Logger::xwarn                 = 2
     XS::Logger::xdie                  = 3
     XS::Logger::xpanic                = 4
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

BOOT:
{
	HV *stash;

	stash = gv_stashpvn("XS::Logger", 10, TRUE);
	newCONSTSUB(stash, "_loaded", newSViv(1) );
}