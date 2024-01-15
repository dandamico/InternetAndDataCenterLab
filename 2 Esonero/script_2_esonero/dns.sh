#!/bin/sh

cd damicodaniele
touch lab.conf


while true; do  #finchè c'è una macchina
 echo "C'è un'altra macchina? (Insert name of machine without dns, q for exit)"
    read name
    # shellcheck disable=SC2039
    if [ "$name" = "q" ] || [ $name = "Q" ]
    then echo "FINITO"
         break
    else
      fullDnsName=dns$name  #es. dnsroot
      nameStartUpFile=$fullDnsName.startup    #es. dnsroot.startup

      touch $nameStartUpFile

      while true; do  #finchè il router ha un collegamento
        echo "Inserisci un ip/netmask collegata a questa macchina $fullDnsName ('q' se finiti i collegamenti alla macchina):"
        read ip
        # shellcheck disable=SC2016
        # shellcheck disable=SC2034

        echo "A che interfaccia? (solo numero eth già c'è)"
        read interface

        echo "ip address add $ip dev eth$interface" >> $nameStartUpFile  #dentro un ciclo

        echo "Su che LAN è questa interfaccia? (per il lab.conf ESEMPIO: A):"
        read lan
        # shellcheck disable=SC1087
        echo "$fullDnsName[$interface]=$lan" >> lab.conf
      done


      echo "E' un pc? (Press any bottom for no, 'y' yes)"
      read pc
      if pc -ne y
      then
        echo "systemctl start named" >> $nameStartUpFile
      else
        break
      fi

    # shellcheck disable=SC1087
    echo "$fullDnsName[image]="kathara/base"" >> lab.conf


    fi
 done