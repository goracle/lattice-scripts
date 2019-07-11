#!/bin/bash

# for the hits runs

# fin.sh && \
cd /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs && \
for file in job-0*
do
a=$(echo $file | sed 's/job-0//')
submit_24c_hits.sh $a
done
# cancel the duplicates
for ddf in $(for file in $(squeue -u dsh | grep PD | egrep -o '24cH[0-9]+' | sort -h | sed 's/24cH//' | sort -h); do if [ -d /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_pipi/job-0$file ]; then echo $file; fi; done); do a=$(squeue -u dsh | grep $ddf);  scancel -v $(echo $a | cut -d' ' -f1); done
