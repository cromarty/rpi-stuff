#!/bin/bash
[ -f emacspeakproxy ] && rm emacspeakproxy


bison -d emacspeakproxy.y

flex emacspeakproxy.l

gcc emacspeakproxy.tab.c lex.yy.c -o emacspeakproxy -lfl



