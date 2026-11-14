#!/usr/bin/env bash

if [ $(id -u) -ne 0 ]; then 
  echo "[!]ERROR  this script needs to be run as root"
  exit 1 
fi 

interface=$(ip -br a | awk '{if  ($1 ~ "^wl" && $2 == "UP") print $1}' | head -n 1)

if [ $1 -ne "start" && $1 -ne "status" && $1 -ne "stop" ]; then 
  echo "[!]ERROR  unviable option"
  exit 1
fi 

systemctl $1 promiscuous@$interface.service
