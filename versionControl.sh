#! /bin/bash

export exit=0

function menuPrompt
{
	echo $'\n0. Exit'
	echo '1. Create new repository'
	echo '2. Add a file to an existing repository'
	echo '3. Check file into respository'
	echo '4. Check file out'
	echo '5. View all active repositories'
	echo '6. View all archived repositories'
  echo '7. Archive a repository'
  echo $'8. Unarchive a repository \n'


	read -p "Please enter your choice: " userChoice

	case $userChoice in
		1 ) createRepo
		    ;;
		2 )	makeFile
				;;
		3 ) checkIn
				;;
		4 ) checkOut
				;;
		5 ) echo $'\nActive repositories:'
				ls repositories
				;;
		6 ) echo $'\nArchived repositories:'
				ls archives | sed -n 's/\.tar.gz$//p'
				;;
		7 ) archiveRepo
      	;;
    8 ) unarchiveRepo
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

	#adding log entry
	dt=$(date '+%d/%m/%Y %H:%M:%S')
	echo "'$fileToCheckIn' checked into repository '$repo' on '$dt'" >> repositories/$repo/$repo.log

	#checking if the user wants to add their own log entry
	echo $'\nWould you like to add your own log entry?'
	echo 'y/n'
	read -p 'Option: ' userChoice

	case $userChoice in
		y )	echo $'\nEnter your log entry'
				read -p "Entry: " logEntry
				dt=$(date '+%d/%m/%Y %H:%M:%S')
				echo "USER LOG: $logEntry on $dt" >> repositories/$repo/$repo.log
				;;
		n ) menuPrompt
				;;
		* ) echo 'That is not a valid choice.'
				menuPrompt
				;;
		esac


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

	if [ -z "$(ls -A repositories)" ]; then
		echo $'There are currently no active respositories...'
		return 1
	fi

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

	#adding log entry
	dt=$(date '+%d/%m/%Y %H:%M:%S')
	echo "'$fileToCheckOut' checked out on '$dt'" >> repositories/$repo/$repo.log

	#checking if the user wants to add their own log entry
	echo $'\nWould you like to add your own log entry?'
	echo 'y/n'
	read -p 'Option: ' userChoice

	case $userChoice in
		y )	echo $'\nEnter your log entry'
				read -p "Entry: " logEntry
				dt=$(date '+%d/%m/%Y %H:%M:%S')
				echo "USER LOG: $logEntry on $dt" >> repositories/$repo/$repo.log
				;;
		n ) menuPrompt
				;;
		* ) echo 'That is not a valid choice.'
				menuPrompt
				;;
		esac

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

createRepo () {

	#getting user input for the name of the new repo
	read -p "Name of new repo: " repo

	#making new directory for new repo
	mkdir repositories/$repo

	#adding log entry
	dt=$(date '+%d/%m/%Y %H:%M:%S')
	echo "'$repo' created on '$dt'" >> repositories/$repo/$repo.log

	#checking if the user wants to add their own log entry
	echo $'\nWould you like to add your own log entry?'
	echo 'y/n'
	read -p 'Option: ' userChoice

	case $userChoice in
		y )	echo $'\nEnter your log entry'
				read -p "Entry: " logEntry
				dt=$(date '+%d/%m/%Y %H:%M:%S')
				echo "USER LOG: $logEntry on $dt" >> repositories/$repo/$repo.log
				;;
		n ) menuPrompt
				;;
		* ) echo 'That is not a valid choice.'
				menuPrompt
				;;
		esac
}

makeFile (){

	if [[ ! -d repositories/ ]]; then
			echo $'\nThere are currently no repositories'
	    menuPrompt
	fi

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

	#name file
	read -p $'\nwhat would you like to call your file?: ' myFile

	touch repositories/$repo/$myFile

	#adding log entry
	dt=$(date '+%d/%m/%Y %H:%M:%S')
	echo "'$myFile' added to repository '$repo' on '$dt'" >> repositories/$repo/$repo.log

	#checking if the user wants to add their own log entry
	echo $'\nWould you like to add your own log entry?'
	echo 'y/n'
	read -p 'Option: ' userChoice

	case $userChoice in
		y )	echo $'\nEnter your log entry'
				read -p "Entry: " logEntry
				dt=$(date '+%d/%m/%Y %H:%M:%S')
				echo "USER LOG: $logEntry on $dt" >> repositories/$repo/$repo.log
				;;
		n ) menuPrompt
				;;
		* ) echo 'That is not a valid choice.'
				menuPrompt
				;;
		esac


	if [[ ! -f "repositories/$repo/$myFile" ]]; then
		echo $'\nERROR when adding file'
	fi
	if [[ -f "repositories/$repo/$myFile" ]]; then
		echo 'File added succesfully'
	fi
}


archiveRepo (){
	#displaying error if there are no repositories
	if [[ ! -d repositories/ ]]; then
		echo $'\nThere are currently no repositories'
    return 1
  fi

	echo $'\nRespositories available to archive:'
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

  #archive the repository
	tar -czf archives/$repo.tar.gz repositories/$repo/.

	#removing repository from the repo folder
	rm -r repositories/$repo

	if [[ ! -e "archives/$repo.tar.gz" ]]; then
  	echo $'\nERROR when archiving repository'
  fi

	if [[ -e "archives/$repo.tar.gz" ]]; then
    echo 'Repository archived succesfully'
  fi
}

unarchiveRepo (){

	if [[ ! -e archives/ ]]; then
		echo $'\nThere are currently no archived repositories'
    return 1
  fi

  #displaying all available respositories
	echo $'\nRespositories available to un-archive:'
	ls archives | sed -n 's/\.tar.gz$//p'

	#getting user option of repository
	repo="repoName"
	path="pathName"

  #looping till valid file is enterered
  until [[ -e "archives/$path" ]]; do
    #getting repository name from user
    read -p $'\nRepo: ' repo
    #path to archived repo
    path="$repo.tar.gz"

    #displaying message if the repository entered does not exist
    if [[ ! -e "archives/$path"  ]]; then
      echo 'archive not found'
    fi
	done

	#unarchive the file
	tar xvzf archives/$path

	#copy contents over
	cp -r archives/repositories/$repo/. repositories/$repo/ >/dev/null 2>&1

	#remove archived file
	rm -r archives/$path

	# checking if repository was unarchived successfully
	if [[ ! -d "repositories/$repo" ]]; then
		echo $'\nERROR when unarchiving repository'
	else
		echo 'Repository unarchived successfully!'
	fi
	}

#main sequence of script start up

#making program folders required for functioning
if [[ ! -d "repositories" ]]; then
	mkdir repositories
fi

if [[ ! -d "workingDir" ]]; then
	mkdir workingDir
fi

if [[ ! -d "archives" ]]; then
	mkdir archives
fi

#looping the menu till exit
while [[ $exit != 1 ]]; do
	menuPrompt exit
done
