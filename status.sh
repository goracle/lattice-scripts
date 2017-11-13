#!/bin/bash

#calls less on the slurm output of a job by id
dir='run_new16c'
a=$(mktemp)
cd ~/cps/cps_pp/work/pion2pt && \
find $(pwd) -path "*$1*" | tee $a
num=$(cat $a | wc -l)
if [ $num -eq 1 ]; then
less $(cat $a)
else
cd /hpcgpfs01/scratch/dsh/$dir && \
find $(pwd) -path "*$1*" | tee $a
num=$(cat $a | wc -l)
if [ $num -eq 1 ]; then
less $(cat $a)
fi
fi
