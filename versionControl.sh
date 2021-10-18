#! /bin/bash

#add code
checkout(){

  #displaying all available respositories
  echo 'Respositories available:'
  ls repositories

  #getting user option of repository
  # STR="Hello World!"
  repo="repoName"

  #looping till valid repository is enterered
  until [[ -d "repositories/$repo" ]]; do

    #getting repository name from user
    read -p $'\nRepo: ' repo

    #displaying message if the repository entered does not exist
    if [[ ! -f "repositories/$repo"  ]]; then
      echo 'repository does not exist'
    fi
  done

  fileToCheckOut="fileToCheckOut"

  #displaying all files that can be checked out
  echo $'\nfiles available to check out'
  ls repositories/$repo

  #looping till valid file is enterered
  until [[ -f "repositories/$repo/$fileToCheckOut" ]]; do

    #getting user option of file to be checkout
    read -p $'\nfile to checkout: ' fileToCheckOut

    #displaying message if the file entered does not exist
    if [[ ! -f "repositories/$repo/$fileToCheckOut"  ]]; then
      echo 'file does not exist'
    fi
  done


  #moving file to be checked out to working directory
  mv repositories/$repo/$fileToCheckOut workingDir

  #displaying message if move of directory worked
  if [[ -f "workingDir/$fileToCheckOut"  ]]; then
    echo 'File checked out succesfully!'
  else
    echo "Error in checking out file '$fileToCheckOut'"
  fi

}

checkout
