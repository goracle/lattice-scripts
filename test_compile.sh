#!/bin/bash

today=`date +%Y-%m-%d.%H:%M:%S` 
cd ~/cps/cps_pp/ && echo "current time=$today" >> make.log && \
	./cfig_jlab.sh 2>&1 | tee -a make.log && \
	make clean 2>&1 | tee -a make.log && \
	make realclean 2>&1 | tee -a make.log && \
	make -j 12 2>&1 | tee -a make.log && \
	make 2>&1 | tee -a make.log && \ 
        cd work/pion2pt && \
	make clean 2>&1 | tee -a ~/cps/cps_pp/make.log && \
	make 2>&1 | tee -a ~/cps/cps_pp/make.log && \
	cp -uv NOARCH.x /volatile/K2pipiPBC/dsh/24c_1000_test/ 2>&1 | tee -a ~/cps/cps_pp/make.log
	cp -uv NOARCH.x /volatile/K2pipiPBC/dsh/24c_1000_test2/ 2>&1 | tee -a ~/cps/cps_pp/make.log
