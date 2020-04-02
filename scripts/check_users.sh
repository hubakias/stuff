#!/bin/bash

# GPL v2

# Check how many users are logged in, how many times each
# user, for how long and report based on preset thresholds.

# Depends on "coreutiles" and "acct" packages.

user_max_limit=2 # TODO: pass it as a CLI arg


users="$(users)"
nr_total_users="$(wc -w <<< "$users")"
users_over_max_limit="$(echo "$users" | tr ' ' '\n' | sort | uniq -c | sort -r \
  | awk -v user_max_lim=$user_max_limit '$1 > user_max_lim {print "("$1")"$2}' \
  | tr '\n' ',' |sed "s/,$/\\n/")"

echo "$users" "$users_over_max_limit" "$nr_total_users"

echo "6 > 3" |bc -l

ac -a -p

last | grep still | awk '{print $4" "$5" "$6" "$7}'
echo "6 > 3" |bc -l


users="kostikas kostikas kostikas kostikas kostikas kostikas gfd gfd gfd gfd kostikas gfd ouiuio ouiuio kostikas gfd"
echo $users | tr ' ' '\n' | sort | uniq -c | sort -r
