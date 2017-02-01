#!/bin/bash

aws iam list-users --query "Users[].[UserName]" --output text | while read User; do
  SaveUserName="$User"
  SaveUserName=${SaveUserName//"+"/".plus."}
  SaveUserName=${SaveUserName//"="/".equal."}
  SaveUserName=${SaveUserName//","/".comma."}
  SaveUserName=${SaveUserName//"@"/".at."}
  if grep "$SaveUserName" /etc/passwd > /dev/null; then
    echo "$SaveUserName exists"
  else
    /usr/sbin/useradd "$SaveUserName"

    # sudo will read each file in /etc/sudoers.d,
    # skipping file names that end in ‘~’ or contain a ‘.’ character
    # to avoid causing problems with package manager or editor temporary/backup files.
    # Uncomment the following lines if you need to give all users sudo privileges

    # SaveUserFileName=$(echo "$SaveUserName" | tr "." " ")
    # echo "$SaveUserName ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$SaveUserFileName"
  fi
done
