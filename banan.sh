#!/bin/bash

fl_b=0
fl_a=0
fl_n=0

help_txt="banan tools {-b, -a, -n}"
upd_txt="no banan.sh updates yet"

for v in $@
do
case $v in
-b) fl_b=1; continue;;
-a) fl_a=1; continue;;
-n) fl_n=1; continue;;
-h) echo $help_txt; exit 0;;
--help) echo $help_txt; exit 0;;
-u) echo $upd_txt; exit 0;;
--update) echo $upd_txt; exit 0;;
-*) echo "don't provocate banan"; echo $help_txt; exit 1;;
esac
continue
done

b=""
a=""
n=""
if [ $fl_b -eq 1 ]
then
b="b"
fi

if [ $fl_a -eq 1 ]
then
a="a"
fi

if [ $fl_n -eq 1 ]
then
n="n"
fi


echo "$b$a$n$a$n is done"
exit 0
