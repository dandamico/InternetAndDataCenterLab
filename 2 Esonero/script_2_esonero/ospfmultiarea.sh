#!/bin/sh

#startOfRouterBackBone=${1}
numberOfRouter=${2}
# shellcheck disable=SC2034
alfaRouterBackBone=${3}
i=${1}  #numero di partenza del router

# shellcheck disable=SC2164
cd damicodaniele
touch lab.conf
chmod 777 lab.conf

if [ $i -eq 0 ] #se parte da
then
  numberOfRouter=$((numberOfRouter-1))
fi

# shellcheck disable=SC2039
while [[ $i -le $numberOfRouter ]] ; do   #finchè c'è un router nell'area -le=minore uguale
  nameStartupFile="${3}""$i".startup    #es. r1.startup
  fullNameRouter="${3}""$i"    #es. r1 o bb1
  touch $nameStartupFile   #crea file di startup dei router
  chmod 777 $nameStartupFile
  echo "Numero di interfacce del router $fullNameRouter? (Numero esatto delle interfacce del router)"
  read interface
  j=0 #numero di interfaccia
  while [[ $j -lt $interface ]] ; do
    echo "IP/NETMASK router $fullNameRouter eth$j: (es. 192.168.6.3/24)"
    read ip
    echo "ip address add $ip dev eth$j" >> $nameStartupFile  #dentro un ciclo
    echo "LAN eth$j per router $fullNameRouter? (per il lab.conf ESEMPIO: a, verrà reso maiuscolo dopo):"
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
  cp example_conf_daemons_ospf_multi/etc/frr/daemons damicodaniele/"${3}"$i/etc/frr/daemons
  cp example_conf_daemons_ospf_multi/etc/frr/vtysh.conf damicodaniele/"${3}"$i/etc/frr/vtysh.conf
  touch damicodaniele/"${3}"$i/etc/frr/frr.conf

  cd damicodaniele

  echo "!
! FRRouting configuration file
!
!
!  OSPF CONFIGURATION
!
! If exist cost
! interface eth0
! ospf cost 90
!
! Default cost for exiting an interface is 10
!
" >> "${3}"$i/etc/frr/frr.conf

  echo "router ospf" >> "${3}"$i/etc/frr/frr.conf

  echo "! Segnare le network a cui collegato (nell'esempio collegato a 3 network con 3 nell'area di stub)
! network 10.0.0.0/16 area 0.0.0.0
! network 100.0.0.0/30 area 1.1.1.1
! network 110.0.0.0/30 area 2.2.2.2
! network 120.0.0.0/30 area 3.3.3.3
! area 1.1.1.1 stub
! area 2.2.2.2 stub
! area 3.3.3.3 stub" >> "${3}"$i/etc/frr/frr.conf

  echo "redistribute connected
!
!
log file /var/log/frr/frr.log" >> "${3}"$i/etc/frr/frr.conf

  i=$((i + 1))
done

