
#ifndef StopWatch_h
#define StopWatch_h

#ifdef __GNUG__
#pragma interface
#endif

#include <sys/time.h>
#include <time.h>

class StopWatch {
protected:
	
	struct timeval timev1;
	struct timeval timev2;
	struct timezone tzdummy;

public:
	
	void start(void) {
		gettimeofday(&timev1, &tzdummy);
	}
	
	void set_to_past(long seconds) {
		timev1.tv_sec -=  seconds;
	}
	
	long stop(void) {
		gettimeofday(&timev2, &tzdummy);
		long sec = timev2.tv_sec - timev1.tv_sec;
		if (sec < 0) sec += 24*60*60;
		
		long us = (timev2.tv_usec - timev1.tv_usec + 500) / 1000;
		
		return 1000 * sec + us;
	}

	long stop_us(void) {
		gettimeofday(&timev2, &tzdummy);
		long sec = timev2.tv_sec - timev1.tv_sec;
		if (sec < 0) sec += 24*60*60;
		
		long us = (timev2.tv_usec - timev1.tv_usec);
		
		return 1000000 * sec + us;
	}
	
	long restart(void) {
		gettimeofday(&timev2, &tzdummy);
		long sec = timev2.tv_sec - timev1.tv_sec;
		if (sec < 0) sec += 24*60*60;
		
		long us = (timev2.tv_usec - timev1.tv_usec + 500) / 1000;
		long res = 1000 * sec + us;
		
		timev1 = timev2;
		
		return res;
	}

	long restart_us(void) {
		gettimeofday(&timev2, &tzdummy);
		long sec = timev2.tv_sec - timev1.tv_sec;
		if (sec < 0) sec += 24*60*60;
		
		long us = (timev2.tv_usec - timev1.tv_usec + 500);
		long res = 1000000 * sec + us;
		
		timev1 = timev2;
		
		return res;
	}
	
	StopWatch(void) {
		start();
	}

	StopWatch(const StopWatch & rv) {
		timev1 = rv.timev1;
	}
	
	StopWatch & operator=(const StopWatch & rv) {
		timev1 = rv.timev1;
		return *this;
	}
};


#endif // StopWatch_h

