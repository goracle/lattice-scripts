#!/bin/bash

#dir='/volatile/K2pipiPBC/dsh/sigma_fillin'
dir='/volatile/K2pipiPBC/dsh/prod_24c'
cd $dir && \
for file in $(find . -maxdepth 2 -name "*slurm*")
do
break
file=$(mostrecentslurm.sh $file)
file=$(echo $file | sed 's/\.\///')
echo "checking ${file} for completeness."
a=$(grep -c 'done with main' $file)
b=$(echo $file | cut -d'/' -f2 | sed 's/job-0//')
c=$(echo $file | cut -d'/' -f2)
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
break
if [ -f "${file}/done.txt" ]; then
#rsync -ahz --progress $file ${dir}/finished_configs/ || exit
rsync -ahz --progress $file /pipi/ && \
rm -rfv $file
fi
done


backup () {
cd $1 && \
for file in $(find . -maxdepth 2 -name "*slurm*")
do
file=$(mostrecentslurm.sh $file)
echo "checking $(pwd)${file} for completeness."
b=$(echo $file | cut -d'/' -f2 | sed 's/job-0//')
running=$(squeue -u dsh | egrep "(32c|24c).?$b" | grep R -c);
if [ ! $running -eq 0 ]; then
echo "$b is running, skipping"
continue
fi

a=0
c=$(echo $file | cut -d'/' -f2)
if [ ! -f "${c}/done.txt" ]; then
a=$(grep -c 'done with main' $file)
else
a=1
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
# rsync -ahz --progress $file ${dir}/finished_configs/ || exit
echo "$file to $2"
cp -prl $file $2 && \
rm -rfv $file
fi
done
}

dir='/volatile/K2pipiPBC/dsh/prod_24c'
dirstore='/cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_pipi/'
backup $dir $dirstore
dir='/volatile/K2pipiPBC/dsh/prod_24c_hits'
dirstore='/cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_pipi/'
backup $dir $dirstore
dir='/volatile/K2pipiPBC/dsh/prod_32c_fine'
dirstore='/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/pipi/'
backup $dir $dirstore
dir='/volatile/K2pipiPBC/dsh/exact_prod_32c'
dirstore='/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/pipi/exact/'
backup $dir $dirstore
dir='/volatile/K2pipiPBC/dsh/prod_32c_hits'
dirstore='/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/pipi/'
backup $dir $dirstore

exit

#obsolete way below
for file in $(find . -path "./job*out-*")
do
a=$(grep -c 'End()' $file)
b=$(echo $file | cut -d'/' -f2 | sed 's/job-0//')
if [ $a -gt 0 ]; then
echo $b
touch "job-0${b}/done.txt"
else
echo "${b} not done"
fi
done && \
for file in job-0*
do
if [ -f "${file}/done.txt" ]; then
fi
done
