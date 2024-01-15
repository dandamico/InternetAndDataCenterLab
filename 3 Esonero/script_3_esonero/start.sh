#!/bin/sh
chmod u+x start.sh

mkdir damicodaniele

echo "Che esercizio è?\n 1)BGP\n 2)OSPF\n 3)DNS\n 4)RIP\n 5)STATIC ROUT"
read type

if [ $type -eq 1 ]  #BGP
then
  echo "Quante aree?(Numero esatto di aree)"
  read totalArea
  k=0
    # shellcheck disable=SC2039
  while [ $k -lt $totalArea ] ; do
    echo "Radice Alfabetica dei router nell'area $k? (es. as100r)"
    read alfaRouter

    echo "La parte numerica dei ruoter di quest'area partono da 0 o 1?"
    read startNumberOfRouter

    echo "Quanti Router ci sono? (verrà fatto il minore uguale)"
    read totNumberOfRouter

    /bin/bash ./bgp.sh $startNumberOfRouter $totNumberOfRouter $alfaRouter
    k=$((k + 1))
  done


elif [ $type -eq 2 ]  #OSPF
then
  echo "OSPF?(Digitare il numero della opzione desiderata)\n 1)MultiArea\n 2)SingleArea"
  read ospftype

  if [ $ospftype -eq 1 ]  #OSPF-multiarea
  then
    echo "Quante aree?(Numero esatto di aree)"
    read totalArea
    chmod u+x ./ospfmultiarea.sh
    k=0
    # shellcheck disable=SC2039
    while [ $k -lt $totalArea ] ; do
      echo "Radice Alfabetica dei router nell'area $k? (es. r bb aa ab)"
      read alfaRouterBackBone

      echo "La parte numerica dei ruoter di quest'area partono da 0 o 1?"
      read startOfRouterBackBone

      echo "Quanti Router nell'area $k? (verrà fatto il minore uguale)"
      read numberOfRouter

      /bin/bash ./ospfmultiarea.sh $startOfRouterBackBone $numberOfRouter $alfaRouterBackBone $k
      k=$((k + 1))
    done
  fi


  if [ $ospftype -eq 2 ]  #OSPF SINGLE AREA
  then
    echo "Radice Alfabetica dei router nell'area? (es. r bb aa ab)"
    # shellcheck disable=SC2162
    read alfaRouterBackBone

    echo "La parte numerica dei ruoter di quest'area partono da 0 o 1?"
    read startOfRouterBackBone

    echo "Quanti Router ci sono nell'area? (verrà fatto il minore uguale)"
    read numberOfRouter

    #chmod u+x ./ospfsinglearea.sh
    # shellcheck disable=SC2086
    /bin/bash ./ospfsinglearea.sh "$startOfRouterBackBone" "$numberOfRouter" $alfaRouterBackBone
  fi

elif [ $type -eq 3 ]  #DNS
then
  chmod u+x ./dns.sh

  echo "Quante macchine ci sono?"
  read totalElement

  k=0
  while [ $k -lt $totalElement ] ; do
      echo "Come si chiama la macchina? (es. r bb aa ab)"
      read nameOfElement


      /bin/bash ./dns.sh $nameOfElement
      k=$((k + 1))
    done

elif [ $type -eq 4 ] #RIP
then
  echo "Radice Alfabetica dei router nell'area? (es. r bb aa ab)"
  read alfaRouterBackBone

  echo "La parte numerica dei ruoter di quest'area partono da 0 o 1?"
  read startOfRouterBackBone

  echo "Quanti Router ci sono? (verrà fatto il minore uguale)"
  read numberOfRouter

  #chmod u+x ./rip.sh
  /bin/bash ./rip.sh $startOfRouterBackBone $numberOfRouter $alfaRouterBackBone


elif [ $type -eq 5 ]  #STATIC
then
  echo "Radice Alfabetica dei router nell'area? (es. r bb aa ab)"
  read alfaRouterBackBone

  echo "La parte numerica dei ruoter di quest'area partono da 0 o 1?"
  read startOfRouterBackBone

  echo "Quanti Router ci sono? (verrà fatto il minore uguale)"
  read numberOfRouter

  /bin/bash ./static.sh $startOfRouterBackBone $numberOfRouter $alfaRouterBackBone


fi  #fine

echo "Speramo bene"
