#!/bin/bash

grep 'ConjugateGradient: Iteration' slurm-${1}.out > err.txt || exit
head -n 800 err.txt > err2.txt
mv -v err2.txt err.txt
sed -i.bak -e 's/[A-Za-z]//g' err.txt
sed -i.bak -e 's/://g' err.txt
sed -i.bak -e 's/^ *//g' err.txt
cut -f2- -d' ' err.txt > err2.txt
mv -v err2.txt err.txt
sed -i.bak -e 's/^ *//g' err.txt
cut -d' ' -f1-3 err.txt > err2.txt
mv err2.txt err.txt
sed -i.bak 's/^[0-9]* //g' err.txt
sed -i.bak 's/[-+]/e&/g' err.txt
mv -v err.txt "slurmjob_$1"
gnuplot -persist <<-EOFMarker
set output "resids_${1}.ps"
set logscale y
set term postscript
plot "slurmjob_$1" with lines
EOFMarker

