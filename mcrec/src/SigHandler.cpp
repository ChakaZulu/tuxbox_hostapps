
#ifdef __GNUG__
#pragma implementation
#endif

#include "SigHandler.h"

#include <errno.h>
#include <strings.h>
#include <stdio.h>
#include <string.h>

// ###################################################################

bool SigFlags::flags[_NSIG];
bool SigFlags::initialized = false;

SigHandler SigFlags::handlers[_NSIG];
	

// ###################################################################

SigHandler::~SigHandler (void) {
	
	if (deactivate()) {
		fprintf(stderr,"SigHandler::~SigHandler unable to deactivate\n");
	}
	
}

// ###################################################################

int SigHandler::activate(void) {
	
	if (activated) return 0;
	
	if (sigaction(num, &action, &old_action) < 0) {
		fprintf(stderr,"SigHandler::activate %s\n", strerror(errno));
		return -1;
	}
	
	activated = true;
	return 0;
}

// ###################################################################

int SigHandler::deactivate(void) {
	
	if (!activated) return 0;
	
	if (sigaction(num, &old_action, 0) < 0) {
		fprintf(stderr,"SigHandler::deactivate %s\n", strerror(errno));
		return -1;
	}
	
	activated = false;
	return 0;
}

// ###################################################################

SigFlags::SigFlags(void) {
	if (!initialized) {
		initialized = true;
		reset_all();
	}
	
	for (int i = 0; i < _NSIG; i++) {
		handlers[i].set_num(i);
		handlers[i].set_function(SigFlags::generic_handler);
	}
	
	handlers[SIGILL].set_function(SigFlags::core_dump_handler);
	if (handlers[SIGILL].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGILL");
	}

	handlers[SIGBUS].set_function(SigFlags::core_dump_handler);
	if (handlers[SIGBUS].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGBUS\n");
	}

	handlers[SIGIO].set_function(SigFlags::core_dump_handler);
	if (handlers[SIGIO].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGIO\n");
	}

	handlers[SIGXCPU].set_function(SigFlags::core_dump_handler);
	if (handlers[SIGXCPU].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGXCPU\n");
	}

	handlers[SIGXFSZ].set_function(SigFlags::core_dump_handler);
	if (handlers[SIGXFSZ].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGXFSZ\n");
	}

	if (handlers[SIGINT].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGINT\n");
	}
	if (handlers[SIGTERM].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGTERM\n");
	}
	if (handlers[SIGHUP].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGHUP\n");
	}
	if (handlers[SIGCHLD].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGCHLD\n");
	}
	if (handlers[SIGALRM].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGALRM\n");
	}
	if (handlers[SIGPIPE].activate()) {
		fprintf(stderr,"SigFlags: unable to handle SIGPIPE\n");
	}
}

// ###################################################################
