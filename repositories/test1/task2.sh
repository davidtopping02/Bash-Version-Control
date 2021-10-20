#!/bin/bash
read -p 'Please enter a random word:'  firstName
echo 'The word you entered was: ' 
echo -n firstName | tr [:lower:] [:upper:]


