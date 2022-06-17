#!/bin/bash
############## euro converter ###############

splitter(){
    init_value=$1
    banknote=(100 50 20 10 5 1) #all banknotes' values
    echo "The smallest number of banknotes needed to reach \$"${init_value}" "

    for bknote in ${banknote[@]};do
        count=0 # how many banknotes of the same value we need 
        while [ $(expr "$init_value" - "$bknote") -ge "0" ]; do
            #if the ammount of remaining import after subtraction is greter or egual to 0
            ((count++)) #add 1 banknote to the count
            init_value=$( expr ${init_value} - ${bknote}) #subtrack from remaining vbalue
        done
        #print the final banknotes' number of the same value we need
        echo " "${bknote}"\$ banknotes: "${count}" "
        #continue to next banknote value
    done
}

if [ $# -eq 1 ]; then
    splitter $1
else
    echo "insert one value as parameter"
fi

