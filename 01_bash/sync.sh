#!/bin/bash

sync_logfile=${sync_logfile:="/var/log/sync/sync.log"}

if ! [ -w "$sync_logfile" ]
then
  touch "$sync_logfile" 2>/dev/null || ( echo "Cannot access log file '$sync_logfile'" > /dev/stderr ; exit 1 )
  exit 1
fi

function log() {
  echo "[$(date)] - [$1] - [PID: $$] - $2" >> "$sync_logfile"
}

log "INF" "Syncing directory '$1' to '$2'"

# allow only one instance of the script
# TODO: could be improved to allow instances with different directories
script_name=$(basename $0)
for pid in $( /usr/sbin/pidof -x "$script_name" ) ; do
  if [ $pid != $$ ]; then
    log "INF" "'$script_name' is already running, canceling current run"
    exit 0
  fi
done

if [ $# -ne 2 ]
then
  log "ERR" "The script accepts exactly 2 arguments"
  exit 1
fi

if ! [ -d "$1" ]
then
  log "ERR" "Can't find directory '$1'"
  exit 1
fi

if ! [ -d "$2" ]
then
  mkdir -p "$2" || ( log "ERR" "Couldn't find or create directory '$2'" ; exit 1 )
fi

orig_path=$( cd "$1" ; pwd )
back_path=$( cd "$2" ; pwd )
if [[ "$orig_path" == "$back_path"* ]] || [[ "$back_path" == "$orig_path"* ]]
then
  log "ERR" "Sync and backup directories cannot be part of each other"
  exit 1
fi

# list all files and dirs, append slash at the end for dirs, ignore errors for cases with empty orig/back dirs
curr=$( cd "$1" ; find ** -type d -printf "%p/\n" -o -print 2>/dev/null )
prev=$( cd "$2" ; find ** -type d -printf "%p/\n" -o -print 2>/dev/null )

# reverse the removed list to remove files and deeper directories first
removed=$( echo "$prev" | grep -Fxv "$curr" | tac )
added=$( echo "$curr" | grep -Fxv "$prev" )

test -n "$removed" &&
  echo "$removed" |
  while IFS= read -r file
  do
    full_back_path="${back_path}/${file}"
    if [ "${file: -1}" == "/" ]
    then
      rmdir "$full_back_path" 2>/dev/null && log "SUC" "Removed directory '$file' in '$back_path'" || log "ERR" "Failed to remove directory '$file' in '$back_path'"
    else
      rm "$full_back_path" 2>/dev/null && log "SUC" "Removed file '$file' from '$back_path'" || log "ERR" "Failed to remove file '$file' from '$back_path'"
    fi
  done

test -n "$added" &&
  echo "$added" |
  while IFS= read -r file
  do
    full_back_path="${back_path}/${file}"
    full_orig_path="${orig_path}/${file}"
    if [ "${file: -1}" == "/" ]
    then
      mkdir "$full_back_path" 2>/dev/null && log "SUC" "Created directory '$file' in '$back_path'" || log "ERR" "Failed to create directory '$file' in '$back_path'"
    else
      cp "$full_orig_path" "$full_back_path" 2>/dev/null && log "SUC" "Copied file '$file' from '$orig_path' to '$back_path'" || log "ERR" "Failed to copy file '$file' from '$orig_path' to '$back_path'"
    fi
  done

log "INF" "Finished syncing directory '$1' to '$2'"
