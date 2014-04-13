#!/bin/bash

flex emspk-sd.l

gcc lex.yy.c -o emspk-sd -lfl

