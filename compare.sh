#!/bin/bash

f1=$(mktemp)
f2=$(mktemp)
cd "job-0$1" || exit 1
echo "looking at first job"
for file in *slurm*
do
a=$(grep -c 'end of program.' $file)
if [ $a -gt 0 ]; then
echo $file
grep -e '^AlgPion2pt' $file > $f1
grep -e '^main..main' $file  >> $f1
sed -r -i -- 's/^:://' $f1
sed -i -- 's/AlgPion2pt:://' $f1
#cat $f1
#exit
break
fi
done
cd "../job-0$2" || exit 1
echo "looking at second job"
for file in *slurm*
do
a=$(grep -c 'end of program.' $file)
if [ $a -gt 0 ]; then
echo $file
grep -e '^AlgPion2pt' $file > $f2
grep -e '^main..main' $file  >> $f2
sed -r -i -- 's/^:://' $f2
sed -i -- 's/AlgPion2pt:://' $f2
#cat $f2
#exit
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
    }' $f1 $f2  | sed '/^\s*$/d'

