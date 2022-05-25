#!/bin/bash

#----------------- Functions ----------------------

show_home_menu() {
	#function used to show the main menu
	echo "--- Current path: ${path} ---"
	echo ""
	echo "$(ls -la "${path}")"
	echo ""
	echo "Select one action:"
	echo "1. Navigate inside directories"
	echo "2. Edit files and directories permissions"
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
	echo " "
	echo "--- Current path: ${path} ---"
	echo "$(ls -la)"
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

	epdecision=-1
	while [ $epdecision != "q" ]
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
	chmod a+x "${chmod_path}fef"
	chmod_error=$?
}

#----------------- End Funcions -------------------

#checking for path option
while getopts p: flag
do
	case "${flag}" in
		p) path=$(readlink -f "${OPTARG}");;
	esac
done

#path validation
if ! [ -d "${path}" ]; then
	echo 'ERROR: Path does not exist'
	exit 0
else
	firstPath=${path} #origina path used to avoid navigation on parents
fi	

#run menu
do_home_menu

