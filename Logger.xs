#define PERL_EXT_XS_LOG

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>
#include <unistd.h>
#include <stdarg.h>
#include <stdio.h>
#include <fcntl.h>

#include <time.h>
#include "logger.h"

/* some constants */
static const char *level_names[] = {
  "DEBUG", "INFO", "WARN", "ERROR", "FATAL" /* , "DISABLE" */
};

static const char *level_colors[] = {
  "\x1b[94m", "\x1b[36m", "\x1b[32m", "\x1b[33m", "\x1b[31m", "\x1b[35m"
};

/* c internal functions */
void
do_log(MyLogger *mylogger, logLevel level, ...) {
	PerlIO *handle = NULL;
	char path[256] = "/tmp/my-test";
	/* Get current time */
  	time_t t = time(NULL);
  	struct tm *lt = localtime(&t);
	char buf[32];
	bool has_logger_object = true;


	if ( level == LOG_DISABLE ) /* to move earlier */
		return;

	buf[strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", lt)] = '\0';

	/* Note: *mylogger can be a NULL pointer => would fall back to a GV string or a constant from .c to get the filename */

	if ( mylogger ) { /* we got a mylogger pointer */
		if ( ! mylogger->handle ) {
			/* probably do not use PerlIO layer at all */
			if ( (handle = PerlIO_open( path, "a" )) == NULL ) /* open in append mode */
				croak("Failed to open file \"%s\"", path);
			mylogger->handle = handle; /* save the handle for future reuse */
		}

		handle = mylogger->handle;
	} else {
		has_logger_object = false;
		if ( (handle = PerlIO_open( path, "a" )) == NULL ) /* open in append mode */
			croak("Failed to open file \"%s\"", path);
	}

	if ( handle ) {
		/* acquire lock */
		flock( handle, LOCK_EX );

		/* write the message */
		PerlIO_printf( handle, "%s %-5s %s:%d: ", buf, level_names[level], path, level );
		PerlIO_write( handle, "a message...", 12 );
		PerlIO_write( handle, "\n", 1 );

		PerlIO_flush(handle);
		/* release lock */
		flock( handle, LOCK_UN );
	}

	if ( !has_logger_object ) {
		PerlIO_close( handle );
	}

	return;
}

/* function exposed to the module */
/* maybe a bad idea to use a prefix */
MODULE = XS__Logger    PACKAGE = XS::Logger PREFIX = xlog_

SV*
xlog_new(class, ...)
    char* class;
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


int
xlog_loggers(self, ...)
     SV* self;
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
     logLevel level = LOG_DISABLE;
     bool dolog = true;
     MyLogger* mylogger = NULL; /* can be null when not called on an object */

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
            level = LOG_DISABLE; /* maybe use LOG_DISABLE there */

     }

     /* call the logger function */
     /* check the caller level */
     if ( self && SvROK(self) && SvOBJECT(SvRV(self)) ) { /* check if self is an object */
     	mylogger = INT2PTR(MyLogger*, SvIV(SvRV(self)));

     	if ( level < mylogger->level )
     		dolog = false;
     }

     if (dolog) {
  		// va_list args;

  		// va_start(args, self);
  		/* (unsigned long) getpid() */
  		// do_log( mylogger, level, args );
  		// va_end(args);

  		do_log( mylogger, level );


     }


     RETVAL = level;
}
OUTPUT:
	RETVAL


SV*
xlog_getters(self)
    SV* self;
ALIAS:
     XS::Logger::get_x                 = 1
     XS::Logger::get_y                 = 2
     XS::Logger::get_pid               = 3
PREINIT:
	MyLogger* mylogger;
CODE:
{   /* some getters: mainly used for test for now to access internals */
	mylogger = INT2PTR(MyLogger*, SvIV(SvRV(self)));
     int i = 0;
     switch (ix) {
         case 1:
             RETVAL = newSViv( mylogger->x );
         break;
         case 2:
             RETVAL = newSViv( mylogger->y );
         break;
        case 3:
             RETVAL = newSViv( mylogger->pid );
         break;
         default:
             XSRETURN_EMPTY;

     }
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

void DESTROY(self)
    SV* self;
PREINIT:
	    I32* temp;
	    MyLogger* mylogger;
PPCODE:
{
	    temp = PL_markstack_ptr++;

	    if ( self && SvROK(self) && SvOBJECT(SvRV(self)) ) { /* check if self is an object */
		    mylogger = INT2PTR(MyLogger*, SvIV(SvRV(self)));
		    /* close the file handle on destroy if exists */
		    if ( mylogger->handle )
		    	PerlIO_close( mylogger->handle );
		    /* free the logger... maybe more to clear from struct */
		    free(mylogger);
	    }

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