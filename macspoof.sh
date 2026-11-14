#!/usr/bin/env bash 

# exit upon failrue of any command
set -eo pipefail

if [[ $(id -u) -ne 0 ]]; then 
  echo "run the script as root" >&2
  exit 1
fi


interface=$(ip -brief link show | awk '{ if ($2 == "UP") print $1}' | head -n 1)

if [[ -z "$interface" ]]; then
  echo "no interfaces online"
  exit 1
fi

MAC=$(ip -brief link show | awk '{ if ($2 == "UP") print $3}')
# this is terrible 
randMAC=$(hexdump -n6 -e '/1 ":%02X"' /dev/random|sed s/^://g)
newMAC=${MAC:0:9}${randMAC:9}

echo "[*] bringing $interface down"
ip link set dev "$interface" down

echo "[*] applying MAC to $interface "
ip link set dev "$interface" address "$newMAC"

echo "[*] bringing $interface up"
ip link set dev "$interface" up 

echo "[+] success"
echo "$MAC" "->" "$newMAC"
