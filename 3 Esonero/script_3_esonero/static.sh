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

  echo "$fullNameRouter""[image]="kathara/base"" >> lab.conf
  echo "systemctl start named" >> $nameStartupFile
  #cd ..
  #cd damicodaniele

  i=$((i + 1))
done