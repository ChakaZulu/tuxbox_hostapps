
#ifndef SigHandler_h
#define SigHandler_h

#include <signal.h>

#ifdef __GNUG__
#pragma interface
#endif

#if defined (__CYGWIN__) || defined(__svr4__)
#define _NSIG NSIG
#endif

// ###################################################################

class SigHandler {
protected:
	
	int num;
	
	struct sigaction action;
	struct sigaction old_action;
	
	bool activated;
	
public:
	
	bool is_active(void) const { return activated; }
	
	SigHandler(void) : num(0) {
		action.sa_handler = 0;
		sigemptyset(&action.sa_mask);
		action.sa_flags = 0;
		
		activated = false;
	}
	
	SigHandler(int _num) : num(_num) {
		action.sa_handler = 0;
		sigemptyset(&action.sa_mask);
		action.sa_flags = 0;
		
		activated = false;
	}
	~SigHandler(void);
	
	int activate(void);
	int deactivate(void);
		
	void set_num(int _num) {
		num = _num;
	}
	
	void add_mask(int _num) {
		sigaddset(&action.sa_mask, _num);
	}
	
	void del_mask(int _num) {
		sigdelset(&action.sa_mask, _num);
	}
	
	bool test_mask(int _num) const {
		if (sigismember(&action.sa_mask, _num)) {
			return true;
		}
		return false;
	}
	
	void set_function(void (*function) (int)) {
		action.sa_handler = function;
	}
	
	void set_default(void) {
		action.sa_handler = SIG_DFL;
	}
	
	void set_ignore(void) {
		action.sa_handler = SIG_IGN;
	}
	
	void set_flags(int flags) {
		action.sa_flags = flags;
	}
	
	
	           
};

// ###################################################################

class SigFlags {
public:
	
	static bool flags[_NSIG];
	static bool initialized;
	
	static SigHandler handlers[_NSIG];
	
	// -----------------------------------

	static void generic_handler(int signum) {
		if (signum >= 0 && signum < _NSIG) {
			flags[signum] = true;
		}
	}
	
	static void core_dump_handler(int signum) {
		if (signum >= 0 && signum < _NSIG) {
			flags[signum] = true;
		}
		*((unsigned long*)1) = 0;
	}
	
	static void reset_all(void) {
		for (int i = 0; i < _NSIG; i++) {
			flags[i] = false;
		}
	}
	
	static void reset(int signum) {
		if (signum >= 0 && signum < _NSIG) {
			flags[signum] = false;
		}
	}
	
	// -----------------------------------
	
	SigFlags(void);
	~SigFlags(void) { }
	
};

// ###################################################################

// ###################################################################

#endif // SigHandler_h
