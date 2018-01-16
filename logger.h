/*
 * logger.h
 *
 *
 */

#ifndef XS_LOGGER_H
#  define XS_LOGGER_H

#include <perl.h>

/* typedef enum { xfalse, xtrue } xbool; */

typedef enum {
		LOG_DEBUG, /* 0 */
		LOG_INFO,  /* 1 */
		LOG_WARN,  /* 2 */
		LOG_ERROR, /* 3 or also DIE */
		LOG_FATAL,  /* 4 or also PANIC */
		/* keep it in last position */
	    LOG_DISABLE  /* 5 - disable all log events - should be preserved in last position */
} logLevel;

typedef struct {
	int x;
	int y;
	int pid;
	int fd; /* FIXME improve style -- maybe do not need to use is_open */
	PerlIO *handle;
	bool is_open;
	char *filepath; /* maybe use one SV* so we do not need to worry about free here */
	logLevel level; /* only display what is after the log level (included) */
} MyLogger;

/* function prototypes */
void do_log(MyLogger *mylogger, logLevel level, ...);


#endif /* XS_LOGGER_H */