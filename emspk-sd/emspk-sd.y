
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
%token <number> TTS_PAUSE
%token <number> TTS_RESET
%token <number> TTS_RESUME
%token <number> TTS_SAY
%token <number> TTS_SET_CHARACTER_SCALE
%token <number> TTS_SET_PUNCTUATIONS
%token <number> TTS_SET_SPEECH_RATE
%token <number> TTS_SPLIT_CAPS
%token <number> TTS_SYNC_STATE
%token <number> LEFTBRACE
%token <number> RIGHTBRACE
%token <number> NUMBER
%token <number> NEWLINE
%token <number> SHUDDUP
%token <number> SILENCE

%%

 /* rules */

commands : /* empty */ 
| commands command 
;

command :
| TTS_ALLCAPS_BEEP 
| TTS_CAPITALIZE
| TTS_PAUSE
| TTS_RESET
| TTS_RESUME
| TTS_
;


%%


