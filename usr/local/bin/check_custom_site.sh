#!/bin/sh
#
# Author Konstantinos Tompoulidis - 22/12/2016
#

#site="${site_url}"
site="$1"

max_timeout="5" # seconds
total_timeout="$((max_timeout+1))"

code="$(timeout "${total_timeout}"s curl -m "${max_timeout}" -L -s -o /dev/null -I -w "%{http_code}" "${site}")"


if [ $? -gt 0 ] ; then
    echo "the command failed"
    exit 3
fi

if [ -z "${code}" ]; then
    echo "Critical : No response"
    exit 3
fi

if [ "${code}" -eq "000" ]; then
    echo "Critical : Not a proper response"
    exit 2
fi

if [ "${code}" -ne "200" ]; then
    echo "Warning : Not the expected status code"
    exit 1
fi

echo "OK"
exit 0
