#!/bin/bash

usual='tblum\/configurations\/24D'
usual='dsh\/prod_24c\/lattices'
usual='/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evol0/configurations/'
usual='dsh\/prod_32c_fine\/lattices'

cd /volatile/K2pipiPBC/dsh/prod_32c_hits && \
pwd && \
for f in ${@}
do 
for file in job-0${f} job-${f}; do
a=$f
newtraj=$(echo "$a + 1" | bc);
file2=$(echo $file | sed "s/$f/$newtraj/")
if [ -d "/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/pipi/$file2" ]; then
echo "$file2 already finished"
break
fi

a=$(echo $file | sed 's/job-0//' | sed 's/job-//')
ls /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/gfmat/gf_matrices_COULOMB.${a} || continue
c=$(echo "$a" | bc)
d=$(du -hs /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file | egrep -c '1.6T|1.5T');
e=$(du -hs /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file | egrep -c '558G|559G|560G');
echo $file
if [ $d -eq 0 -a $e -eq 0 ]; then
echo "(not) attempting to retrieve evecs for $file2 from tape"
ls /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file || continue
continue
retrieve_evecs.sh /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file || continue
continue
fi
if [ ! -f "/volatile/K2pipiPBC/dsh/prod_32c_fine/lattices/ckpoint_lat.${c}" ]; then
echo "lattice not found for ${newtraj}"
continue
fi
size=$(du -hcs "/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file" | egrep -c '1.6T|1.5T')
size2=$(du -hcs "/cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs/$file" | egrep -c '558G|559G|560G')
if [ ${size} -eq 0 -a ${size2} -eq 0 ]; then
echo "evecs need retrieval for ${newtraj}"
continue
fi
numsub=$(squeue -u dsh  |  grep -c ${newtraj})
if [ $numsub -gt 0 ]; then
echo "job $f already submitted" 
break
fi
file2="job-0${newtraj}"
mkdir -p $file2/props/output
cp -v *vml $file2/
cp -v run-new.sh $file2/
sed -i.bak "s/TEMP5/$newtraj/" $file2/run-new.sh || exit 1
sed -i -- "s/TEMP2/$a/" $file2/do_arg.vml
sed -i -- "s/TEMP6/${usual}/" $file2/do_arg.vml
sed -i -- "s/TEMP3/$newtraj/" $file2/pion2pt_arg.vml
sed -i -- "s/TEMP7/$a/" $file2/pion2pt_arg.vml
sed -i -- 's/\x27/"/g' $file2/pion2pt_arg.vml
sed -i -- "s/TEMP1/$file/" $file2/mobius_arg.vml || exit 1
cp -uv NOARCH.x ${file2}/ 
cd $file2 || exit 1;
sbatch run-new.sh
cd ..
done
done
