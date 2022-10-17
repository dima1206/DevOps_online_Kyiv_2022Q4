#!/bin/bash

# limits all list to 3 entries by default
# use '-a' option to see full lists
if [ "$1" = "-a" ]
then
  function limit_output() { cat ; }
  shift
else
  function limit_output() { head -n3 ; }
fi

if ! [ -f "$1" ]
then
  echo "Can't locate file '$1'"
  exit 1
fi

logfile="$1"

rating=$(cat "$logfile" | cut -d' ' -f1 | sort | uniq -c | sort -nr)

echo "1. IP with most requests:"
echo "$rating" | head -n1 | awk '{print $2}'
echo

echo "2. Most requested page:"
cut -d'"' -f2 "$logfile" | cut -d' ' -f2 | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}'
echo

echo "3. Number of requests from each IP:"
echo "$rating" | limit_output
echo

echo "4. Requested non-existent pages:"
cut -d'"' -f2,3 "$logfile" | awk '$4 == "404" {print $2}' | sort | uniq | limit_output
echo

echo "5. Peak hour was the hour starting from:"
cut -d' ' -f4,5 "$logfile" | sed -e 's/\[//' -e 's/\]//' -e 's/\(:[0-9]\{2\}\)\{2\} / /' | uniq -c | sort -nr | head -n 1 | awk '{print $2 ":00:00 " $3}'
echo

echo "6. Clients that have 'bot' in their UA:"
cut -d'"' -f1,6 "$logfile" | sed -e 's/ - - \[.*\] "/ /' | grep -i bot | sort | uniq | limit_output
echo
