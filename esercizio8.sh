#!/bin/bash

################ functions ##################

occ_count(){
    string=( $(echo "${1}" | grep -o . ))   #split the initia string into an array

    #PATTERN MATCHING WAY
    #string=$1
    #var="c"
    #res="${string//[^"${var}"]}"
    #echo "${res}"


    #delete repeted char inside original string
    no_rep=()
    for char in ${string[@]}; do  
        if ! [[ " ${no_rep[*]} " =~ " ${char} " ]]; then 
            no_rep+=("${char}")
        fi
    done

    array_rep_count=() #twin array of no_rep in witch the i-elem contain the number of repetition of i-char (no_rep)

    #check how many times a char is repeted in the original string
    for char in ${no_rep[@]}; do         
        char_count=0
        for (( i=0; i<${#string[@]}; i++ )); do
            if [ "${char}" = "${string[$i]}" ];then
                ((char_count++))
            fi
        done

        echo ""${char}" repetition: "${char_count}""
        #storing the repetition of i-value inside i-position of array_rep_count
        array_rep_count+=(${char_count})
    done


    #select the max value
    max_value_inedx=0
    for (( i=0; i<${#array_rep_count[@]}; i++ )); do
        if [ ${array_rep_count[$i]} -gt ${array_rep_count[$max_value_index]} ]; then
            #if i-th value of array_rep_count is greter than actual value of max_value_index, store new index
            max_value=$i
        fi 
    done
    echo "Char repeted more time is: "${no_rep[max_value]}""
}





########### main ############

if [ $# -eq 1 ]; then
    occ_count $1
else
    echo "insert one string"
fi