#!/bin/bash

# for the hits runs

# fin.sh && \
cd /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/evecs && \
for file in job-*
do
a=$(echo $file | sed 's/job-0//' | sed 's/job-//')
submit_32c_hits.sh $a
done
# cancel the duplicates
for ddf in $(for file in $(squeue -u dsh | grep PD | egrep -o '32cH[0-9]+' | sort -h | sed 's/32cH//' | sort -h); do if [ -d /cache/K2pipiPBC/qcddata/DWF/2+1f/32nt64/IWASAKI+DSDR/b1.75/ls12/ms0.045/mu0.0001/pipi/job-0$file ]; then echo $file; fi; done); do a=$(squeue -u dsh | grep $ddf);  scancel -v $(echo $a | cut -d' ' -f1); done
