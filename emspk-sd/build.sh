#!/bin/bash

flex emspk-sd.l

gcc lexyy.c -o emspk-sd -lfl

