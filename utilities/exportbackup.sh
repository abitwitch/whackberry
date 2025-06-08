#!/usr/bin/env bash

echo "
This is a export utility designed to backup all the material on this device.
It will:
  - Backup all the passwords stored using 'pass' (in the defult database location)
  - Backup all the .gpg files located in /$HOME/mydata
All content will be converted to plaintext, then encrypted with a password into a 7z file in the /$HOME/exports folder.
This file can then be transfered to the SD Card. 

It will require you to enter the existing password for your key and the new password for the 7z file multiple times.

You MAY be prompted for your password manager password. Press enter to continue.
"
read

output_filename=$HOME/exports/export-$(date '+%Y-%m-%d').7z
mkdir -p $HOME/exports

# export passwords to external file
shopt -s nullglob globstar
prefix=${PASSWORD_STORE_DIR:-$HOME/.password-store}

target_file="/mnt/ramdisk/passwords.txt"
echo "Exporting passwords..."

for file in "$prefix"/**/*.gpg; do
    file="${file/$prefix//}"
    printf "%s\n" "Name: ${file%.*}" >> "$target_file"
    pass "${file%.*}" >> "$target_file"
    printf "\n\n" >> "$target_file"
done
echo "You will now be promted for the password used for encrypted the 7z file. Press enter to continue."
read
7z a "$output_filename" "$target_file" -p
rm "$target_file"

echo "Exporting files .gpg in $HOME/mydata..."
for file in $HOME/mydata/*.gpg; do
    temp_file=/mnt/ramdisk/$(basename "$file")
    echo ==
    echo $temp_file
    temp_file="${temp_file::-4}"
    echo ==
    echo $temp_file
    echo ==
    echo "You MAY now be promted for the password used for $file. Press enter to continue."
    read
    gpg --output "$temp_file" --decrypt "$file"
    echo "You will now be promted for the password used for encrypted the 7z file. Press enter to continue."
    read
    7z a "$output_filename" "$temp_file" -p
    rm "$temp_file"
done

echo "

Backup completed.
Location: $output_filename
You may now transfer this file to the SD Card.

"

