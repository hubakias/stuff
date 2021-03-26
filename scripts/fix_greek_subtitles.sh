#!/bin/bash

# Simple script to convert a .srt file from ISO-8859-7 to UTF-8

if [ ! "$1" ]; then
  echo "Please provide an srt, ISO-8859 encoded, file."; exit 1
fi

if [ ! "${1/*\./}" == "srt" ]; then
  echo "Only srt file extensions are supported."; exit 1
fi

#if [ ! "$(file -b "$1" | cut -d ' ' -f1)" == "ISO-8859" ]; then
#  echo "The input file must be ISO-8869 encoded."; exit 1
#fi

iconv -f ISO-8859-7 -t utf8 "${1}" -o "${1}".fixed
mv -f "${1}".fixed "${1}"
sed -i "s/\\’/'Α/" "${1}"

