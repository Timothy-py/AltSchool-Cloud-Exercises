#! /usr/bin/bash

FILE_PATH="/home/timothy/memory_logs.txt"

if ! [ -f $FILE_PATH ]; then
    touch $FILE_PATH
    chmod ugo+xw $FILE_PATH
fi

d=$(date +%T/%m-%d-%Y)
echo "Sytem memory logs at timestamp: $d" >>$FILE_PATH

free >>$FILE_PATH
