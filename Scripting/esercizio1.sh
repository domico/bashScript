#!/bin/bash

#----------------- Functions ----------------------

ch_root_perm() {
	#check root permission 
	if [ "$EUID" -ne 0 ]
	  then echo "Please run as root"
	  exit
	fi
}



check_path() {
	#path validation
	if ! [ -d "${path}" ]; then
		echo 'ERROR: Path does not exist'
		exit 0
	else
		firstPath=${path} #origina path used to avoid navigation on parents
	fi	
}

show_home_menu() {
	#function used to show the main menu
	echo "--- Current path: ${path} ---"
	echo ""
	echo "$(ls -la "${path}")"
	echo ""
	echo "Select one action:"
	echo "1. Navigate inside directories"
	echo "2. Edit files and directories permissions"
	echo "3. Edit User Owner"
	echo "4. Edit Group Owner"
	echo "q. Quit"
	echo -en "> "
		
}

do_home_menu() {
	#function used to store user decision on the main menu 
	choice=-1
	while [ "$choice" != "q" ]; do
		show_home_menu
		read choice
	#add controll on choice
		case "$choice" in
			"1")
				show_navigate_menu;;
			"2")
				edit_permission;;
			"3")
				edit_user_owner;;
			"4")
				edit_group_owner;;
			"q")
				exit 0;;
			*)
				echo "Not a valid input";;
		esac

	done
}

show_navigate_menu(){
	#function that allow user to move throught directories
	echo "--- Current path: ${path} ---"

	directs=($(ls -p $path | grep /)) #array of dirs
	len=$((${#directs[@]} - 1))

	echo "Select a directory:"
	
	#menu building
	for d in $(seq 0 ${len}) 
	do
		echo "${d}. ${directs[$d]}"
	done
	echo "q. Quit"
	if [ ${path} != ${firstPath} ]; then 
		echo "b. Come back to parent dir"
	fi
	
	echo -en "> "	

	#storing user decision
	nmdir=-1
	while [ $nmdir != "q" ]; do	
		read nmdir
		
		#decision valdiation
		if  [[ "${nmdir}" =~ ^-?[0-9]+$ ]] &&  [ "${nmdir}" -ge 0 ] && [ "${nmdir}" -le "${len}" ]; then
			
			path=$(readlink -f "${path}/${directs[$nmdir]}")
			return 0
		elif [ $nmdir = "q" ]; then
			return 0
		elif [ $nmdir = "b" ]; then
			path=$(dirname "${path}")
			return 0;
		else
			echo "Invalid Input"
		fi
	done

}

edit_permission(){
	
	epdecision=-1
	while [ $epdecision != "q" ]	
	

	echo " "
	echo "---- Current path: ${path} ----"
	echo "$(ls -la "${path}")"
	echo " "
	echo "Select file or directory you want to change permissions to:"

	content=("$(ls -a ${path})") #storing content of current dir
	content_to_hide=(". ..") #content to hide of current dir
	for elem in ${content_to_hide}
	do
		content=(${content[@]/${elem}})
	done

	for index in $(seq 0 $((${#content[@]} - 1)) )
	do
		echo "${index}. ${content[${index}]} "
	done

	echo "q. Quit"
	echo " "
	echo -en "> "
	
	do
		read epdecision
		if [ $epdecision = "q" ]; then
			return 0
		elif [[ $epdecision =~ ^-?[0-9]+$ ]] && [ $epdecision -ge 0 ] && [ $epdecision -le $((${#content[@]} -1)) ] 
		then
			#echo "${epdecision}"
			change_perm "${content[$epdecision]}"
		else
			echo "Invalid Input"
		fi		
	done	
}

change_perm() {	
	chmod_path="${path}"/"$1"
	chmod_command=-1
	while [ $chmod_command != "q" ]; do
		echo " "
		echo " --- Current File/Directory Involved ---"
		echo " --- "${chmod_path}" --- "	
		echo " --- $(ls -l "$chmod_path" )"
		echo " "
		echo "Insert the chmod permission you want to use or press q to Quit:"
		echo -en "> "	
	
		read chmod_command

		chmod_out=$( chmod "${chmod_command}" "${chmod_path}" 2>&1 )
		chmod_error=$?

		if [ $chmod_error = 0 ]; then
			#echo "Nessun errore"
			return 0
		else
			#echo "Errore"
			echo "$chmod_out"
		fi
	done

	return 0
}

edit_user_owner(){
	
	epdecision=-1
	while [ $epdecision != "q" ]	
	

	echo " "
	echo "--- Current path: ${path} ---"
	echo "$(ls -la ${path})"
	echo " "
	echo "Select file or directory you want to change user owner to:"

	content=("$(ls -a ${path})") #storing content of current dir
	content_to_hide=(". ..") #content to hide of current dir
	for elem in ${content_to_hide}
	do
		content=(${content[@]/${elem}})
	done

	for index in $(seq 0 $((${#content[@]} - 1)) )
	do
		echo "${index}. ${content[${index}]} "
	done

	echo "q. Quit"
	echo " "
	echo -en "> "
	
	do
		read epdecision
		if [ $epdecision = "q" ]; then
			return 0
		elif [[ $epdecision =~ ^-?[0-9]+$ ]] && [ $epdecision -ge 0 ] && [ $epdecision -le $((${#content[@]} -1)) ] 
		then
			#echo "${epdecision}"
			change_user_owner "${content[$epdecision]}"
		else
			echo "Invalid Input"
		fi		
	done	
}
edit_group_owner(){
	
	epdecision=-1
	while [ $epdecision != "q" ]	
	

	echo " "
	echo "--- Current path: ${path} ---"
	echo "$(ls -la ${path})"
	echo " "
	echo "Select file or directory you want to change user owner to:"

	content=("$(ls -a ${path})") #storing content of current dir
	content_to_hide=(". ..") #content to hide of current dir
	for elem in ${content_to_hide}
	do
		content=(${content[@]/${elem}})
	done

	for index in $(seq 0 $((${#content[@]} - 1)) )
	do
		echo "${index}. ${content[${index}]} "
	done

	echo "q. Quit"
	echo " "
	echo -en "> "
	
	do
		read epdecision
		if [ $epdecision = "q" ]; then
			return 0
		elif [[ $epdecision =~ ^-?[0-9]+$ ]] && [ $epdecision -ge 0 ] && [ $epdecision -le $((${#content[@]} -1)) ] 
		then
			#echo "${epdecision}"
			change_group_owner "${content[$epdecision]}"
		else
			echo "Invalid Input"
		fi		
	done	
}

change_user_owner() {	
	us_ow_path="${path}"/"$1"
	us_ow_command=-1
	while [ $us_ow_command != "q" ]; do
		echo " "
		echo " --- Current File/Directory Involved ---"
		echo " --- "${us_ow_path}" --- "	
		echo " --- $(ls -l "$us_ow_path" )"
		echo " "
		echo "Insert the new user owner or press q to Quit:"
		echo -en "> "	
	
		read us_ow_command

		us_ow_out=$( chown "${us_ow_command}" "${us_ow_path}" 2>&1 )
		us_ow_error=$?

		if [ $us_ow_error = 0 ]; then
			#echo "Nessun errore"
			return 0
		else
			#echo "Errore"
			echo "$us_ow_out"
		fi
	done

	return 0
}

change_group_owner() {	
	gr_ow_path="${path}"/"$1"
	gr_ow_command=-1
	while [ $gr_ow_command != "q" ]; do
		echo " "
		echo " --- Current File/Directory Involved ---"
		echo " --- "${gr_ow_path}" --- "	
		echo " --- $(ls -l "$gr_ow_path" )"
		echo " "
		echo "Insert the new group owner or press q to Quit:"
		echo -en "> "	
	
		read gr_ow_command

		gr_ow_out=$( chown :"${gr_ow_command}" "${gr_ow_path}" 2>&1 )
		gr_ow_error=$?

		if [ $gr_ow_error = 0 ]; then
			#echo "Nessun errore"
			return 0
		else
			#echo "Errore"
			echo "$gr_ow_out"
		fi
	done

	return 0
}



#----------------- End Funcions -------------------

#--------------------- Main -----------------------

#checking for path option
while getopts p: flag
do
	case "${flag}" in
		p) path=$(readlink -f "${OPTARG}");;
	esac
done

ch_root_perm

check_path

do_home_menu


