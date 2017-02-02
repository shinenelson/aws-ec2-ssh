#!/bin/bash -e

echo "Invoked AuthorizedKeysCommand"

if [ -z "$1" ]; then
  echo "No User Specified"
  exit 1
fi

echo "Username : $1"

SaveUserName="$1"
SaveUserName=${SaveUserName//"+"/".plus."}
SaveUserName=${SaveUserName//"="/".equal."}
SaveUserName=${SaveUserName//","/".comma."}
SaveUserName=${SaveUserName//"@"/".at."}

echo "SaveUserName : $SaveUserName"

aws iam list-ssh-public-keys --user-name "$SaveUserName" --query "SSHPublicKeys[?Status == 'Active'].[SSHPublicKeyId]" --output text | while read KeyId; do
  echo "KeyId : $KeyId"
  aws iam get-ssh-public-key --user-name "$SaveUserName" --ssh-public-key-id "$KeyId" --encoding SSH --query "SSHPublicKey.SSHPublicKeyBody" --output text
done
