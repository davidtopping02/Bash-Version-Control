#! /bin/bash

export exit=0

function menuPrompt
{
	echo $'\n0. Exit'
	echo '1. Create new repository'
	echo '2. Check file into respository'
	echo $'3. Check file out\n'
	read -p "Please enter your choice: " userChoice

	case $userChoice in
		1 ) echo
		    ;;
		2 ) checkIn
				;;
		3 ) checkOut
				;;
		0 )
				exit=1
				echo $'\nThank you for using the program.\n'
				exit 1
				;;
		* ) echo 'That is not a valid choice. Please try again.'
		menuPrompt
		;;
	esac
}

checkIn(){
	#checking if there are any files to be chcked in
	if [ -z "$(ls -A workingDir)" ]; then
		echo $'There are currently no files checked out...'
		menuPrompt
	fi

  #displaying all available respositories
  echo $'\nWhich repository would you like to check a file into:'
  ls workingDir

  #getting user option of repository
  repo="repoName"

  #looping till valid repository is enterered
  until [[ -d "workingDir/$repo" ]]; do

    #getting repository name from user
    read -p $'\nRepo: ' repo

    #displaying message if the repository entered does not exist
    if [[ ! -d "workingDir/$repo"  ]]; then
      echo 'repository does not exist'
    fi
  done

  #displaying all files that can be checked in
  echo $'\nfiles available to be check in'
  ls workingDir/$repo

  #init file to check in variable
  fileToCheckIn="fileToCheckIn"

  #looping till valid file is enterered
  until [[ -f "workingDir/$repo/$fileToCheckIn" ]]; do

    #getting user option of file to be checked in
    read -p $'\nfile to check in: ' fileToCheckIn

    #displaying message if the file entered does not exist
    if [[ ! -f "workingDir/$repo/$fileToCheckIn"  ]]; then
      echo 'file does not exist'
    fi
  done

  #moving file back to the repository
  mv workingDir/$repo/$fileToCheckIn repositories/$repo

  #deleting folder if its the last file being checked in
  if [ -z "$(ls -A workingDir/$repo)" ]; then
    rm -r workingDir/$repo
  fi

  #displaying message if move of directory worked
  if [[ -f "repositories/$repo/$fileToCheckIn"  ]]; then
    echo 'File checked in succesfully!'
  else
    echo "Error in checking in file '$fileToCheckIn'"
  fi

}


checkOut(){

  #displaying all available respositories
  echo $'\nRespositories available:'
  ls repositories

  #getting user option of repository
  repo="repoName"

  #looping till valid repository is enterered
  until [[ -d "repositories/$repo" ]]; do

    #getting repository name from user
    read -p $'\nRepo: ' repo

    #displaying message if the repository entered does not exist
    if [[ ! -d "repositories/$repo"  ]]; then
      echo 'repository does not exist'
    fi
  done

  fileToCheckOut="fileToCheckOut"

  #displaying all files that can be checked out
  echo $'\nfiles available to check out'
  ls repositories/$repo

  #looping till valid file is enterered
  until [[ -f "repositories/$repo/$fileToCheckOut" ]]; do

    #getting user option of file to be
    read -p $'\nfile to check out: ' fileToCheckOut

    #displaying message if the file entered does not exist
    if [[ ! -f "repositories/$repo/$fileToCheckOut"  ]]; then
      echo 'file does not exist'
    fi
  done

  #moving file to be checked out to working directory
  if [[ ! -d workingDir/$repo ]]; then
      mkdir workingDir/$repo
  fi
  mv repositories/$repo/$fileToCheckOut workingDir/$repo

  #displaying message if move of directory worked
  if [[ -f "workingDir/$repo/$fileToCheckOut"  ]]; then
    echo 'File checked out succesfully!'

		echo $'\nWould you like to open your file in a text editor?'
		echo 'y/n'
		read -p 'Option: ' userChoice

		case $userChoice in
			y )
					gnome-text-editor workingDir/$repo/$fileToCheckOut
			    ;;
			n ) menuPrompt
					;;
			* ) echo 'That is not a valid choice.'
					menuPrompt
					;;
			esac
  else
    echo "Error in checking out file '$fileToCheckOut'"
  fi

}

#looping the menu till exit
while [[ $exit != 1 ]]; do
	menuPrompt exit
done

function createRepo {


read -p "what would you like to call your repository?" myRepo
#edit path here if you want to add it to "repositories/"
mkdir $myRepo

}


function makeFile {

#if you are adding a file while outside the repo use the following
echo "which repo would you like to add your file to?"
read tempDir

echo "what would you like to call your file?"
read myFile

touch $tempDir/$myFile

#alternatively if you are already in the repo you would use the following
#read -p "What would you like to call your file" myFile
#touch myFile
}

