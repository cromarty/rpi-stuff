#!/bin/bash
rm fart


bison -d emspk-sd.y

flex emspk-sd.l

gcc emspk-sd.tab.c lex.yy.c -o fart -lfl


