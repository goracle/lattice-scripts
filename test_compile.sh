#!/bin/bash

cd ~/cps/cps_pp/ && ./cfig_bnl.sh && make clean && make realclean && make -j 18 && cd work/pion2pt && make clean && make && \
cp -uv NOARCH.x 24c_1000_test2/NOARCH.x
#cp -v ~/cps/cps_pp/work/pion2pt/NOARCH.x /hpcgpfs01/scratch/dsh/run_new16c/9300_test_dan/ && \
#cp -v ~/cps/cps_pp/work/pion2pt/NOARCH.x /hpcgpfs01/scratch/dsh/run_new16c/9300_test_aaron/
