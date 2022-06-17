#!/bin/bash
################# converter ###################

################# functions ###################
#prefix_choice(){
#    prefix=-1
#    echo "Selecet between:"
#    echo "0. International System Prefix "
#    echo "1. Binary Prefix"
#    echo "q. Quit"
#    
#    while [ "$prefix" != "q" ]; do
#        echo -en "> "
#        read prefix
#
#        case "$prefix" in
#            "0")
#                echo "SI Prefix - Available prefixes: bit "${si_prefix[@]}"";;
#            "1")
#                echo "Binary Prefix - Available prefixes: bit "${bin_prefix[@]}"";;
#            "q")
#                exit 0;;
#            *)
#                echo "Invalid Input"
#        esac  
#
#    done   
#}

supported_values(){
    echo " "
    echo "SI Prefix - Available prefixes: "${si_prefix[@]}""
    echo "Binary Prefix - Available prefixes: "${bin_prefix[@]}""
    echo " "
}

parameters_validation(){
    #check if there are 3 parameters

    if [ $# != 3 ]; then
        echo "Program accept 3 argument: [value] [original-unit] [unit-to-convert-to]"
        exit 1
    fi 

    #check in first parameter is an integer
    if [[ $1 =~ ^[0-9]+$ ]]; then
        value=$1
    else
        echo "First paramiter must be an integer"
        exit 1
    fi 
    
    #check if second parameter has a valid value
    if [ "$2" = "byte" ];then           #|
        original_unit=$2                #| Byte and bit params are in both unit systems
                                        #| So the decision about what system use depends 
    elif [ "$2" = "bit" ];then          #| only by the other parameter
        original_unit=$2                #|
                                  #|
    elif [[ ${si_prefix[@]} =~ $2 ]]; then
        si_check=1
        original_unit=$2
    elif [[ ${bin_prefix[@]} =~ $2 ]];then
        bin_check=1
        original_unit=$2
    else
        echo "First unit doesn't math the supported unit of measurement"
        exit 1
    fi

    #check if third parameter has a valid value
    if [ "$3" = "byte" ];then            #|
        desired_unit=$3                 #| Byte and bit params are in both unit systems
                                       #| So the decision about what system use depends 
    elif [ "$3" = "bit" ];then           #| only by the other parameter
        desired_unit=$3                 #|
        
    elif [[ ${si_prefix[@]} =~ $3 ]]; then
        si_check=1
        desired_unit=$3
    elif [[ ${bin_prefix[@]} =~ $3 ]];then
        bin_check=1
        desired_unit=$3
    else
        echo "Second unit doesn't math the supported unit of measurement"
        exit 1
    fi
}

si_conversion()
{
    multiplier=0
    original_index=0
    desired_index=0
    converted_value=0
    to_bit=0    #boolean for bit conversion 

    if [ "${original_unit}" = "bit" ]; then
        original_unit="byte"
        value=$( echo "scale=15; "${value}" / 8" | bc)
    fi

    if [ "${desired_unit}" = "bit" ]; then
        desired_unit="byte"
        to_bit=1
    fi

    for index in $( seq 0 $((${#si_prefix[@]} - 1)) ) ;do
        if [ "${si_prefix[$index]}" = "${original_unit}" ]; then
            original_index=$index
        elif [ "${si_prefix[$index]}" = "${desired_unit}" ]; then
            desired_index=$index
        fi
    done

    multiplier=$(( ${desired_index} - ${original_index} ))
    multiplier=${multiplier#-} #absolute value

    if [ $original_index -gt $desired_index ]; then 
        multiplier=$(echo "scale=15; 1000^"$multiplier"" | bc )
        converted_value=$(echo "scale=15; "$multiplier"*"${value}"" | bc )
    else
        multiplier=$(echo "scale=15; 1000^"$multiplier"" | bc )
        converted_value=$(echo "scale=15; "${value}"/"$multiplier"" | bc )

    fi

    if [ "${to_bit}" = "1" ]; then
        converted_value=$( echo "scale=15; ${converted_value} * 8" | bc)
        desired_unit="bit"
        echo  " "${converted_value}" ${desired_unit} "
    else
        echo  " "${converted_value}" ${desired_unit} "
    fi
}

bin_conversion()
{
    multiplier=0
    original_index=0
    desired_index=0
    converted_value=0
    to_bit=0    #boolean for bit conversion 

    if [ "${original_unit}" = "bit" ]; then
        original_unit="byte"
        value=$( echo "scale=15; "${value}" / 8" | bc)
    fi

    if [ "${desired_unit}" = "bit" ]; then
        desired_unit="byte"
        to_bit=1
    fi

    for index in $( seq 0 $((${#bin_prefix[@]} - 1)) ) ;do
        if [ "${bin_prefix[$index]}" = "${original_unit}" ]; then
            original_index=$index
        elif [ "${bin_prefix[$index]}" = "${desired_unit}" ]; then
            desired_index=$index
        fi
    done

    multiplier=$(( ${desired_index} - ${original_index} ))
    multiplier=${multiplier#-} #absolute value

    if [ $original_index -gt $desired_index ]; then 
        multiplier=$(echo "scale=15; 1024^"$multiplier"" | bc )
        converted_value=$(echo "scale=15; "$multiplier"*"${value}"" | bc )
    else
        multiplier=$(echo "scale=15; 1024^"$multiplier"" | bc )
        converted_value=$(echo "scale=15; "${value}"/"$multiplier"" | bc )

    fi

    if [ "${to_bit}" = "1" ]; then
        converted_value=$( echo "scale=15; ${converted_value} * 8" | bc)
        desired_unit="bit"
        echo  " "${converted_value}" ${desired_unit} "
    else
        echo  " "${converted_value}" ${desired_unit} "
    fi
}

bit_2_byte(){
    converted_value=$( echo "scale=15; "${value}" / 8" | bc)
    echo " "${value}" bits correspond to: "$converted_value" bytes "
}

byte_2_bit(){
    converted_value=$( echo "scale=15; "${value}" * 8" | bc)
    echo ""${value}" bytes correspond to: "$converted_value" bits "
}

#################### main #####################

# si_check and bin_check are used as boolean value to know the standard for unit of maesurement
si_check=0
bin_check=0

#kilo; mega, giga, tera, peta, exa, zetta, yotta
si_prefix=( "bit" "byte" "kB" "MB" "GB" "TB" "PM" "EB" "ZB" "YB")
#kibi, mebi, gibi, tebi, pebi, exbi, zebi, yobi
bin_prefix=( "bit" "byte" "KiB" "MiB" "GiB" "TiB" "PiB" "EiB" "ZiB" "YiB")

supported_values #show available prefix

parameters_validation $@


#if the conversion is useless because desired_unit and original_unit, then:
if [ "$desired_unit" = "$original_unit" ]; then
    echo ""${value}" ${original_unit} correspond to: "${value}" ${desired_unit} "
    exit 0
fi

if [ "${desired_unit}" == "byte" ] && [ "${original_unit}" == "bit" ]; then
    bit_2_byte
    exit 0
fi

if [ "${desired_unit}" == "bit" ] && [ "${original_unit}" == "byte" ]; then
    byte_2_bit
    exit 0
fi

if [ $si_check = 1 ] && [ $bin_check = 0 ]; then #check if both units are inside SI
    
    echo -n ""${value}" ${original_unit} correspond to:"
    si_conversion
    exit 0
elif [ $si_check = 0 ] && [ $bin_check = 1 ]; then #check if both units are inside Binary PRefix
    echo -n ""${value}" ${original_unit} correspond to:"
    bin_conversion
    exit 0
else                                               # otherwise is a mixed conversion
    echo "Unit of Measurement in different SI Systems"
    exit 1
fi 













