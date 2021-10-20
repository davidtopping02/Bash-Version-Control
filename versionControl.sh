#! /bin/bash

checkIn(){

  #displaying all available respositories
  echo "Which repository would you like to check a file into:"
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
  echo $'\nfiles available to check in'
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



  #displaying message if move of directory worked
  if [[ -f "repositories/$repo/$fileToCheckIn"  ]]; then
    echo 'File checked in succesfully!'
  else
    echo "Error in checking in file '$fileToCheckIn'"
  fi

}


checkOut(){

  #displaying all available respositories
  echo 'Respositories available:'
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

  fileTo="fileTo"

  #displaying all files that can be checked out
  echo $'\nfiles available to check out'
  ls repositories/$repo

  #looping till valid file is enterered
  until [[ -f "repositories/$repo/$fileTo" ]]; do

    #getting user option of file to be
    read -p $'\nfile to : ' fileTo

    #displaying message if the file entered does not exist
    if [[ ! -f "repositories/$repo/$fileTo"  ]]; then
      echo 'file does not exist'
    fi
  done


  #moving file to be checked out to working directory
  if [[ ! -d workingDir/$repo ]]; then
      mkdir workingDir/$repo
  fi
  mv repositories/$repo/$fileTo workingDir/$repo

  #displaying message if move of directory worked
  if [[ -f "workingDir/$repo/$fileTo"  ]]; then
    echo 'File checked out succesfully!'
  else
    echo "Error in checking out file '$fileTo'"
  fi

}

checkIn
