#!/bin/bash

check_root(){
	if [ ${EUID}  -ne 0 ]; then
		echo "Login as Root"
		exit 1
	fi
}

check_sbin(){
	if ! [ -f /usr/sbin/esercizio3.sh ]; then
		cp ./esercizio3.sh /usr/sbin/
		echo "file non presente"
	fi
}

check_sys_job(){
	if ! [ -f /etc/cron.d/check_size ]; then
		touch /etc/cron.d/check_size
		echo "*/1 * * * * root /usr/sbin/esercizio3.sh" > /etc/cron.d/check_size
		systemctl daemon-reload
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
		entry=( $(du -s /home/"${user}") )  
		sizes+=( $(echo ""${entry}"*1024" | bc) )			#get size of home's dir for each user
		echo "${entry}"
	done
}

check_home_size(){
	max_dim=$( echo "1024*1024*1024" | bc)
	for index in $(seq 0 $((${#users[@]} - 1))); do
		if [ "${sizes[$index]}" -ge "${max_dim}" ];then
			echo "Sending email to "$user"@quota.com from admin@quota.com" 
		else
			echo "Dim is less then max"
		fi
	done
}


######################### Main ##############################
check_root
check_sbin
check_sys_job
check_users_home
get_home_size
check_home_size
