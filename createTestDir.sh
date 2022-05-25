#!/bin/bash

#Check for path (-p), numeber of dir (-d) and number of files (-f) option
while getopts p:d:f: flag
do
	case "${flag}" in
		p) path=${OPTARG};;
		d) ndir=${OPTARG};;
		f) nfile=${OPTARG};;
	esac
done

#check parameter value or set default
re='^-?[0-9]+$'

if [ -z ${path} ]; then
	path=$(pwd)
else
	if ! [ -d "$path" ]; then
		echo "ERROR: Path doesn't exist!"
		exit 0
	fi
fi


#echo "$path"

if [ -z $ndir ]; then
	ndir=0
elif  [ -n $ndir ] && ! [[ $ndir =~ $re ]]; then 
	echo "ERROR: $ndir is not a number"
	exit 0
fi
#echo "$ndir"


if [ -z $ndir ]; then
	nfile=0
elif [ -n $nfile ] && ! [[ $nfile =~ $re ]]; then
	echo "ERROR: $nfile is not a number"
	exit 0
fi
#echo "$nfile"

################### FILES AND DIRS CREATION #################
for ((i=1; i<= $nfile; i++));
do
	touch ${path}/testfile${i}
done
for ((i=1; i<=$ndir; i++));
do
	mkdir ${path}'/testdir'${i}
	for ((f=1; f<=$ndir; f++));
	do
		touch ${path}'/testdir'${i}'/testfile'${f}
	done
done

