#!/bin/bash

for dir in ${@};
do
srmGet -r $dir;
cd $dir || exit
srmGet -r lanczos.output;
cd lanczos.output || exit
for file in *;
do
a=$(echo $file | egrep '[0-9]');
srmGet -r $a;
done
cd ..; cd ..
done
