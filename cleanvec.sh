#!/bin/bash

cd /volatile/K2pipiPBC/dsh/evecs24c && \
for file in $(du -hcs * | grep 986 | egrep -o 'job-[0-9]+');
do rm -rvf $file/checkpoint;
done
for file in $(du -hcs * | grep 509 | egrep -o 'job-[0-9]+');
do cp -prl $file /cache/K2pipiPBC/qcddata/DWF/2+1f/24nt64/IWASAKI+DSDR/b1.633/ls24/M1.8/ms0.0850/ml0.00107/new_evecs/ && \
rm -rfv $file;
done
