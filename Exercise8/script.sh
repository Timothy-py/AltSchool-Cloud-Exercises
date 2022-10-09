#! /usr/bin/bash

FILE_PATH="/home/vagrant/memory_logs.txt"
DATE=$(date +%T,%d-%m-%Y)

#create file if it doesn't exist
if ! [ -f $FILE_PATH ]; then
    touch $FILE_PATH
    chmod ugo+xw $FILE_PATH
fi

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >>$FILE_PATH
echo "System memory logs at timestamp: $DATE" >>$FILE_PATH

free -h >>$FILE_PATH
