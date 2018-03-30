#!/bin/bash

# keep leading whitespaces
j=0
while read line ; do

  if [ "${line}" == '@<TRIPOS>MOLECULE' ]; then

    if [ ${j} = 1 ] ; then
      ifp=$(IChem --polar IFP sitio_chimera.mol2 tmp.mol2 | tail -1) 
      mol=$(awk 'f{print;f=0} /@<TRIPOS>MOLECULE/{f=1}' tmp.mol2)
      echo ${mol} ${ifp}
      j=0 
    fi

    let j+=1
    echo -e "${line}" > tmp.mol2

  else
    echo -e "${line}" >> tmp.mol2

  fi

done < teste.mol2

