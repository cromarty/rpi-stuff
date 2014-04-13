
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "emspk-sd.tab.h"

%}

%x INBRACES


%%

"tts_allcaps_beep"			{ return TTS_ALLCAPS_BEEP; }
"tts_capitalize"			{ return TTS_CAPITALIZE; }
"tts_initialize" { return TTS_INITIALIZE; }
"tts_pause"			{ return TTS_PAUSE; }
"tts_reset"			{ return TTS_RESET; }
"tts_resume"			{ return TTS_RESUME; }
"tts_say"			{ return TTS_SAY; }
"tts_set_character_scale"			{ return TTS_SET_CHARACTER_SCALE; }
"tts_set_punctuations"			{ return TTS_SET_PUNCTUATIONS; }
"tts_set_speech_rate"			{ return TTS_SET_SPEECH_RATE; }
"tts_split_caps"			{ return TTS_SPLIT_CAPS; }
"tts_sync_state"			{ return TTS_SYNC_STATE; }
"{"				{ BEGIN(INBRACES); }
"}"				{ BEGIN(INITIAL); }
[0-9]+				{ yylval = atoi(yytext); return NUM; }
"\n"				{ return EOL; }
[ \t]				{ /* eat whitespace */ }
<INBRACES>[^\n]*	{ yyless(yyleng-1); BEGIN(INITIAL); return CTEXT; } 
(all|some|none)		{ return PUNCTLEVEL; }
"sh"  { return SILENCE; }
"a" { return PLAYFILE; }
"d"   { return DISPATCH; }
"q"			{return QSPEECH; }
"s"  { return FLUSH; }
"t" { return TONE; }
"l"   { return LETTER; }
"version"			{ return VERSION; }

%%

