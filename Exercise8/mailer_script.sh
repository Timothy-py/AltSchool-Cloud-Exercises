#! /usr/bin/bash

FILE="/home/vagrant/memory_logs.txt"
RECIPIENT=adeyeyetimothy33@gmail.com
SUBJECT="System memory logs"
BODY >>cat $FILE

mail -s $SUBJECT $RECIPIENT >>$BODY

rm -r $FILE
