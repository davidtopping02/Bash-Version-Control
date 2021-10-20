#!/bin/bash

function menuPrompt
{	
	read -p "Please enter your choice: " userChoice

	case $userChoice in
		1 ) echo "Creating new repository..."
		;;
		2 ) echo "Adding file to the repository..."
		;;
		3 ) echo "Checking out file for editing..."
		;;
		* ) echo "That is not a valid choice. Please try again."
		menuPrompt
		;;
	esac
}

menuPrompt
