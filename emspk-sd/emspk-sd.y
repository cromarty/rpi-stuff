
/*
 *
 * Copyright (C) 2014 Mike Ray <mike.ray.1964@gmail.com>
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this package; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
 * $Id: emspk-sd.y
 */

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <speech-dispatcher/libspeechd.h>


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
%token <number> CODE

%%

 /* rules */

commands : /* empty */ 
| commands command 
;

command : EOL { /* do nothing */ }
			| TTS_ALLCAPS_BEEP			{ tts_allcaps_beep(); }
		| TTS_INITIALIZE					{ tts_initialize(); }
		| TTS_PAUSE					{ tts_pause(); }
		| TTS_RESET					{ tts_reset(); }
		| TTS_RESUME					{ tts_resume(); }
		| TTS_SAY CTEXT					{ tts_say($2); }
		| TTS_SET_CHARACTER_SCALE NUM					{ tts_set_character_scale($2); }
		| TTS_SET_PUNCTUATIONS identifier					{ tts_set_punctuations(sync_punct_level); }
		| TTS_SET_SPEECH_RATE NUM					{ tts_set_speech_rate($2); }
		| TTS_SPLIT_CAPS					{ tts_split_caps(); }
		| TTS_SYNC_STATE identifier NUM NUM NUM NUM 
				{
					sync_dtk_caps_pitch_rise = $3;
					sync_dtk_allcaps_beep = $4;
					sync_dtk_split_caps = $5;
					sync_speech_rate = $6;
					tts_sync_state(sync_punct_level, sync_dtk_caps_pitch_rise, sync_dtk_allcaps_beep, sync_dtk_split_caps, sync_speech_rate);
				}
		| FLUSH					{ tts_flush(); }
		| SILENCE NUM					{ tts_silence($2); }
		| QSPEECH CTEXT					{ tts_q($2); }
		| LETTER CTEXT					{ tts_letter($2); }
		| DISPATCH					{ tts_dispatch(); }
		| TONE NUM NUM					{ tts_tone($2, $3); }
		| PLAYFILE CTEXT					{ tts_play_file($2); }
		| VERSION					{ tts_version(); }
		| CODE CTEXT			{ tts_code($2); }
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


/* called when we get tts_all_caps_beep */
int tts_allcaps_beep(void)
{
	printf("Called tts_allcaps_beep\n");
	return 0;
} /* end tts_allcaps_beep */

/* called when we get a tts_set_character_scale */
int tts_set_character_scale(int scale)
{
	printf("Called tts_set_character_scale: %d\n", scale);
	return 0;
} /* end tts_set_character_scale */

/* called when we get a tts_split_caps */
int tts_split_caps(int split)
{
	printf("Called tts_split_caps: %d\n", split);
	return 0;
} /* end tts_split_caps */

/* called when we get a 'tts_sync_state command */
int tts_sync_state(
		int punct_level,
		int pitch_rise,
		int caps_beep,
		int split_caps,
		int speech_rate)
{
		printf("Called Sync state: %d %d %d %d %d\n", punct_level, pitch_rise, caps_beep, split_caps, speech_rate);
		return 0;
} /* end tts_sync_state */

/* called to set the speech rate */
int tts_set_speech_rate(int speech_rate)
{
		printf("Called tts_set_speech_rate: %d\n", speech_rate);
	return 0;
} /* end tts_set_speech_rate */

/* called to set punctuation to 'all', 'some' or 'none' */
int tts_set_punctuations(int punct_level)
{
		printf("Called set punct level: %d\n", punct_level);
		return 0;
} /* end tts_set_punctuations */

/* initialize the speech engine */
int tts_initialize(void)
{
		printf("Called initialize\n");
	return 0;
} /* end tts_initialize */

/* pause speech but do not flush the queue */
int tts_pause(void)
{
		printf("Called pause\n");
		return 0;
} /* end tts_pause */

/* reset? */
int tts_reset(void)
{
		printf("Called reset\n");
		return 0;
} /* end tts_reset */

/* resume speaking the contents of the queue after a non-flushing pause */
int tts_resume(void)
{
		printf("Called resume\n");
		return 0;
} /* end tts_resume */

/* queue a chunk of text for synthesis */
int tts_q(char *text)
{
		printf("Called q to queue text: %s\n", text);
		return 0;
} /* end tts_q */

/* immediately say the string of text */
int tts_say(char *text)
{
		printf("Called tts_say: %s\n", text);
		return 0;
} /* end tts_say */

/* the dispatch function, called in response to a 'd' which is intended 
* to dispatch queued text for tts
*/
int tts_dispatch(void)
{
		printf("Called dispatch function\n");
		return 0;
} /* end tts_dispatch */

/* silence function.  called to queue a chunk of silence */
int tts_silence(int duration_milliseconds)
{
		printf("Called silence: %d\n", duration_milliseconds);
		return 0;
} /* end tts_silence */

/* play a tone of pitch and duration */
int tts_tone(int pitch, int duration)
{
		printf("Called tone function: %d %d\n", pitch, duration);
		return 0;
} /* end tts_tone */

/* flush the queue and shut up */
int tts_flush(void)
{
		printf("Called flush function\n");
		return 0;
} /* end tts_flush */

/* say a single character */
int tts_letter(char *c)
{
		printf("Called tts_letter\n");
			return 0;
} /* end tts_letter */

/* called to play a wav file */
int tts_play_file(char *filename)
{
		printf("Called tts_play_file: %s\n", filename);
		return 0;
} /* end tts_play_file */

int tts_version(void)
{
		printf("Called tts_version\n");
		return 0;
} /* end tts_version */

int tts_code(char *code)
{
		printf("Called tts_code: %s\n", code);
		return 0;
}



