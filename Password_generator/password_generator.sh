#!/bin/bash 
file="passwords.txt"

if [[ ! -f "$file" ]]; then
    touch "$file"
fi
echo "Generating a password for You!"
echo "Enter the number of characters"
read len
if (( len < 3 ));then
  echo "Too short must be atleast 3"
  exit 1
fi
echo "1 for alpha-numeric"
echo "2 for alpha-numeric + symbols"
read choice
echo "Enter the name of the password: "
read name
if grep -q "^$name :" "$file";then
  echo "⚠️ A password named $name already exists."
  read -p "Do you want to replace it?? (y/n): " confirm
  if [[ "$confirm" != "y" ]];then
    exit 1
  fi
  sed -i "/^$name :/d" "$file"
fi

upper=$(tr -dc 'A-Z' < /dev/urandom | head -c1)
lower=$(tr -dc 'a-z' < /dev/urandom | head -c1)
digit=$(tr -dc '0-9' < /dev/urandom | head -c1)
special=""
remaining=""

if [[ $choice == "1" ]];then
  remaining=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c $((len - 3)))
elif [[ "$choice" == "2" ]];then
  remaining=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c $((len - 4)))
  special=$(tr -dc '!@#$%^&*_' < /dev/urandom | head -c1)
else
  echo "❌Invalid choice"
  exit 1
fi
p=$(echo "$upper$lower$digit$special$remaining" | fold -w1 | shuf | tr -d '\n')
if echo "$name : $p" >> $file;then
  echo "saved to passwords.txt"
else
  echo "Couldn't save the password"
  echo "password: $p"
fi

if command -v xclip >/dev/null; then
    echo "$p" | xclip -selection clipboard
    echo "Copied to clipboard"
else
    echo "xclip is NOT installed"
fi


