#!/bin/bash

usual='tblum\/configurations\/24D'
usual='dsh\/prod_24c\/lattices'
usual='/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evol0/configurations/'
usual='dsh\/prod_32c_fine\/lattices'

cd /volatile/K2pipiPBC/dsh/exact_prod_32c && \
#cd /volatile/K2pipiPBC/dsh/rush_32c && \
for f in ${@}
do 
for file in job-0${f} job-${f}; do

if [ -d /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/pipi/exact/$file ]; then
echo "$file already finished"
break
fi

a=$(echo $file | sed 's/job-0//' | sed 's/job-//')
ls /volatile/K2pipiPBC/dsh/gfmat/32ID/gf_matrices_COULOMB.${a} || continue
c=$(echo "$a" | bc)
d=$(du -hs /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file | egrep -c '1.6T|1.5T');
e=$(du -hs /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file | egrep -c '558G|559G|560G');
echo $file
if [ $d -eq 0 -a $e -eq 0 ]; then
echo "attempting to retrieve evecs for $file from tape"
ls /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file || continue
retrieve_evecs.sh /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file || continue
continue
fi
if [ ! -f "/volatile/K2pipiPBC/dsh/prod_32c_fine/lattices/ckpoint_lat.${c}" ]; then
echo "lattice not found for ${f}"
continue
fi
size=$(du -hcs "/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file" | egrep -c '1.6T|1.5T')
size2=$(du -hcs "/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file" | egrep -c '558G|559G|560G')
if [ ${size} -eq 0 -a ${size2} -eq 0 ]; then
echo "evecs need retrieval for ${f}"
continue
fi
numsub=$(squeue -u dsh | grep -v JobHeld |  grep -c 32cE$a)
if [ $numsub -gt 0 ]; then
echo "job $f already submitted" 
#break
fi
mkdir -p job-0$a/props/output
cp -v *vml job-0$a/
cp -v run-new.sh job-0$a/
sed -i.bak "s/TEMP5/$a/" job-0$a/run-new.sh || exit 1
sed -i -- "s/TEMP2/$a/" job-0$a/do_arg.vml
sed -i -- "s/TEMP6/${usual}/" job-0$a/do_arg.vml
sed -i -- "s/TEMP3/$c/" job-0$a/pion2pt_arg.vml
sed -i -- "s/TEMP7/$a/" job-0$a/pion2pt_arg.vml
sed -i -- 's/\x27/"/g' job-0$a/pion2pt_arg.vml
sed -i -- "s/TEMP1/$file/" job-0$a/mobius_arg.vml || exit 1
cp -uv NOARCH.x job-0$a/ 
cd job-0$a || exit 1;
sbatch run-new.sh
cd ..
done
done
