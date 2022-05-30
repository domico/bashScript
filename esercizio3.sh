#!/bin/bash

check_root(){
	if [ ${EUID}  -ne 0 ]; then
		echo "Login as Root"
		exit 1
	fi
}

check_users_home(){
	users=( $(ls /home) )
	#echo "${users[@]}"
	#echo "${#users[@]}"
}

get_home_size(){
	sizes=()
	for user in ${users[@]}; do
		entry=( $(ls -ld /home/"${user}") )  
		sizes+=(${entry[4]})			#get size of home's dir for each user
	done
}

check_home_size(){
	max_dim=$( echo "1024*1024*1024" | bc)
	for index in $(seq 0 $((${#users[@]} - 1))); do
		#echo "Iterazione: "${index}""
		#echo "${sizes[$index]}"
		#echo "${max_dim}" 
		if [ "${sizes[$index]}" -ge "${max_dim}" ];then
			echo "Sending email to "$user"@quota.com from admin@quota.com" 
		else
			echo "Dim is less then max"
		fi
	done
}


######################### Main ##############################
check_root
check_users_home
get_home_size
check_home_size
