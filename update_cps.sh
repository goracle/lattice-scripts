#!/bin/bash

cd ~/cps/cps_pp && \
	#git pull origin pion2pt_debug || \
	cd .. && \
	git checkout HEAD~ cps_pp/Makefile.rules \
	cps_pp/Makefile.users \
	cps_pp/config.log \
	cps_pp/config.status \
	cps_pp/hdw_tests/Makefile_common \
	cps_pp/tests/Makefile_common \
	cps_pp/work/pion2pt/Makefile
	#git pull origin pion2pt_debug
