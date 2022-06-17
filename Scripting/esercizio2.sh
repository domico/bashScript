#!/bin/bash

#--------------------------- Functions -----------------------------
check_tools(){
	echo "-------------- Check for available tools ----------------"	
	
	tools=( "gzip" "zip" "bzip2" "lzma" "mlmlmlmlmlm")
	available=()
	for tool in ${tools[@]}; do
		available=$(yum list installed | grep "$tool") 
		if [ "$available" ];then
			echo ""$tool" is available"
		else
			echo ""$tool" is not available"
			tools=( ${tools[@]/${tool}} ) #drop not available tool from array
		fi
	done

	echo ""
	#echo "Tools after check:"${tools[@]}""
}

get_stats(){
	tool=$1
	case ${tool} in
		"gzip")
			echo "--------------- Start ${tool} Test ----------------"	
			echo ""
			echo "--- Compression performance ---"
			file_type=( $(file $path) )
			file_type=${file_type[1]}
			if [ "${file_type}" =  "directory" ]; then
				uncomp_size=( $(ls -ldh "${path}") )
				uncomp_size=${uncomp_size[4]}
			else
				uncomp_size=( $(ls -lh "${path}") )
				uncomp_size=${uncomp_size[4]}
			fi
			echo "Size of uncompressed file/dir: ${uncomp_size}"
			start_time=$(date +%s%3N)
			echo "${path}"
			tar -czf  gziptest.tar.gz "${path}" &> /dev/null
			end_time=$(date +%s%3N)
			comp_time=$((${end_time} - ${start_time}))
			comp_size=($(wc -c ./gziptest.tar.gz))
			comp_size=${comp_size}
			echo "Size of compressed file/dir: ${comp_size}"
			echo "Time for compression in millisecond: "${comp_time}""
			start_time=$(date +%s%3N)
			mkdir testdir
			tar -xzf gziptest.tar.gz -C ./testdir
			end_time=$(date +%s%3N)
			echo "Time for decompression in millisond: "${comp_time}""
			rm -rf ./gziptest.tar.gz 	
			rm -rf ./testdir
			
			compr_rate=$(echo " scale=3; "$uncomp_size"/"${comp_size}"" | bc -l)
			echo "${compr_rate}"	
			compr_rate=$( echo "scale=3; 1 - "$compr_rate"" | bc -l )	
			echo "${compr_rate}"
			compr_rate=$( echo "scale=2; "$compr_rate" * 100 " | bc -l)
			echo "Compression rate: "${compr_rate}"%"
			;;

		"zip")
			echo "--------------- Start ${tool} Test ----------------"	
			echo ""
			echo "--- Compression performance ---"
			file_type=( $(file $path) )
			file_type=${file_type[1]}
			if [ "${file_type}" =  "directory" ]; then
				uncomp_size=( $(ls -ldh "${path}") )
				uncomp_size=${uncomp_size[4]}
			else
				uncomp_size=( $(ls -lh "${path}") )
				uncomp_size=${uncomp_size[4]}
			fi
			echo "Size of uncompressed file/dir: ${uncomp_size}"
			start_time=$(date +%s%3N)
			zip -r ziptest.zip "${path}" &> /dev/null
			end_time=$(date +%s%3N)
			comp_time=$((${end_time} - ${start_time}))
			comp_size=($(wc -c ./ziptest.zip))
			comp_size=${comp_size}
			echo "Size of compressed file/dir: ${comp_size}"
			echo "Time for compression in millisecond: "${comp_time}""
			start_time=$(date +%s%3N)
			unzip -q -d ./testdir ziptest.zip 
			end_time=$(date +%s%3N)
			echo "Time for decompression in millisond: "${comp_time}""
			rm -rf ./ziptest.zip 	
			rm -rf ./testdir
			
			compr_rate=$(echo " scale=3; "$uncomp_size"/"${comp_size}"" | bc -l)
			echo "${compr_rate}"	
			compr_rate=$( echo "scale=3; 1 - "$compr_rate"" | bc -l )	
			echo "${compr_rate}"
			compr_rate=$( echo "scale=2; "$compr_rate" * 100 " | bc -l)
			echo "Compression rate: "${compr_rate}"%"

			;;
		"bzip2")
			echo "--------------- Start ${tool} Test ----------------"	
			echo ""
			echo "--- Compression performance ---"
			file_type=( $(file $path) )
			file_type=${file_type[1]}
			if [ "${file_type}" =  "directory" ]; then
				uncomp_size=( $(ls -ldh "${path}") )
				uncomp_size=${uncomp_size[4]}
			else
				uncomp_size=( $(ls -lh "${path}") )
				uncomp_size=${uncomp_size[4]}
			fi
			echo "Size of uncompressed file/dir: ${uncomp_size}"
			start_time=$(date +%s%3N)
			echo "${path}"
			tar -cjf  bzip2test.tar.bz2 "${path}" &> /dev/null
			end_time=$(date +%s%3N)
			comp_time=$((${end_time} - ${start_time}))
			comp_size=($(wc -c ./bzip2test.tar.bz2))
			comp_size=${comp_size}
			echo "Size of compressed file/dir: ${comp_size}"
			echo "Time for compression in millisecond: "${comp_time}""
			start_time=$(date +%s%3N)
			mkdir testdir
			tar -xjf bzip2test.tar.bz2 -C ./testdir
			end_time=$(date +%s%3N)
			echo "Time for decompression in millisond: "${comp_time}""
			rm -rf ./bzip2test.tar.bz2 	
			rm -rf ./testdir
			
			compr_rate=$(echo " scale=3; "$uncomp_size"/"${comp_size}"" | bc -l)
			echo "${compr_rate}"	
			compr_rate=$( echo "scale=3; 1 - "$compr_rate"" | bc -l )	
			echo "${compr_rate}"
			compr_rate=$( echo "scale=2; "$compr_rate" * 100 " | bc -l)
			echo "Compression rate: "${compr_rate}"%"
			;;

		"lzma")
			echo "--------------- Start ${tool} Test ----------------"	
			echo ""
			echo "--- Compression performance ---"
			file_type=( $(file $path) )
			file_type=${file_type[1]}
			if [ "${file_type}" =  "directory" ]; then
				uncomp_size=( $(ls -ldh "${path}") )
				uncomp_size=${uncomp_size[4]}
			else
				uncomp_size=( $(ls -lh "${path}") )
				uncomp_size=${uncomp_size[4]}
			fi
			echo "Size of uncompressed file/dir: ${uncomp_size}"
			start_time=$(date +%s%3N)
			echo "${path}"
			tar --lzma -cf lzmatest.tar.lzma "${path}" &> /dev/null
			end_time=$(date +%s%3N)
			comp_time=$((${end_time} - ${start_time}))
			comp_size=($(wc -c ./lzmatest.tar.lzma))
			comp_size=${comp_size}
			echo "Size of compressed file/dir: ${comp_size}"
			echo "Time for compression in millisecond: "${comp_time}""
			start_time=$(date +%s%3N)
			mkdir testdir
			tar --lzma -xf lzmatest.tar.lzma -C ./testdir
			end_time=$(date +%s%3N)
			echo "Time for decompression in millisond: "${comp_time}""
			#rm -rf ./lzmatest.tar.lzma 	
			#rm -rf ./testdir
			
			compr_rate=$(echo " scale=3; "$uncomp_size"/"${comp_size}"" | bc -l)
			echo "${compr_rate}"	
			compr_rate=$( echo "scale=3; 1 - "$compr_rate"" | bc -l )	
			echo "${compr_rate}"
			compr_rate=$( echo "scale=2; "$compr_rate" * 100 " | bc -l)
			echo "Compression rate: "${compr_rate}"%"
			;;

		"*")
			echo "Not Supported"
			exit;;

	esac
	
}

#------------------------- End Functions ---------------------------

#------------------------------ Main -------------------------------
tools=() #array for tools to check

while getopts p: flag
do
	case ${flag} in
		p)
			path=$(readlink -f "${OPTARG}");;
	esac 
done
if ! [ ${path} ];then
	echo "Missing -p argument"
	exit	
fi

if [ "$EUID" -ne 0 ];then 
	echo "Run as ROOT"
	exit 
fi

check_tools

for i in ${tools[@]}
do
	get_stats "${i}"
done


