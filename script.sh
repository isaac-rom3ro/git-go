#!/bin/bash

installGit () {
  sudo apt install git <<< "Y" > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo true
  else 
    echo false
  fi 
}

isGitInstalled () {
  if command -v git >/dev/null 2>&1; then
    echo true
  else 
    $(installGit)
  fi
}

setName() {
  echo -n "username: "
  read username

  git config --global user.name "$username"
}

setEmail() {
  echo -n "email: "
  read email

  git config --global user.email "$email"
}

gitInstalled=$(isGitInstalled)

if [ gitInstalled ]; then
  setName  
  setEmail
fi
