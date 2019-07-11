#!/bin/bash

usual='tblum\/configurations\/24D'
usual='dsh\/prod_24c\/lattices'

cd /volatile/K2pipiPBC/dsh/prod_24c_hits && \
for f in ${@}
do 
file="job-0${f}"
a=$(echo $file | sed 's/job-0//')
newtraj=$(echo "$a + 1" | bc);
file2="job-0${newtraj}"
c=$(echo "$a" | bc)
d=$(du -hsL /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/$file | grep -c 509);
g=$(du -hsL /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/$a | grep -c 508);
if [ $d -eq 0 -a $g -eq 0 ]; then
retrieve_evecs.sh /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/$file
continue
fi
if [ -d /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_pipi/${file2} ]; then
echo "job already finished"
continue
fi
if [ ! -f "/volatile/K2pipiPBC/dsh/prod_24c/lattices/ckpoint_lat.${c}" ]; then
echo "lattice not found for ${newtraj}"
continue
fi
size=$(du -hcsL "/cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/job-0${c}" | grep -c '509G')
size2=$(du -hcsL "/cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/job-0${c}" | grep -c '508G')
if [ ${size} -eq 0 -a ${size2} -eq 0 ]; then
echo "evecs need retrieval for ${newtraj}"
continue
fi
numsub=$(squeue -u dsh |  grep -c $newtraj | grep 24c )
if [ $numsub -gt 0 ]; then
echo "job $f already submitted" 
continue
fi
mkdir -p $file2/props/output
cp -v *vml $file2/
cp -v run-new.sh $file2/
sed -i.bak "s/TEMP5/$newtraj/" $file2/run-new.sh
sed -i -- "s/TEMP2/$a/" $file2/do_arg.vml
sed -i -- "s/TEMP6/${usual}/" $file2/do_arg.vml
sed -i -- "s/TEMP3/$newtraj/" $file2/pion2pt_arg.vml
sed -i -- "s/TEMP7/$a/" $file2/pion2pt_arg.vml
sed -i -- 's/\x27/"/g' $file2/pion2pt_arg.vml
sed -i -- "s/TEMP1/job-0$a/" $file2/mobius_arg.vml
cp -uv NOARCH.x $file2/ 
cd $file2 
sbatch run-new.sh
cd ..
done
