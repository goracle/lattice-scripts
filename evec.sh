#!/bin/bash

cd /volatile/K2pipiPBC/tblum/24c-evec/ && \
for file in */out*
do 
a=$(tail $file | grep -c 'Smoothed eigenvalue 1999')
if [ $a -gt 0 ]; then 
b=$(echo $file | cut -d'/' -f1)
if [ ! -d "/volatile/K2pipiPBC/dsh/prod_24c/job-0${b}" ]; then
if [ ! $b -eq 840 -a ! $b -eq 880 -a ! $b -eq 920 -a ! $b -eq 960 ]; then
echo $b
if [ ! "$1" = "" ]; then
submit.sh $b
fi
fi
fi
fi
done
