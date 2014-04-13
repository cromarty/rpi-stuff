%{

enum yytokens {
	TTS_ALLCAPS_BEEP				= 258,
	TTS_CAPITALIZE				= 259,
TTS_INITIALIZE = 260,
	TTS_PAUSE				= 261,
	TTS_RESET				= 262,
	TTS_RESUME				= 263,
	TTS_SAY				= 264,
	TTS_SET_CHARACTER_SCALE				= 265,
	TTS_SET_PUNCTUATIONS				= 266,
	TTS_SET_SPEECH_RATE				= 267,
	TTS_SPLIT_CAPS				= 268,
	TTS_SYNC_STATE				= 269,
	LEFTBRACE				= 270,
	RIGHTBRACE				= 271,
	NUMBER				= 272,
	NEWLINE				= 273,
	CTEXT = 274,
QSPEECH = 275,
SHUDDUP = 276,
LETTER = 277,
SILENCE = 278,
FLUSH = 279,
PUNCTLEVEL = 280,
};

int yylval;

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
"{"				{ BEGIN(INBRACES); return LEFTBRACE; }
"}"				{ BEGIN(INITIAL); return RIGHTBRACE; }
[0-9]+				{ yylval = atoi(yytext); return NUMBER; }
"\n"				{ return NEWLINE; }
[ \t]				{ /* Ignore whitespace */ }
<INBRACES>[^\n]*	{ yyless(yyleng-1); BEGIN(INITIAL); return CTEXT; } 
(all|some|none)		{ return PUNCTLEVEL; }
"sh"  { return SILENCE; }
"d"   { return FLUSH; }
"q"			{return QSPEECH; }
"s"  { return SHUDDUP; }
"l"   { return LETTER; }

%%

main(int argc, char **argv) 
{


 int tok;

 while(tok = yylex()) { 
printf("%d %s", tok, yytext); 
if(tok == NUMBER) 
printf(" = %d\n", yylval); 
else 
printf("\n");


 } 
} 




