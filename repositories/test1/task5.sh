#!/bin/bash

for dir in "$@"
	do
   	echo "$dir"
	if [ -d $dir ];
        	then echo 'EXISTS!!!';
	else echo 'NOT FOUND'; fi

done

