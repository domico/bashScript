#!/bin/bash

while getopts p:l: flag
do
    case "$flag" in
        p) 
            path=${OPTARG};;
        l)
            lines=${OPTARG};;
    esac
done

path=$( readlink -f "${path}" )

#check argument number
if ! [ $# != 2 ];then
    echo "Insert both path and number of line per subfile"
    exit 1
fi

#check path 
if ! [ -f "$path" ]; then
    echo "Path isn't correct"
    exit 1
fi

#check n lines
if ! [[ "${lines}" =~ ^[0-9]+$ ]];then
    echo "Insert only integer value"
fi

#get file lines
total_line=( $( wc -l "${path}") )

#variable for initialization
n=0
n_sub_file=1

#read file 
while read line; do
    #new file creation
    if ! [ -f "${path}"_"${n_sub_file}" ];then
        touch  ""${path}"_"${n_sub_file}""
        echo "new file: ""${path}"_"${n_sub_file}"""
    fi

    #attach lines
    echo "$line" >> ""${path}"_"${n_sub_file}""

    #if 20 lines in the new filw, create a new file
    if [ $n == 19 ]; then
        
        echo "$n line; new file"
        n_sub_file=$((n_sub_file+1))
        echo "$n_sub_file"
        n=0
    fi
    n=$((n+1))
done < $path
