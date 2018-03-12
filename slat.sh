#!/bin/bash

#pick out the latest slurm scritp from the current working directory (latest means largest run number

for file in $( ls slurm*out | sort -h); do 
a=$file
done
less $a
