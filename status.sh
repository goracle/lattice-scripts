#!/bin/bash

#calls less on the slurm output of a job by id
dir='run_new16c'
a=$(mktemp)
cd ~/cps/cps_pp/work/pion2pt && \
find $(pwd) -path "*$1*" -print -quit | tee $a
#echo "done with find"
num=$(cat $a | wc -l)
if [ $num -eq 1 ]; then
if [  "$2" = "" ]; then
less $(cat $a)
else
tail -n 30 $(cat $a)
fi
else

cd /volatile/K2pipiPBC/dsh && \
#echo "starting second find" && \
find $(pwd) -path "*$1*" ! -name "*out4c*" -print -quit | tee $a
#echo "done with find"
#grep 'after rho' -c $(cat $a)
num=$(cat $a | wc -l)
if [ $num -eq 1 ]; then
if [  "$2" = "" ]; then
less $(cat $a)
else
tail -n 30 $(cat $a)
fi
fi
fi

