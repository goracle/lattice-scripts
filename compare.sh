#!/bin/bash

f1=$(mktemp)
f2=$(mktemp)
cd "job-0$1" || exit 1
for file in out-*
do
a=$(grep -c 'End()' $file)
if [ $a -gt 0 ]; then
grep AlgPion2pt $file > $f1
break
fi
done
cd "../job-0$2" || exit 1
for file in out-* 
do
a=$(grep -c 'End()' $file)
if [ $a -gt 0 ]; then
grep AlgPion2pt $file > $f2
break
fi
done
awk '
    {x=ARGIND;a[x]=a[x]>(b=length($0))?a[x]:b}
    {F[FNR,x]=$0}
    END{
            for(q=1;q<=FNR;q++)
            {
                    for(i=1;i<=ARGC;i++)
                    {
                    printf( "%-"a[i]"s ",F[q,i])
                    }print ""
            }
    }' $f1 $f2 | sed 's/printMem.*//g' | sed 's/AlgPion2pt//g' | sed 's/:://g' | sed '/^\s*$/d'
