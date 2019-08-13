#!/bin/bash

# cancel duplicate running jobs

for file in $(squeue -u dsh | cut -d' ' -f 21 | sort -h | uniq -c | egrep '[2-9] ' | cut -d' ' -f 8)
do
a=$(squeue -u dsh | grep $file | cut -d' ' -f 13)
a=$(for tos in $a; do echo $tos; done | sort -h)
b=$(echo $a | cut -d' ' -f 1)
for chk in $a; do if [ $b -gt $chk ]; then exit 1; fi; done
a=$(echo $a | cut -d' ' -f2-)
for toc in $a
do scancel -v $toc
done
done
echo "done canceling duplicate jobs"

