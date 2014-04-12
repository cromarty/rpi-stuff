#ifndef EMSPK_SD_H
#define EMSPK_SD_H

/*
* CA prefixed defines are placemarkers for args to tts commands which have arguments.
*
* For example CA_SYNC_STATE_PUNC_LEVEL is the first argument to tts_sync_state and so has a value of zero
*/

#define CA_SYNC_STATE_PUNC_LEVEL 0
#define CA_SYNC_STATE_CAP_PITCH_RISE 1
#define CA_SYNC_STATE_CAP_TICK 2
#define CA_SYNC_STATE_CAP_SPLIT 3
#define CA_SYNC_STATE_SPEECH_RATE 4
#define CA_SYNC_STATE_LAST_ARG 4

#define CA_TONE_PITCH 0
#define CA_TONE_DURATION 1
#define CA_TONE_LAST_ARG 1


void sync_state_flags(char*);
void tone_args(char*);


#endif


