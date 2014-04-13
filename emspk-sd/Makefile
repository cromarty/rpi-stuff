# Makefile for emspk-sd

emspk-sd: emspk-sd.l emspk-sd.y

 bison -d emspk-sd.y

 flex emspk-sd.l

 cc -o $@ emspk-sd.tab.c lex.yy.c -lfl 

