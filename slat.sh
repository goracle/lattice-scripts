#!/bin/bash 
 
#pick out the latest slurm scritp from the current working directory (latest means largest run number

for file in $( ls | grep slurm | egrep -o '[0-9]+' |  sort -h); do
a=$file
done
a="slurm-${a}.out"
echo "$a"
less $a
