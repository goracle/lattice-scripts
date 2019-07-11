#!/bin/bash

fin.sh && \
cd /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs && \
for file in job-0*
do
a=$(echo $file | sed 's/job-0//')
submit.sh $a
done
