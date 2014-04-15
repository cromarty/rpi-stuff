
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "emspk-sd.h"

int sync_punct_level;

int sync_dtk_caps_pitch_rise;
int sync_dtk_allcaps_beep;
int sync_dtk_split_caps;

int sync_speech_rate;

 


%}

%union 
{
        int number;
        char *string;
}

%token <number> TTS_ALLCAPS_BEEP
%token <number> TTS_CAPITALIZE
%token <number> TTS_INITIALIZE
%token <number> TTS_PAUSE
%token <number> TTS_RESET
%token <number> TTS_RESUME
%token <number> TTS_SAY
%token <number> TTS_SET_CHARACTER_SCALE
%token <number> TTS_SET_PUNCTUATIONS
%token <number> TTS_SET_SPEECH_RATE
%token <number> TTS_SPLIT_CAPS
%token <number> TTS_SYNC_STATE
%token <string> NAME
%token <number> QSPEECH
%token <number> NUM
%token <number> EOL
%token <number> SILENCE
%token <string> CTEXT
%token <number> LETTER
%token <number> FLUSH
%token <number> DISPATCH
%token <number> VERSION
%token <number> PLAYFILE
%token <number> TONE
%token <number> PUNCTLEVEL
%token <number> LANGUAGE
%token <number> VOICE


%%

 /* rules */

commands : /* empty */ 
| commands command 
;

command : EOL { /* nothing */ }
			| TTS_ALLCAPS_BEEP			{ printf("Called tts_allcaps_beep\n"); }
		| TTS_INITIALIZE					{ printf("Called tts_initialize\n"); }
		| TTS_PAUSE					{ printf("Called tts_pause\n"); }
		| TTS_RESET					{ printf("Called tts_reset\n"); }
		| TTS_RESUME					{ printf("Called tts_resume\n"); }
		| TTS_SAY CTEXT					{ tts_say($2); }
		| TTS_SET_CHARACTER_SCALE NUM					{ printf("Called tts_set_character_scale: %d\n", $2); }
		| TTS_SET_PUNCTUATIONS identifier					{ tts_set_punctuations(sync_punct_level); }
		| TTS_SET_SPEECH_RATE NUM					{ tts_set_speech_rate($2); }
		| TTS_SPLIT_CAPS					{ printf("Called tts_split_caps\n"); }
		| TTS_SYNC_STATE identifier NUM NUM NUM NUM 
	{
		sync_dtk_caps_pitch_rise = $3;
		sync_dtk_allcaps_beep = $4;
		sync_dtk_split_caps = $5;
		sync_speech_rate = $6;
		sync_state(sync_punct_level, sync_dtk_caps_pitch_rise, sync_dtk_allcaps_beep, sync_dtk_split_caps, sync_speech_rate);
 	}
		| FLUSH					{ printf("Called flush\n"); }
		| SILENCE NUM					{ printf("Called silence: %d\n", $2); }
		| QSPEECH CTEXT					{ tts_q($2); }
		| LETTER CTEXT					{ printf("Called letter: %s\n", $2); }
		| DISPATCH					{ printf("Called dispatch\n"); }
		| TONE NUM NUM					{ printf("Called tone: %d %d\n", $2, $3); }
		| PLAYFILE CTEXT					{ printf("Called play file: %s\n", $2); }
		| VERSION					{ printf("Called version\n"); }
;

identifier : PUNCTLEVEL
| LANGUAGE
| VOICE
;


%%

main(int argc, char **argv) 
{

	yyparse(); 

} 

yyerror(char *s) 
{ 
	fprintf(stderr, "error: %s\n", s); 
} 


/* called when we get a 'tts_sync_state command */
int sync_state(
		int punct_level,
		int pitch_rise,
		int caps_beep,
		int split_caps,
		int speech_rate)
{
		printf("Sync state: %d %d %d %d %d\n", punct_level, pitch_rise, caps_beep, split_caps, speech_rate);
		return 0;
}

int tts_set_speech_rate(int speech_rate)
{
		printf("Got a tts_set_speech_rate: %d\n", speech_rate);
	return 0;
}


int tts_set_punctuations(int punct_level)
{
		printf("Called set punct level: %d\n", punct_level);
		return 0;
}



int tts_initialize(void)
{
		printf("Called initialize\n");
	return 0;
}

int tts_pause(void)
{
		printf("Called pause\n");
		return 0;
}

int tts_reset(void)
{
		printf("Called reset\n");
		return 0;
}

int tts_resume(void)
{
		printf("Called resume\n");
		return 0;
}

int tts_q(char *text)
{
		printf("Called q to queue text: %s\n", text);
		return 0;
}

int tts_say(char *text)
{
		printf("Called tts_say: %s\n", text);
		return 0;
}

/* the dispatch function, called in response to a 'd' which is intended 
* to dispatch queued text for tts
*/
int tts_dispatch(void)
{
		printf("Called dispatch function\n");
		return 0;
}

/* silence function.  called to queue a chunk of silence */
int tts_silence(int duration_milliseconds)
{
		printf("Called silence\n");
		return 0;
}

int tts_tone(int pitch, int duration)
{
		printf("Called tone function\n");
		return 0;
}

int tts_flush(void)
{
		printf("Called flush function\n");
		return 0;
}

/* say a single character */
int tts_letter(char c)
{
		printf("Called tts_letter\n");
			return 0;
}




