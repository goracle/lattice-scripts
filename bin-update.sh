#!/bin/bash

cd /hpcgpfs01/scratch/dsh/prod_24c && \
rsync -ahz --progress /sdcc/u/dsh/cps/cps_pp/work/pion2pt/NOARCH.x . && \
for file in $(squeue -u dsh | grep PD | egrep -o '24c[0-9]+ ' | sed 's/24c//' | sed 's/^/job-0'/); do rsync -ahz --progress NOARCH.x $file/; done
cd /hpcgpfs01/scratch/dsh/16c_regression_daiqian_stat_check && \
rsync -ahz --progress /sdcc/u/dsh/cps/cps_pp/work/pion2pt/NOARCH.x . && \
for file in $(squeue -u dsh | grep PD | egrep -o 'reg[0-9]+ ' | sed 's/reg//' ); do rsync -ahz --progress NOARCH.x $file/; done
