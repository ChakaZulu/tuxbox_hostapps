// vim:ts=4:ai:sc:
// MPEG2 remuxer written by Peter Niemayer.
// stripped to what is needed by mcrec by Wolfgang Breyha

/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by 
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; see the file COPYING.  If not, write to
* the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/


#include "Remuxer.h"

#include <stdio.h>
#include <math.h>

#if DEBUG_RESYNC_DROPS
 #include <time.h>
#endif

// #################################################################################

#define DEBUG_RESYNC_DROPS 1

#define DEBUG_AV_DESYNC 0

// #################################################################################
//
// everything below takes some C++ knowledge to understand :-)
//
// ##################################################################################

extern bool debug;
extern bool ignore_sync;
extern FILE *logfile;
extern void logprintf(const char *fmt, ...);

const unsigned long known_audio_frame_sizes[] = {
//  MPG/192  AC3/5+1   MPG/64
      576,   896*2,     167
};

// ac3 tables by Aaron Holtzman - May 1999

struct ac3_frmsize_s
{
	unsigned short bit_rate;
	unsigned short frm_size[3];
};

static const struct ac3_frmsize_s ac3_frmsizecod_tbl[64] = 
{
	{ 32  ,{64   ,69   ,96   } },
	{ 32  ,{64   ,70   ,96   } },
	{ 40  ,{80   ,87   ,120  } },
	{ 40  ,{80   ,88   ,120  } },
	{ 48  ,{96   ,104  ,144  } },
	{ 48  ,{96   ,105  ,144  } },
	{ 56  ,{112  ,121  ,168  } },
	{ 56  ,{112  ,122  ,168  } },
	{ 64  ,{128  ,139  ,192  } },
	{ 64  ,{128  ,140  ,192  } },
	{ 80  ,{160  ,174  ,240  } },
	{ 80  ,{160  ,175  ,240  } },
	{ 96  ,{192  ,208  ,288  } },
	{ 96  ,{192  ,209  ,288  } },
	{ 112 ,{224  ,243  ,336  } },
	{ 112 ,{224  ,244  ,336  } },
	{ 128 ,{256  ,278  ,384  } },
	{ 128 ,{256  ,279  ,384  } },
	{ 160 ,{320  ,348  ,480  } },
	{ 160 ,{320  ,349  ,480  } },
	{ 192 ,{384  ,417  ,576  } },
	{ 192 ,{384  ,418  ,576  } },
	{ 224 ,{448  ,487  ,672  } },
	{ 224 ,{448  ,488  ,672  } },
	{ 256 ,{512  ,557  ,768  } },
	{ 256 ,{512  ,558  ,768  } },
	{ 320 ,{640  ,696  ,960  } },
	{ 320 ,{640  ,697  ,960  } },
	{ 384 ,{768  ,835  ,1152 } },
	{ 384 ,{768  ,836  ,1152 } },
	{ 448 ,{896  ,975  ,1344 } },
	{ 448 ,{896  ,976  ,1344 } },
	{ 512 ,{1024 ,1114 ,1536 } },
	{ 512 ,{1024 ,1115 ,1536 } },
	{ 576 ,{1152 ,1253 ,1728 } },
	{ 576 ,{1152 ,1254 ,1728 } },
	{ 640 ,{1280 ,1393 ,1920 } },
	{ 640 ,{1280 ,1394 ,1920 } }
};


// ############################################################################

static int find_next_pes_packet(unsigned char * data, unsigned long valid,
                                unsigned long & pes_start, unsigned long & pes_len) {
	
	// pes_len will be == 0 if no packet is found or ready yet
	pes_len = 0;
	
	// pes_start will be either the start of the found packet or
	// a pointer to the first non-junk byte in the buffer.
	// In any case, the caller may discard the bytes from 
	// "data" to "data+pes_start+pes_len"
	// after considering the packet
	
	
	// ------------------------------------
	// find start of next PES packet
	
	pes_start = 0;
		
search_again:	
	
	if (valid < 4) return 0;
	
	for (; pes_start < valid-3; pes_start++) {
		if (   data[pes_start]   == 0x00
		    && data[pes_start+1] == 0x00
			 && data[pes_start+2] == 0x01
			) {
			break;
		}
	}
	
	if (pes_start >= valid-3) {
		return 0;
	}
	
	// forget about data before first header
	
	unsigned char * a = data + pes_start;
	valid -= pes_start;
	
	// check for PES header validity

	if (valid < 6) {
		// ok, just not enough data, yet
		return 0;
	}
	
	unsigned char  stream_id  = a[3];
	unsigned long packet_len = pes_size(a);
	
	if (valid < packet_len) {
		// ok, just not enough data, yet
		return 0;
	}
	
	// ok, the whole PES packet is available in abuf
	
	if (   stream_id == STREAM_PRIVATE_2
	    || stream_id == STREAM_PADDING
		) {

		// ok, the rest of the packet is just data
		
		pes_len = packet_len;
		return 0;
	}
	
	if ( (a[6] & 0xc0) != 0x80) {
		// hmmm.. header looks invalid...
		pes_start += 1;
		goto search_again;
	}
	
	pes_len = packet_len;
	
	return 0;
}

// ##################################################################

int Remuxer::create_audio_pes(unsigned char * orig_pes, double duration) {
	


	// cut one audio PES in pieces so each fits into one program pack

	unsigned long   orig_pes_size = pes_size(orig_pes);
	unsigned long   orig_opt_header_size = orig_pes[8];
	unsigned long   orig_es_size = orig_pes_size - 9 - orig_opt_header_size;
	unsigned char * orig_es_data = orig_pes + 9 + orig_opt_header_size;
	double          orig_pts = pes_pts(orig_pes);

	
	unsigned long es_left   = orig_es_size;
	unsigned char * es_data = orig_es_data;
	
	
	                                             // pp   pes  header
	unsigned long max_audio_per_pes = max_out_pp - (14 + 9+5); // better not create bigger PES packets
	
	unsigned long wanted_audio_per_pes = max_audio_per_pes;
	
	// try to find a better wanted_audio_per_pes by trying known dividers
	static unsigned long last_audio_frame_size = ~0;
	unsigned long audio_frame_size = 0;
	
	for (unsigned int i = 0; i < sizeof(known_audio_frame_sizes)/sizeof(unsigned long); i++) {
		if (orig_es_size % known_audio_frame_sizes[i] == 0) {
			audio_frame_size = known_audio_frame_sizes[i];
			wanted_audio_per_pes = (max_audio_per_pes / audio_frame_size) * audio_frame_size;
		}
	}
	
	if (audio_frame_size != last_audio_frame_size) {
		last_audio_frame_size = audio_frame_size;
		fprintf(stderr,"detected audio frame size: %ld. ES data size: %ld                  \n",
		        audio_frame_size, orig_es_size);
	}
	
	unsigned long peses = 0;	
	
	bool stamp = true;
	
	bool a_seq_start = true; // we better remember whether this was the first part of an audio PES
	
	while (es_left) {
		
		unsigned long pes_payload = es_left;
		if (pes_payload > wanted_audio_per_pes) {
			pes_payload = wanted_audio_per_pes;
		}
		
		if (audio_packets_avail >= max_audio_packets) {
			fprintf(stderr, "audio_packets buffer overrun, dropping some data\n");			
			remove_audio_packets(1);
		}
		
		unsigned long total_len = 9 + ((stamp)? 5 : 0) + pes_payload;
		
		// create packet in a newly allocated memory buffer...
		unsigned char * ap = new unsigned char[total_len];
		audio_packets[audio_packets_avail] = ap;
		audio_packets_avail += 1;
		
		ap[0] = 0x00;
		ap[1] = 0x00;
		ap[2] = 0x01;
		ap[3] = orig_pes[3];
		ap[4] = ((total_len - 6) >> 8) & 0xff;
		ap[5] = (total_len - 6) & 0xff;
		ap[6] = 0x80 | ((a_seq_start)? 0x01 : 0x00); // dirty: we mark the a_seq_start this way...
		//a_seq_start = false;
		
		if (stamp) {
			//stamp = false;

			unsigned long long pts64 = (unsigned long long)orig_pts;
			double part_done = 1.0 - (((double)es_left)/((double)orig_es_size));
			pts64 += (unsigned long long)(part_done * duration);
			
			ap[7] = 0x80; // PTS, only
			ap[8] = 0x05; // 5 bytes for the PTS
			
			ap[9]  = 0x20 | ((pts64 & 0x1c0000000ULL) >> 29) | 0x01;
			ap[10] =        ((pts64 & 0x03fc00000ULL) >> 22)       ;
			ap[11] =        ((pts64 & 0x0003f8000ULL) >> 14) | 0x01;
			ap[12] =        ((pts64 & 0x000007f80ULL) >>  7)       ;
			ap[13] =        ((pts64 & 0x00000007fULL) <<  1) | 0x01;
			ap += 14;
			
		} else {
			
			ap[7] = 0x00; // no PTS
			ap[8] = 0x00; //
			ap += 9;
		}
		
		memcpy(ap, es_data, pes_payload);
		
		es_data += pes_payload;
		es_left -= pes_payload;
		
		peses += 1;
		
	}
	
	//fprintf(stderr,"created %ld PESes from 1 original audio PES\n",
	//        peses);
	
	return 0;
}

// ##################################################################


bool Remuxer::audio_packet_wanted(unsigned char * pes) {
	
	if (wanted_audio_stream == 0) {
		// make a guess: just take the first type of audio stream we find...
		
		if (   pes[3] == STREAM_PRIVATE_1
		    || pes[3] == STREAM_AUDIO
		    || pes[3] == STREAM_REST_AUDIO
		    || pes[3] == 0xc1 // EuroNews uses this...
		   ) {
			
			wanted_audio_stream = pes[3];
		}
	}
	
	if (pes[3] == wanted_audio_stream) {
		return true;
	}

	// PES packet did not belong to the stream we wanted..
	//fprintf(stderr, "found PES packet of unwanted stream_id 0x%02x\n", pes[3]);
	
	return false;
		

/*	
	if (audio_packets_avail >= max_audio_packets) {
		fprintf(stderr, "audio_packets buffer overrun, dropping some data\n");

		remove_audio_packets(1);
	}

	// copy packet to a newly allocated memory buffer...
	audio_packets[audio_packets_avail] = new unsigned char[len];
	memcpy(audio_packets[audio_packets_avail], pes, len);
	audio_packets_avail += 1;
	
	
return 0;	
	
	// ---------------------------------------------------------------
	
	// now check if the audio_packet before the current one was
	// AC3, and break it into pieces if needed...
	
	if (audio_packets_avail <= 1) {
		return 0; // no audio packet before this one...
	}
	
	unsigned char * a1 = audio_packets[audio_packets_avail-2];
	
	if (a1[3] != STREAM_PRIVATE_1) {
		return 0; // probably not AC-3, no need to do anything
	}
	
	unsigned char * a2 = audio_packets[audio_packets_avail-1];
	
	double a1_pts = pes_pts(a1);
	
	double a1_duration = pts_diff(pes_pts(a2), a1_pts);
	
	if (a1_duration < 0.0) {
		// cannot determine duration...
		return 0;
	}

	unsigned long   a1_size = pes_size(a1);
	unsigned long   a1_opt_header_size = a1[8];
	unsigned long   a1_es_size = a1_size - 9 - a1_opt_header_size;
	unsigned char * a1_data = a1 + 9 + a1_opt_header_size;
	
	if (a1_es_size < 5 || a1_data[0] != 0x0b || a1_data[1] != 0x77) {
		// hmmm.. doesn't look like AC3... we better leave it...
		return 0;
	}
	
	
	// ---------------------------------------------------------------
	
	// ok, break down the old packet...
	audio_packets_avail -= 2; // take away a1 and a2 from audio packets
	
	
	unsigned long es_left = a1_es_size;
	unsigned char * acd = a1_data;
	unsigned long sub_pes_cnt = 0;
	
	while (es_left) {
		// find out some more information on the AC3 frame

		unsigned long tmp = (acd[2] << 16) | (acd[3] << 8) | acd[4];

		int fscod = (tmp >> 6) & 0x3;

		unsigned long sampling_rate = 0;
		switch (fscod) {
			case 0: sampling_rate = 48000; break;
			case 1: sampling_rate = 44100; break;
			case 2: sampling_rate = 32000; break;
		}

		int frmsizecod = tmp & 0x3f;

		unsigned long frame_size = ac3_frmsizecod_tbl[frmsizecod].frm_size[fscod];

		// unsigned long bit_rate = ac3_frmsizecod_tbl[frmsizecod].bit_rate;
		
		unsigned long frame_bytes = frame_size * 2;
		
		
		// create a new PES packet

		if (audio_packets_avail >= max_audio_packets) {
			fprintf(stderr, "audio_packets buffer overrun, dropping some data\n");
			remove_audio_packets(1);
		}
		
		sub_pes_cnt	+= 1;
		
		unsigned long total_len = 9 + 5 + 4 + frame_bytes;	
		
		unsigned char * ap = new unsigned char[total_len];
		audio_packets[audio_packets_avail] = ap;
		audio_packets_avail += 1;
		
		ap[0] = 0x00;
		ap[1] = 0x00;
		ap[2] = 0x01;
		ap[3] = a1[3];
		ap[4] = ((total_len - 6) >> 8) & 0xff;
		ap[5] = (total_len - 6) & 0xff;
		ap[6] = 0x80;
		
		ap[7] = 0x80; // PTS, only
		ap[8] = 0x05; // 5 bytes for the PTS

		// PTS at 9 to 13 will be set after the loop...
		
		ap[14] = 0x80; // sub-stream ID
		ap[15] = 0x02; // unknown
		ap[16] = 0x00; // unknown
		ap[17] = 0x01; // unknown
		
		memcpy(ap + 18, acd, frame_bytes);
		
		
		
		acd += frame_bytes;
		es_left -= frame_bytes;
		
		if (es_left == 0) break; // nice!
		
		if (es_left < 5 || acd[0] != 0x0b || acd[1] != 0x77) {
			// hmmm.. doesn't look like AC3... 
			fprintf(stderr, "found unexpected non-AC3 data in PES packet\n");
			break;
		}
		
	}
	
	// forget about the old packet
	
	delete [] a1;
	
	if (sub_pes_cnt) {
		
		double acframe_duration = a1_duration / ((double)sub_pes_cnt);

		// set PTS for the generated PES packets
		for (unsigned long i = audio_packets_avail - sub_pes_cnt; i < audio_packets_avail; i++) {

			set_pes_pts(audio_packets[i], a1_pts);

			a1_pts += acframe_duration;
		}
	}
	
	fprintf(stderr,"created %ld AC3 pes\n", sub_pes_cnt);
	
	// ---------------------------------------------------------------

	// add a2 again...

	if (audio_packets_avail >= max_audio_packets) {
		fprintf(stderr, "audio_packets buffer overrun, dropping some data\n");
		remove_audio_packets(1);
	}
	
	audio_packets[audio_packets_avail] = a2;
	audio_packets_avail += 1;		


	
	
	return 0;

*/
}

// ##################################################################

int Remuxer::supply_audio_data(void * data, unsigned long len) {
	
		
	if (abuf_valid + len > abuf_size) {
		fprintf(stderr, "abuf overrun, dropping some data\n");
		abuf_valid = 0;
		if (len > abuf_size) {
			len = abuf_size;
		}
	}
	
	memcpy(abuf+abuf_valid, data, len);
	abuf_valid += len;
	
	// work on as many PES packets as may be available now
	unsigned long offset = 0;
	while (offset < abuf_valid) {
		
		unsigned long  pes_start;
		unsigned long pes_len;
		
		find_next_pes_packet(abuf+offset, abuf_valid-offset,
                           pes_start, pes_len);
		
		if (!pes_len) {
			// no packet found...
			
			offset += pes_start;
			break;
		}			
		
		
		unsigned char * pes_packet = abuf + offset + pes_start; // what we just found

		if (pes_start + pes_len > abuf_valid-offset) { *((long *)0) = 0; }


		if (audio_packet_wanted(pes_packet)) {

			// now find a second packet, we need it to compute the first packets
			// duration...

			unsigned long off2 = offset+pes_start+pes_len;
			unsigned char * ap2 = 0;

			while (off2 < abuf_valid) {
				unsigned long ap2_start;
				unsigned long ap2_len;
				
				find_next_pes_packet(abuf+off2, abuf_valid-off2, ap2_start, ap2_len);
				
				if (!ap2_len) {
					break;
				}
				
				unsigned char * p2 = abuf + off2 + ap2_start;
				if (audio_packet_wanted(p2)) {
					ap2 = p2;
					break;
				}
								
				off2 += ap2_start + ap2_len;
			}

			if (ap2) {
				// we found a second packet, so we can compute the duration
				double duration = pts_diff(pes_pts(ap2), pes_pts(pes_packet));
				create_audio_pes(pes_packet, duration);

			} else {
				// as there's no second audio packet, we can leave the loop
				// and wait for more audio data...
				offset += pes_start;
				break;
			}
		}

		// current pes was consumed/ignored...
		offset += pes_start + pes_len; // where to start searching for the next packet			
	}

	// move the remainder of the data in place for our next call...
	memmove(abuf, abuf+offset, abuf_valid-offset);
	abuf_valid -= offset;
	
	return 0;
}

// ############################################################################

int Remuxer::write_mpp(FILE * mppfile) {
	
	for (unsigned long i = 0; i < audio_packets_avail; i++) {
		
		unsigned char * orig_pes = audio_packets[i];
		
		unsigned long   orig_pes_size = pes_size(orig_pes);
		unsigned long   orig_opt_header_size = orig_pes[8];
		unsigned long   orig_es_size = orig_pes_size - 9 - orig_opt_header_size;
		unsigned char * orig_es_data = orig_pes + 9 + orig_opt_header_size;
		
		if (!mpp_started) {
			
			// make sure to start with a magic sync word...
			
			// MPEG audio
			if (orig_es_size < 4 || orig_es_data[0] != 0xff || orig_es_data[1] != 0xfd ||
			    orig_es_data[2] != 0xa0 )
			{
				return 0;
			}
			
			playtime_offset += pts_diff(system_clock_ref, system_clock_ref_start);	
			logprintf("start recording...                            \n");
			mpp_started = true;
			if (debug)
			{
				logprintf("data: ");
				for (unsigned int i = 0; i < orig_es_size; i++)
					logprintf("%02x", orig_es_data[i]);
				logprintf("\n");
			}
		}
		else
		{
			// MPEG audio
			if (orig_es_size >= 4 && orig_es_data[0] == 0xff && orig_es_data[1] == 0xfd &&
				orig_es_data[2] == 0xa0 )
			{
				if (!ignore_sync)
				{
					logprintf ("\nMPEG_Audio sync found...                             \n");
					if (debug)
					{
						logprintf("data: ");
						for (unsigned int i = 0; i < orig_es_size; i++)
							logprintf("%02x", orig_es_data[i]);
						logprintf("\n");
					}
					audioresync = true;
					mpp_started = false;
					return -2;
				}
				else
					logprintf("sync ignored!\n");
			}
		}
				
		if (1 != fwrite(orig_es_data, orig_es_size, 1, mppfile)) {
			fprintf(stderr, "\nerror while writing to .mpp output file\n");
			return -1;
		}
	}
	
	return 0;
}

