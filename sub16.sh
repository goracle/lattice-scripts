#!/bin/bash

#if [ "$1" = "" ]; then
#else
#fi
cd /hpcgpfs01/scratch/dsh/16c_regression_daiqian_stat_check && \
for f in ${@}
do
file="${f}"
mkdir -p $file/props/output 
cp -v *vml $file/ 
a=$(echo $file | sed 's/job-0//') 
cp -uv run-b.sh $file/ 
sed -i -- "s/TEMP5/$a/" $file/run-b.sh 
sed -i -- "s/TEMP2/$a/" $file/do_arg.vml 
sed -i -- "s/TEMP3/$a/" $file/pion2pt_arg.vml 
cp -uv NOARCH.x $file/ 
cd $file 
sbatch run-b.sh 
cd .. 
done
