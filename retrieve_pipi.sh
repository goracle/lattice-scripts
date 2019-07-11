#!/bin/bash

for dir in ${@};
do
srmGet -r $dir;
cd $dir || exit
srmGet -r props;
cd props || exit
srmGet -r output;
cd ..; cd ..
done
