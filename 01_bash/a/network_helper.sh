#!/bin/bash

read -d '' usage << EOF
Script usage:
	$0 [option]
Available options:
	--all     - scans current subnet and
	-a          outputs found IPs and symbolic names

	--target  - outputs open TCP ports on the
	-t          current system
EOF

function list_options() {
  echo "$usage"
}

function scan_subnet() {
  if ! command -v nmap &> /dev/null
  then
    echo "This option requiers nmap installed"
    exit 1
  fi

  ip -o address | grep "scope global" | awk '{print $4}' |
    while read -r subnet
    do
      echo "Subnet $subnet:"
      nmap -oG /dev/stdout -sn "$subnet" | grep "Host: " | awk '{print $2 " " $3}' | sed -e 's/()/<Unknown>/' | sed -e 's/[()]//g'
    done
}

function list_ports_helper() {
  tail -n +2 $1 | cut -d: -f3 | cut -d' ' -f1 |
    while read -r port
    do
      echo $((0x$port))
    done | sort | uniq
}

function list_ports() {
  echo "TCP:"
  list_ports_helper "/proc/net/tcp"
  echo "TCP6:"
  list_ports_helper "/proc/net/tcp6"
}

if [ $# -gt 1 ]
then
  echo "Only one option is allowed" > /dev/stderr
  list_options
  exit 1
fi

case "$1" in
  --all|-a) scan_subnet ;;
  --target|-t) list_ports ;;
  "") list_options ;;
  *) echo "Unrecognized option '$1'" ; list_options ; exit 1 ;;
esac

