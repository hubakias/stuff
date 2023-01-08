#!/bin/bash

if [ "$(file -b "$1" | awk '{print $1}' | grep UTF-8)" ]; then
  echo "It seems the file is already UTF-8 encoded. Nothing to do..."
  exit 1
fi

if [ ! "$(file -b "$1" 2>/dev/null | awk '{print $1}' | grep ISO-8859)" ]; then
  echo "Please provide an ISO-8859 encoded srt file."
  exit 1
fi

if [ ! "${1/*\./}" == "srt" ]; then
  echo "Only srt file extensions are supported."; exit 1
fi

iconv -f ISO-8859-7 -t utf8 "${1}" -o "${1}".fixed
mv -f "${1}".fixed "${1}"
sed -i "s/\\’/'Α/" "${1}"
sed -i 's/\r$//' "${1}"
