#!/bin/bash

usual='tblum\/configurations\/24D'
usual='dsh\/prod_24c\/lattices'

cd /volatile/K2pipiPBC/dsh/exact_prod && \
for f in ${@}
do 
file="job-0${f}"
a=$(echo $file | sed 's/job-0//')
c=$(echo "$a" | bc)
d=$(du -hs /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/$file | grep -c 509);
if [ $d -eq 0 ]; then
retrieve_evecs.sh /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/$file
continue
fi
if [ -d /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_pipi/exact/$file ]; then
echo "job already finished"
continue
fi
if [ ! -f "/volatile/K2pipiPBC/dsh/prod_24c/lattices/ckpoint_lat.${c}" ]; then
echo "lattice not found for ${f}"
continue
fi
size=$(du -hcs "/cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/job-0${c}" | grep -c '509G')
if [ ${size} -eq 0 ]; then
echo "evecs need retrieval for ${f}"
continue
fi
numsub=$(squeue -u dsh | grep -v JobHeld |  grep -c $f)
if [ $numsub -gt 0 ]; then
echo "job $f already submitted" 
continue
fi
mkdir -p $file/props/output
cp -v *vml $file/
cp -v run-new.sh $file/
sed -i.bak "s/TEMP5/$a/" $file/run-new.sh
sed -i -- "s/TEMP2/$a/" $file/do_arg.vml
sed -i -- "s/TEMP6/${usual}/" $file/do_arg.vml
sed -i -- "s/TEMP3/$c/" $file/pion2pt_arg.vml
sed -i -- "s/TEMP7/$a/" $file/pion2pt_arg.vml
sed -i -- 's/\x27/"/g' $file/pion2pt_arg.vml
sed -i -- "s/TEMP1/job-0$a/" $file/mobius_arg.vml
cp -uv NOARCH.x $file/ 
cd $file 
sbatch run-new.sh
cd ..
done
