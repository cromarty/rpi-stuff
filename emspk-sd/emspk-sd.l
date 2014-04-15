
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "emspk-sd.tab.h"
#include "emspk-sd.h"

extern sync_punct_level;
extern sync_dtk_caps_pitch_rise;
extern sync_dtk_allcaps_beep;
extern sync_dtk_split_caps;

%}

%x INBRACES


%%

"\n"				{ return EOL; }
[ \t]				{ /* eat whitespace */ }
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
[0-9]+				{ yylval.number = atoi(yytext); return NUM; }
<INBRACES>.*/\}\n	{ BEGIN(INITIAL); yylval.string = yytext; return CTEXT; } 
all		{ sync_punct_level = PUNCT_LEVEL_ALL; return PUNCTLEVEL; }
some		{ sync_punct_level = PUNCT_LEVEL_SOME; return PUNCTLEVEL; }
none		{ sync_punct_level = PUNCT_LEVEL_NONE; return PUNCTLEVEL; }
"sh"  { return SILENCE; }
"a" { return PLAYFILE; }
"d"   { return DISPATCH; }
"q"			{return QSPEECH; }
"s"  { return FLUSH; }
"t" { return TONE; }
"l"   { return LETTER; }
"version"			{ return VERSION; }

%%

