#!/bin/bash

cd /hpcgpfs01/scratch/dsh/prod_24c/ &&
for file in $(find . -name "*slurm*")
do 
a=$(grep -c 'end of program' $file)
b=$(echo $file | cut -d'/' -f2 | sed 's/job-0//')
c=$(echo $file | cut -d'/' -f2)
if [ "$b" = "1980" -o "$c" = "1980" ]; then
continue
fi
if [ $a -gt 0 ]; then 
echo $b
touch "${c}/done.txt"
else 
echo "${b} not done"
fi 
done && \
pwd && \
for file in $(ls -d */ | egrep -o ".*[0-9]+" | cut -d'/' -f1)
do 
if [ -f "${file}/done.txt" ]; then 
rsync -ahz --progress $file /sdcc/u/dsh/finished/ && \
	rm -rfv $file
fi
done
