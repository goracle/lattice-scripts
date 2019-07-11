#!/bin/bash

cd /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs && \
for job in $(squeue -u dsh | grep PD | egrep -o '24c[0-9]+' | sed 's/24c//')
do
echo "refreshing $job"
retrieve_evecs.sh job-0${job}
done
