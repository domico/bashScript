#!/bin/bash

####################### functions ######################

create_matrix(){
    

    #the first for is usefull to store an index of the iteration
    for (( iter=0; iter<n; iter++ )) 
    do
        j=${iter} #each iteration start at position (iter,iter)

        #fulfill the movement from left to right 
        for i in $(seq ${iter} $(($n - 1 -${iter})))
        do
            ((count++))
            arr[$j,$i]=$count
        done

        #fulfill the movement from top to bottom
        for j in $(seq $((${iter} + 1)) $(($n - 1 - ${iter})))
        do
            ((count++))
            arr[$j,$i]=$count
        done

        #fulfill the movement from right to left
        for (( i=$(($n - 2 - $iter)); i>=$iter ; i-- ))
        do  
            ((count++))
            arr[$j,$i]=$count
        done
        ((i++))

        #fulfill the movement from bot to top
        for (( j=$(($n - 2 - $iter)); j>=$(($iter + 1)); j-- ))
        do  
            ((count++))
            arr[$j,$i]=$count
        done
        
    done
}

print_matrix(){
    #function to print matrix
    for ((i=0;i<$n;i++));do
        for ((j=0;j<$n;j++));do
            echo  -en "\t"${arr[$i,$j]}""
        done
            echo ""
    done
}

n=$1
count=0
#declaration of associative array to simulate 2D array
declare -A arr

if [ $# != 1 ]; then
    echo "One parameter is request"
    exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Inser a number"
    exit 1
else
    create_matrix
    print_matrix
fi





