#!/bin/sh

#startOfRouterBackBone=${1}
numberOfRouter=${2}
i=${1}
alfaRouterBackBone=${3}

cd damicodaniele
touch lab.conf
chmod 777 lab.conf

if [ $i -eq 0 ] #se parte da
then
  numberOfRouter=$((numberOfRouter-1))
fi

# shellcheck disable=SC2039
while [[ $i -le $numberOfRouter ]] ; do   #finchè c'è un router nell'area
  #echo ${3}$i  #check se while corretto

  nameStartupFile="${3}""$i".startup    #es. r1.startup
  fullNameRouter="${3}""$i"    #es. r1 o bb1
  touch $nameStartupFile   #crea file di startup dei router
  chmod 777 $nameStartupFile

  echo "Numero di interfacce del router $fullNameRouter? (Numero esatto delle interfacce del router, verrà fatto minore e basta)"
  read interface
  j=0 #numero di interfaccia
  while [[ $j -lt $interface ]] ; do
    echo "ip/netmask router $fullNameRouter eth$j:"
    read ip
    echo "ip address add $ip dev eth$j" >> $nameStartupFile  #dentro un ciclo
    echo "LAN eth$j per router $fullNameRouter? (per il lab.conf ESEMPIO: A):"
    read lan
      # shellcheck disable=SC1087
    echo "$fullNameRouter[$j]=${lan^^}" >> lab.conf

    j=$((j + 1))

  done

  echo "$fullNameRouter""[image]="kathara/frr"" >> lab.conf
  echo "systemctl start frr" >> $nameStartupFile

    #Crea cartelle per demone
  mkdir "${3}"$i "${3}"$i/etc "${3}"$i/etc/frr
  cd .. #usciamo dalla cartella damicodaniele
  cp example_deamons_rip/etc/frr/daemons damicodaniele/"${3}"$i/etc/frr/daemons
  cp example_deamons_rip/etc/frr/vtysh.conf damicodaniele/"${3}"$i/etc/frr/vtysh.conf
  touch damicodaniele/"${3}"$i/etc/frr/frr.conf

  cd damicodaniele

  echo "!
! FRRouting configuration file
!
!
!  RIP CONFIGURATION
!
!" >> "${3}"$i/etc/frr/frr.conf

  echo "router rip" >> "${3}"$i/etc/frr/frr.conf

  echo "redistribute connected
!
!" >> "${3}"$i/etc/frr/frr.conf

  echo "! Segnare le network a cui collegato (esempio: network 100.1.0.0/24)" >> "${3}"$i/etc/frr/frr.conf
  echo "log file /var/log/frr/frr.log" >> "${3}"$i/etc/frr/frr.conf
  i=$((i + 1))
done