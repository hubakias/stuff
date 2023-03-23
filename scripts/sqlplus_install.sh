#!/bin/bash

INSTDIR="/opt/oracle"
mkdir -p ${INSTDIR}
cd ${INSTDIR} || exit

url="https://download.oracle.com/otn_software/linux/instantclient"

curl -s ${url}/instantclient-sqlplus-linuxx64.zip | bsdtar -xf-
curl -s ${url}/instantclient-basiclite-linuxx64.zip | bsdtar -xf-

ORACLE_HOME="$(find $INSTDIR/instantclient* -maxdepth 0 -type d | tail -n1)"
chown -R root:root "$ORACLE_HOME"
chmod 555 "$ORACLE_HOME"/sqlplus
export ORACLE_HOME
export PATH="$PATH:$ORACLE_HOME"
export LD_LIBRARY_PATH="$ORACLE_HOME"

bold=$(tput bold)
normal=$(tput sgr0)

url="https://www.oracle.com/database/technologies/instant-client"
ver="$(curl -s ${url}/linux-x86-64-downloads.html | sed -n "s/.*Version //p" | \
  head -n1 | cut -d' ' -f1)"

echo -e "\n  SQL Plus version: ${bold}${ver}${normal} installed.\n
  Consider setting in your .bashrc:\n
  ${bold}ORACLE_HOME${normal}=\"$ORACLE_HOME\"
  ${bold}LD_LIBRARY_PATH${normal}=\"\$ORACLE_HOME\"
  ${bold}PATH${normal}=\"\$PATH:\$ORACLE_HOME\"\n"
