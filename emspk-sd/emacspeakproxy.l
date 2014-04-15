
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
 * $Id: emspk-sd.l
 */

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "emacspeakproxy.tab.h"
#include "emacspeakproxy.h"

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
"c"			{ return CODE; }
"d"   { return DISPATCH; }
"q"			{return QSPEECH; }
"s"  { return FLUSH; }
"t" { return TONE; }
"l"   { return LETTER; }
"version"			{ return VERSION; }

%%
