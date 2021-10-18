#!/bin/bash
read -p "Enter file/directory that is being checked for existance: " userDir

if [ -d $userDir ];
	then echo 'EXISTS!!!';
else echo 'NOT FOUND'; fi
