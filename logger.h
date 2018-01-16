/*
 * logger.h
 *
 *
 */

#ifndef XS_LOGGER_H
#  define XS_LOGGER_H

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
	int pid;
	int fd; /* FIXME improve style -- maybe do not need to use is_open */
	bool is_open;
	char *filepath;
	logLevel level;
} MyLogger;

#endif /* XS_LOGGER_H */