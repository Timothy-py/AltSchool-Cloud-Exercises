#! /usr/bin/bash

FILE="/home/vagrant/memory_logs.txt"
RECIPIENT="adeyeyetimothy33@gmail.com"
SUBJECT="System memory logs"
BODY="The details of your RAM usage for the last 24hrs can be found in the attached file."

mail -s "$SUBJECT" $RECIPIENT -A $FILE <<<"$BODY"

rm -r $FILE
