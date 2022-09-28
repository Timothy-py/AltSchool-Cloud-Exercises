#! /bin/bash

file_name="memory_logs.txt"
d=$(date +%T/%m-%d-%Y)
echo "Sytem memory logs at timestamp: $d" >>$file_name

free >>$file_name
