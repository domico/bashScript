#!/bin/bash
######## functions ########
distance(){
    #function to apply rule for distance between two point 

    pow_x=$( echo " scale=4; ${x}^2" | bc )
    #echo "powx:"${pow_x}""
    pow_y=$( echo " scale=4; ${y}^2" | bc )
    #echo "powy:"${pow_y}""
    sum_pow=$( echo " scale=4; ${pow_x} + ${pow_y}" | bc )
    #echo "somma di potenze: "${sum_pow}""
    total=$( echo " scale=4; sqrt(${sum_pow})" | bc )


    echo "Distance from original position is: "${total}""
}

update_position(){
    for char in ${string[@]}; do
        case $char in 
            "S")
                y=$(($y - 1));;
            "N")
                y=$(($y + 1));;
            "O")
                x=$(($x - 1));;
            "E")
                x=$(($x + 1));;
            *)
                echo "Bad input"
                exit 1;;
        esac
    done
}





###### main ######

#parameter validation
if [ $# != 1 ];then
    echo "Pass only one string with no space"
    exit 1
fi

if ! [[ $1 =~ ^[SNEO]+$ ]];then
    echo "Inserire una combinazione qualsiasi di questi valori: S, N, E, O"
    exit 1
fi

#declaration for variable

x=0 #x-axis
y=0 #y-axis

#original string division into array
string=( $(echo "${1}" | grep -o . ))

#call to function
update_position
distance




