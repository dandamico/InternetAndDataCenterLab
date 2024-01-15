#!/bin/sh
#startOfRouterBackBone=${1}
nameRouter=${1}
# shellcheck disable=SC2034

cd damicodaniele
touch lab.conf
chmod 777 lab.conf

# shellcheck disable=SC2039

  nameStartupFile="${1}".startup    #es. r1.startup
  fullNameRouter="${1}"    #es. as100r1 o as200r2
  touch "$nameStartupFile"   #crea file di startup dei router
  chmod 777 "$nameStartupFile"

  echo "Numero di interfacce del router $fullNameRouter? (Numero esatto delle interfacce del router)"
  read interface
  j=0 #numero di interfaccia
  while [[ $j -lt $interface ]] ; do
    echo "IP/NETMASK router $fullNameRouter eth$j:"
    read ip
    echo "ip address add $ip dev eth$j" >> $nameStartupFile  #dentro un ciclo
    echo "LAN eth$j per router $fullNameRouter? (per il lab.conf ESEMPIO: a, verrà reso maiuscolo dopo):"
    read lan
    # shellcheck disable=SC1087
    echo "$fullNameRouter[$j]=${lan^^}" >> lab.conf

    j=$((j + 1))

  done

  echo "$fullNameRouter""[image]="kathara/base"" >> lab.conf
  echo "systemctl start named" >> $nameStartupFile

  #Crea cartelle per demone
  #mkdir "${1}" "${1}"/etc "${1}"/etc/frr
  mkdir "${1}"
  cd .. #usciamo dalla cartella damicodaniele

  echo "che tipo è? 1)ROOT 2).com 3)Locale 4)Pc"
  read type_name_server
  if [ "$type_name_server" -eq 1 ]; then
    echo "It's root"
    cp -r example_dns_dnsroot/etc/ damicodaniele/"${1}"/

  elif [ "$type_name_server" -eq 2 ];then
    echo "It's .com"
    cp -r example_dns_com/etc/ damicodaniele/"${1}"/

  elif [ "$type_name_server" -eq 3 ];then
    echo "It's local"
    cp -r example_dns_local/etc/ damicodaniele/"${1}"/

    elif [ "$type_name_server" -eq 4 ];then
    echo "It's pc"
    cp -r example_dns_pc/etc/ damicodaniele/"${1}"/

  fi

  #cp example_conf_daemons_bgp/etc/frr/daemons damicodaniele/"${1}"/etc/frr/daemons
  #cp example_conf_daemons_bgp/etc/frr/vtysh.conf damicodaniele/"${1}"/etc/frr/vtysh.conf
  #touch damicodaniele/"${1}"/etc/frr/frr.conf

  cd damicodaniele

