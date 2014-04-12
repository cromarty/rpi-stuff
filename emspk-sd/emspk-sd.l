/*

Flex lexer which implements an Emacspeak to speech-dispatcher connector 
by parsing the Emacspeak protocol read from *stdin and calling 
speech-dispatcher via it's API

*/

%{

#include <stdio.h>
#include <stdlib.h>

#include "emspk-sd.h"


int nArg;

%}


%x TTS_SET_PUNCTUATIONS QCMD TCMD TTS_SET_CHARACTER_SCALE TTS_SYNC_STATE TTS_SPLIT_CAPS IBRACES TTS_SET_SPEECH_RATE LCMD TTS_CAPITALIZE QBRACES CSH TTS_ALLCAPS_BEEP ISAY


%%

 /* queue command */
<INITIAL>"q"			{ 
					BEGIN(QCMD);
					printf("Entered QCMD\n");
		}

<QCMD>"{"			{
					BEGIN(QBRACES);
					printf("Entering QBRACES\n");
		}

<QBRACES>[^}]*			{
					printf("Data: %s\n", yytext);
		}

<QBRACES>"}"			{
					BEGIN(INITIAL); printf("Exiting INBRACES\n");
		}  

 /* letter command */ 
<INITIAL>"l"			{
					BEGIN(LCMD);
					printf("Entered LCMD\n");
		}

<LCMD>[^ \t\n]			{
					BEGIN(INITIAL);
					printf("Letter data: %s\n", yytext);
		}

 /* tts_* commands  with args */

 /* tts_sync_state */
<INITIAL>"tts_sync_state"			{
					BEGIN(TTS_SYNC_STATE);
					printf("sync state\n");
					nArg = 0;
		}

<TTS_SYNC_STATE>(all|some|none)			{
					sync_state_flags(yytext);
		}

<TTS_SYNC_STATE>[0-9]+			{
					sync_state_flags(yytext);
		} 

<TTS_SYNC_STATE>"\n"			{
					BEGIN(INITIAL);
		}
 
 /* set punctuation mode */
<INITIAL>"tts_set_punctuations"			{
					BEGIN(TTS_SET_PUNCTUATIONS);
					printf("Found set punct mode\n");
		}

<TTS_SET_PUNCTUATIONS>(all|some|none)			{
					printf("found the mode to set punctuation to: %s\n", yytext);
		}

<TTS_SET_PUNCTUATIONS>"\n"			{
					BEGIN(INITIAL);
		}

 /* set speech rate */
<INITIAL>"tts_set_speech_rate"			{
					BEGIN(TTS_SET_SPEECH_RATE);
					printf("Found set speech rate\n");
		}

<TTS_SET_SPEECH_RATE>[0-9]+			{
					printf("Found the rate to set the speeech\n");
		}

<TTS_SET_SPEECH_RATE>"\n"			{
					BEGIN(INITIAL);
		}

 /* set scale factor */
<INITIAL>"tts_set_character_scale"			{
					BEGIN(TTS_SET_CHARACTER_SCALE);
		}

<TTS_SET_CHARACTER_SCALE>[0-9]+			{
					printf("found the character scale factor\n");
		}

<TTS_SET_CHARACTER_SCALE>"\n"			{
					BEGIN(INITIAL);
		}

 /* say immediate */
<INITIAL>"tts_say"			{
					BEGIN(ISAY);
					printf("Entered ISAY\n");
		}

<ISAY>"{"			{
					BEGIN(IBRACES);
					printf("Entering IBRACES\n");
		}

<IBRACES>[^}]*			{
					printf("Data: %s\n", yytext);
		}

<IBRACES>"}"			{
					BEGIN(INITIAL);
					printf("Exiting INBRACES\n");
		}

 /* split cap (horrible 'capital' all the time */ 
<INITIAL>"tts_split_caps"			{
					BEGIN(TTS_SPLIT_CAPS);
					printf("Found split caps command\n");
		}

<TTS_SPLIT_CAPS>[0-9]			{
					printf("found split caps flag\n");
		}
		
<TTS_SPLIT_CAPS>"\n"			{
					BEGIN(INITIAL);
		}

 /* I think this is the tick thing */
<INITIAL>"tts_capitalize"			{
					BEGIN(TTS_CAPITALIZE);
		}

<TTS_CAPITALIZE>[0-9]			{
					printf("found the capitalize flag\n");
		}

<TTS_CAPITALIZE>"\n"			{
					BEGIN(INITIAL);
		}

 /* I think this beeps when an all caps word is spoken */
<INITIAL>"tts_allcaps_beep"			{
					BEGIN(TTS_ALLCAPS_BEEP);
		}

<TTS_ALLCAPS_BEEP>[0-9]			{
					printf("found the allcaps beep flag\n");
		}

<TTS_ALLCAPS_BEEP>"\n"			{
					BEGIN(INITIAL);
		}

 /* tts_* commands with no args */
<INITIAL>"tts_pause"			{
					printf("Found a pause\n");
		}

<INITIAL>"tts_resume"			{
					printf("Found a resume\n");
		}

<INITIAL>"tts_reset"			{
					printf("found a reset\n");
		}

<INITIAL>"tts_initialize"			{
					printf("found an initialize\n");
		}

 /* shut up! */
<INITIAL>"s"			{
					printf("found a shut up\n");
		}

 /* insert silence */
<INITIAL>"sh"			{
					BEGIN(CSH);
					printf("found silence command\n");
		}

<CSH>[0-9]+			{
					printf("found the duration of silence to insert\n");
		}

<CSH>"\n"			{
					BEGIN(INITIAL);
		}
 
 /* say version immediately */
<INITIAL>"version"			{
					printf("found a version command\n");
		}
  
 /* tone command */
<INITIAL>"t"			{
					BEGIN(TCMD); printf("found tone command\n"); nArg = 0;
		}

<TCMD>[0-9]+			{
					tone_args(yytext);
		}

<TCMD>"\n"			{
					BEGIN(INITIAL);
		}

 /* end of line */
\n			{ BEGIN(INITIAL); }

 /* nothing interesting */
. { }

%%

void sync_state_flags(char *token)
{
	switch(nArg)
	{
		case CA_SYNC_STATE_PUNC_LEVEL:
			case CA_SYNC_STAT_PITCH_RISE:
			nArg++;
			break;
		case CA_SYNC_STATE_CAP_TICK:
			printf("Its the capital tick thing\n");
			nArg++;
			break;
		case CA_SYNC_STATE_CAP_SPLIT:
				printf("Its the capital painful thing\n");
			nArg++;
			break;
		case CA_SYNC_STATE_SPEECH_RATE:
			printf("Its the speech rate\n");
			nArg++;
			break;
	}

	if (nArg < CA_SYNC_STATE_LAST_ARG)
		return;
	
	/* we have all args */
	return;

 }

void tone_args(char *token)
{
	static int tone_pitch;
	static int tone_duration;
	switch(nArg)
	{
		case CA_TONE_PITCH:
			printf("found the tone pitch\n");
			tone_pitch = atoi(token);
			nArg++;
			break;
		case CA_TONE_DURATION:
			printf("found the tone duration\n");
			tone_duration = atoi(token);
			nArg++;
			break;
	}

	if (nArg < CA_TONE_LAST_ARG)
		return;

	'* play the tone */

	return;

}



main(int argc, char **argv) 
{
nArg = 0;
yylex();
}
