#!/bin/bash

#if [ "$1" = "" ]; then
#else
#fi
usual='tblum\/configurations\/24D'
usual='dsh\/prod_24c\/lattices'
cd /hpcgpfs01/scratch/dsh/prod_24c && \
for f in ${@}
do
file="job-0${f}"
mkdir -p $file/props/output 
cp -v *vml $file/ 
a=$(echo $file | sed 's/job-0//') 
cp -uv run-b.sh $file/ 
sed -i.bak "s/TEMP5/$a/" $file/run-b.sh 
sed -i -- "s/TEMP2/$a/" $file/do_arg.vml 
sed -i -- "s/TEMP6/${usual}/" $file/do_arg.vml 
sed -i -- "s/TEMP3/$a/" $file/pion2pt_arg.vml 
sed -i -- "s/TEMP1/job-0$a/" $file/mobius_arg.vml 
cp -uv NOARCH.x $file/ 
cd $file 
sbatch run-b.sh 
cd .. 
done
