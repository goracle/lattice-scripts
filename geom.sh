#!/bin/bash


if [ "$1" = "" ];
then
    echo "1 1 1 1"
    exit
fi

nCores=$1
if [ "$(echo "$nCores*2/2" | bc)" != "$nCores" ];
then
    echo "nCores not an integer";
    exit -1
fi

x=$(echo "l(${nCores})/l(2)" | bc -l);
if [ $(echo "$x-$x*2/2>.0000000000001" | bc) -eq 1 ]
then
    echo "num cores not a power of 2"
    exit -1
fi

c=3
while [ $c -ge 0 ];
do
   x[$c]=1
   c=$(echo "$c-1" | bc -l)
done



#simd layout is 1 2 2 2, and time direction is typically double spatial
#thus, balance the result
if [ "$nCores" = "2" ]; then
        echo "1 1 1 2"
        exit
fi
x[3]=2 #x
x[0]=2 #t
n=$(echo "$nCores/4" | bc)


while [ $n -gt 1 ]
do
    c=$(echo "$c+1" | bc -l)
    if [ $c -gt 3 ]; then
        c=-1;
        continue;
    fi
    x[$c]=$(echo "${x[$c]}*2" | bc -l);
    n=$(echo "${n}/2" | bc);
done


c=3
while [ $c -gt 0 ];
do
    geom+="${x[$c]} "
    c=$(echo "$c-1" | bc -l)
done
geom+="${x[0]}"

echo $geom

