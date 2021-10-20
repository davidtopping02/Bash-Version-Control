#!/bin/bash

echo ""
echo "-** Version Control Menu **-"
echo ""
echo "1: Create a new repository"
echo "2: Add a file to the repository"
echo "3: Edit or view a file in the repository"
echo "0: Exit"

function menuPrompt
{	
	echo ""
	read -p "Please enter your choice: " userChoice

	case $userChoice in
		1 ) echo "Creating new repository..."
		;;
		2 ) echo "Adding file to the repository..."
		;;
		3 ) echo "Checking out file for editing..."
		;;
		0 ) echo ""
		echo "Thank you for using the program."
		echo ""
		;;
		* ) echo "That is not a valid choice. Please try again."
		menuPrompt
		;;
	esac
}

menuPrompt
