#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then 
  echo "must run as root"
  exit 
fi

processLine=$(ps -aux | fzf -e)
if [[ -n "$processLine" ]]; then 
  kill $(echo "$processLine" | awk '{print $2}')
else 
  echo "termination canceled"
fi
echo "terminated $( echo $processLine | awk '{print $11}')"
