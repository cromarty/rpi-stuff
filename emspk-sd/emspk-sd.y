
%{

#include <stdio.h>

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
%token <number> QSPEECH
%token <number> NUM
%token <number> EOL
%token <number> SILENCE
%token <string> PUNCTLEVEL
%token <string> CTEXT
%token <number> LETTER
%token <number> FLUSH
%token <number> DISPATCH
%token <number> VERSION
%token <number> PLAYFILE
%token <number> TONE


%%

 /* rules */

commands : /* empty */ 
| commands command 
;

command : TTS_ALLCAPS_BEEP			{ printf("Called tts_allcaps_beep\n"); }
		| TTS_INITIALIZE					{ printf("Called tts_initialize\n"); }
		| TTS_PAUSE					{ printf("Called tts_pause\n"); }
		| TTS_RESET					{ printf("Called tts_reset\n"); }
		| TTS_RESUME					{ printf("Called tts_resume\n"); }
		| TTS_SAY CTEXT					{ printf("Called tts_say: %s\n", $2); }
		| TTS_SET_CHARACTER_SCALE NUM					{ printf("Called tts_set_character_scale: %d\n", $2); }
		| TTS_SET_PUNCTUATIONS PUNCTLEVEL					{ printf("Called tts_set_punctuations: %s\n", $2); }
		| TTS_SET_SPEECH_RATE NUM					{ printf("Called tts_set_speech_rate: %d\n", $2); }
		| TTS_SPLIT_CAPS					{ printf("Called tts_split_caps\n"); }
		| TTS_SYNC_STATE PUNCTLEVEL NUM NUM NUM NUM					{ printf("Called tts_sync_state: %s %d %d %d %d\n", $2, $3, $4, $5, $6); }
		| FLUSH					{ printf("Called flush\n"); }
		| SILENCE NUM					{ printf("Called silence: %d\n", $2); }
		| QSPEECH CTEXT					{ printf("Called q: %s\n", $2); }
		| LETTER CTEXT					{ printf("Called letter: %s\n", $2); }
		| DISPATCH					{ printf("Called dispatch\n"); }
		| TONE NUM NUM					{ printf("Called tone: %d %d\n", $2, $3); }
		| PLAYFILE CTEXT					{ printf("Called play file: %s\n", $2); }
		| VERSION					{ printf("Called version\n"); }
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

