#!/bin/bash

#pick out the latest slurm script from the current working directory (latest means largest run number)
#alias this to 'slat', I use this all the time

for file in $( ls slurm*out | sort -h); do 
a=$file
done
less $a
