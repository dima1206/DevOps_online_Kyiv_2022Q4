#!/bin/bash

read -d '' usage << EOF
Script usage:
	$0 [option]
Available options:
	--all          - scans current subnet(s) and outputs
	-a               IPs and symbolic names of found hosts

	--target <IP>  - scans given host for open TCP ports
	-t <IP>          and outputs them

Note: Make sure that nmap is installed before using the script
EOF

function list_options() {
  echo "$usage"
}

function check_nmap() {
  if ! command -v nmap &> /dev/null
  then
    echo "Install nmap before using this script" > /dev/stderr
    exit 1
  fi
}

# scan current subnets
function scan_subnet() {
  check_nmap
  echo "Scanning..."
  ip -o address | grep "scope global" | awk '{print $4}' |
    while read -r subnet
    do
      echo "Subnet $subnet:"
      nmap -oG /dev/stdout -sn "$subnet" | grep "Host: " | awk '{print $2 " " $3}' | sed -e 's/()/<Unknown>/' | sed -e 's/[()]//g'
    done
}

# scan given target
function scan_target() {
  check_nmap

  local rgx='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
  if ! [[ "$1" =~ ^$rgx\.$rgx\.$rgx\.$rgx$ ]]
  then
    echo "'$1' is not a valid IP address" > /dev/stderr
    exit 1
  fi

  echo "Scanning..."
  nmap -oG /dev/stdout $1 | grep "Ports:" | cut -d"	" -f2 | sed -e 's/Ports: //' -e 's/,//g' | tr " " "\n" | awk -F'/' '{ if ($2 == "open") { print $1 } }'
}

case "$1" in
  --all|-a) scan_subnet ;;
  --target|-t) scan_target $2 ;;
  "") list_options ;;
  *) echo "Unrecognized option '$1'" ; list_options ; exit 1 ;;
esac

