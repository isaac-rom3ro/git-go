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

isNameSet() {
  name=$(git config --global user.name)

  if [[ -z "$name" ]]; then
    echo false
  else 
    echo true
  fi  
}

isEmailSet() {
  email=$(git config --global user.email)

  if [[ -z "$email" ]]; then
    echo false
  else 
    echo true
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

sshExists() {
  sshPublicKey="$HOME/.ssh/id_ed25519.pub"

  if [ -e "$sshPublicKey" ]; then
    echo true
  else 
    echo $(sshGenerate)
  fi
}

sshGenerate() {
  email=$(git config --global user.email)
  
  ssh-keygen -t ed25519 -C "$email"

  if [$? -eq 0]; then
    echo true
  else 
    echo false
  fi
}

gitInstalled=$(isGitInstalled)
name=$(isNameSet)
email=$(isEmailSet)
ssh=$(sshExists)

if [ gitInstalled ]; then
  if (( name != true)); then
    setName
  fi

  if (( email != true)); then
    setEmail
  fi
 
  if (( ssh != true )); then
    echo "Error while trying to generate the ssh"
    exit 1
  fi


fi 

exit 0
