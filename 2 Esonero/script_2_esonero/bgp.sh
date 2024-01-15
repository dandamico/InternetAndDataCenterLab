#!/bin/sh

#startOfRouterBackBone=${1}
numberOfRouter=${2}
# shellcheck disable=SC2034
alfaRouterBackBone=${3}
i=${1}

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
  fullNameRouter="${3}""$i"    #es. as100r1 o as200r2
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

  echo "$fullNameRouter""[image]="kathara/frr"" >> lab.conf
  echo "systemctl start frr" >> $nameStartupFile

  #Crea cartelle per demone
  mkdir "${3}"$i "${3}"$i/etc "${3}"$i/etc/frr
  cd .. #usciamo dalla cartella damicodaniele
  cp example_conf_daemons_bgp/etc/frr/daemons damicodaniele/"${3}"$i/etc/frr/daemons
  cp example_conf_daemons_bgp/etc/frr/vtysh.conf damicodaniele/"${3}"$i/etc/frr/vtysh.conf
  touch damicodaniele/"${3}"$i/etc/frr/frr.conf

  cd damicodaniele

  echo "!
! FRRouting configuration file
!
password zebra
enable password zebra
!
log file /var/log/frr/frr.log
!
!  BGP CONFIGURATION
!
debug bgp keepalives
debug bgp updates in
debug bgp updates out
!
" >> "${3}"$i/etc/frr/frr.conf

#iniziamo la conn bgp
echo "router bgp "$i"" >> "${3}"$i/etc/frr/frr.conf

echo "!---ATTIVARE SE NON SONO PRESENTI POLICY--- (non lo mettamo se ci sono filtri applicati agli annunci)
no bgp ebgp-requires-policy

!---ATTIVARE SE SONO PRESENTI ALTRI PROTOCOLLI--- (lo dobbiamo mettere se stiamo annunciando la rotta di default che non è a noi direttamente connessa subito, quindi non si trova subito nella nostra tabella di routing)
! no bgp network import-check " >> "${3}"$i/etc/frr/frr.conf
#iniziamo con i comandi neighbr
  echo "!
! NEIGHBORS
!
!Segnare i neighbor esempio di router1 (in AS1 con ip 193.10.11.1) e router 2 (in AS2 con ip .2) config. in router 1:
!
!neighbor 11.0.0.33 default-originate (questo perchè sono la rotta di default del mio vicino / client, mi propago come rotta di default)
!neighbor 193.10.11.2 remote-as 2
!neighbor 193.10.11.2 description Router 2 " >> "${3}"$i/etc/frr/frr.conf

echo "

!
! NETWORKS
!
!network 200.1.0.0/16
!network 200.1.128.0/17
!network 0.0.0.0/0
!(questo per iniettare la rotta , per dire che la rotta di default 0.0 è mia)



!
! POLICIES
!
!neighbor 11.0.0.14 prefix-list mineOutOnly out
!neighbor 11.0.0.14 prefix-list defaultIn in
!neighbor 11.0.0.1 prefix-list as100In in
!neighbor 11.0.0.1 prefix-list defaultOut out
!
!ip prefix-list as100In permit 100.1.0.0/16
!ip prefix-list defaultOut permit 0.0.0.0/0
!
!" >> "${3}"$i/etc/frr/frr.conf


# shellcheck disable=SC2027
echo "hostname "$fullNameRouter"-frr" >> "${3}"$i/etc/frr/vtysh.conf

  i=$((i + 1))
done