#!/bin/bash

# workaround for bashtrap issues
file=$(echo $1)
filecopy="$file.copy"

# trap user attempts to exit program
trap bashtrap SIGINT SIGTERM

bashtrap()
{
	clear
    echo "CTRL+C Detected! Removing partially copied file."
    ssh ramnode -t "rm /var/www/justinsinkula.com/public_html/files/$file"
    rm ./$filecopy
    exit 1
}

# make copy of file with proper permissions
cp ./$file ./$filecopy
chmod 744 ./$filecopy


# make sure user passes file as argument
if [ $# -lt 1 ]; then
  echo 1>&2 "Please select a file to upload. (i.e. share file.mp3)"
  exit 2
fi

# copy files to remote server
scp -q -P 443 ./$filecopy root@192.184.82.89:/var/www/justinsinkula.com/public_html/files/$file

# let user know file was uploaded
echo 'File uploaded.'

# print share link
echo "Share link: http://justinsinkula.com/files/$file"

# remove copied file
rm ./$filecopy
