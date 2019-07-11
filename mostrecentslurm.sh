#!/bin/bash

b=$1
if [ ! -d $1 ]; then
b=$(dirname $1)
fi
cd $b
for file in $( ls | grep slurm | egrep -o '[0-9]+' |  sort -h); do
a=$file
done
echo "$b/slurm-${a}.out"
