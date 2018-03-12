#!/bin/bash

#calls less on the slurm output of a job by id
if [ "$2" = "" ]; then
dir='prod_24c'
else
dir="$2"
fi
a=$(mktemp)
cd /hpcgpfs01/scratch/dsh/16c_regression_daiqian_stat_check && \
find $(pwd) -path "*$1*" | tee $a
num=$(cat $a | wc -l)
if [ $num -eq 1 ]; then
if [  "$2" = "" ]; then
less $(cat $a)
else
tail -n 30 $(cat $a)
fi
else

cd /hpcgpfs01/scratch/dsh/$dir && \
find $(pwd) -path "*$1*" | tee $a
num=$(cat $a | wc -l)
if [ $num -eq 1 ]; then
if [  "$2" = "" ]; then
less $(cat $a)
else
tail -n 30 $(cat $a)
fi
fi
fi
