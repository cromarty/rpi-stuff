#ifndef EMSPK_SD_H
#define EMSPK_SD_H

#define NO_SYNC -1

#define PUNCT_LEVEL_NONE 0
#define PUNCT_LEVEL_SOME 1
#define PUNCT_LEVEL_ALL 2

int tts_sync_state(int, int, int, int, int);
int tts_set_speech_rate(int);
int tts_set_punctuations(int);
int tts_pause(void);
int tts_pause(void);
int tts_reset(void);
int tts_resume(void);
int tts_q(char*);
int tts_say(char*);




#endif




