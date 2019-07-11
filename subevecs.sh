#!/bin/bash

#if [ "$1" = "" ]; then
#else
#fi
usual='tblum\/configurations\/24D'
usual='dsh\/prod_24c\/lattices'
usual='/volatile/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/evol2/configurations'
cd /volatile/K2pipiPBC/dsh/evecs24c/ && \
for f in ${@}
do
ls $usual/ckpoint_lat.$f || exit 1
file="job-0${f}"
mkdir -p $file
cp -v exe-lanc $file/
cp -v params.txt $file/
cp -v run-lanc-8 $file/
a=$(echo $file | sed 's/job-0//')
sed -i -- "s/TEMP1/$a/" $file/params.txt
sed -i -- "s/TEMP2/$a/" $file/run-lanc-8
cd $file 
sbatch run-lanc-8
cd .. 
done

