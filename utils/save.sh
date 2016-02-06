#!/bin/sh

if [ "$2" = "" ]; then
	exit 1
fi

path=$1
file=$path/$2

cat - >$file.new

if [ ! -s $file.new ] || [ `stat -c %s $file.new` -lt 20 ]; then
	exit 0
fi

day=`date +%d`
mon=`date +%m`
year=`date +%Y`

copy=$path/$year/${year}${mon}/${year}${mon}${day}

mkdir -p $copy
ln -f $file.new $copy/$2
mv -f $file.new $file 2>/dev/null
