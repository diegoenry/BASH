#!/bin/bash
# 
# ChemFlow (Tools) - Computational Chemisty is great again
# 
# @author : Diego Enry Barreto Gomes, PhD (1,2)
# @author : Priscila da Silva Figueiredo Celestino Gomes, PhD (3)
#
# @filiations
#   1 - Laboratoire d'Ingénierie des Fonctions Moléculaires, UMR7177 CNRS.
#       Institute de Chimie - Universite de Strasbourg - France
#
#   2 - Grupo de Biologia Computacional - Laboratorio de Macromoleculas.
#       Instituto Nacional de Metrologia, Qualidade e Tecnologia - INMETRO - Brasil.
#
#   3 - Laboratoire d'Innovation Therapeutique, UMR 7200 CNRS.
#       Faculté de Pharmacie - Université de Strasbourg - France.
#
# @brief : Splits a SunGridEngine (SGE) job containing routines to:
#            1 - Split a .mol2 file into single files.
#            2 - Run "IChem" using the "grim" function
#
# @description: 
#   The following SGE script is designed to run the procedure for a list
#   of PDB files to all poses inside a log_'${i}'-results.mol2 input.
# 
#   ${i} here is an index to a SURFLEX log file (mol2), which may contain 
#   multiple poses from multiple docked molecules.
#
#   Splitting the .mol2 file is needed because IChem has some trouble with 
#   this kind multi-mol2 of file.
#
# @update : jeudi 5 avril 2018, 13:45:21 (UTC+0200)
#
#
# Configuration --------------------------------------------------------
#
START=1
END=100
JOBSIZE=10


#***********************************************************
#***********************************************************
# !!! REVIEW THE FILENAMES AND PATHS TO MATCH YOUR OWN !!! #
#***********************************************************
#***********************************************************


#
# FUNCTIONS ------------------------------------------------------------
#
write_sge() {
echo '#! /usr/local/bin/bash -l
#$ -P P_lit
#$ -N ifp_'${FIRST}_${LAST}'
#$ -l os='\''cl7'\''
#$ -l sps=1
#$ -l fsize=4G
##$ -l ct=48:00:00
#$ -q long                                                                           
#$ -o grim_'${FIRST}_${LAST}'.out
#$ -e grim_'${FIRST}_${LAST}'.err
#
## Calculate GRIM to all the poses
#
# Author: Priscila SFC Gomes | pdasilva@unistra.fr
# Author: Diego EB Gomes     | dgomes@pq.cnpq.br
#
# Update: Tue Apr  5 14:05 CEST 2018          
#######################################################

#
# Config ---------------------------------------------------------------
#
#export IChem environment
export ICHEM_LIC="PUT YOUR ICHEM LICENCE HERE"

IChem="PATH TO ICHEM EXECUTABLE"
workdir=${HOME}/myfolder/

#PDB references to be used in GRIM 
list="my list of PDB files"

mol2_folder="where are the .mol2 files to play around with GRIM"

#
# Functions ------------------------------------------------------------
#

splitmol(){
mkdir splited
$splitmol2 ${mol2_folder}/log_'${i}'-results.mol2 ./splited/
poses=$(ls *.mol2)
}

grim(){
for k in ${list}; do

  for FILE in ${poses} ; do

    $IChem -sim 1 -size 1 -rn ${k} -cn ${FILE} grim \
      $workdir/conf1/${k}_A_protoss.mol2 \
      $workdir/lig_refs/${k}_A_protoss_ligand.mol2 \
      ./splited/${FILE}

  done
done

mv Grifp_res.csv $workdir/conf1/grim/Grifp_res_'${i}'.csv

# clean up
rm -rf ./splited/
}


#
# Program --------------------------------------------------------------
#

#call functions
for ((i='${FIRST}';i<'${LAST}';i+='${JOBSIZE}')) ; do
  splitmol
  grim
done
' >job_${FIRST}_${LAST}.sge
}


#
# PROGRAM --------------------------------------------------------------
#

for ((FIRST=${START};FIRST<=${END};FIRST+=${JOBSIZE})) do
  let LAST=${FIRST}+${JOBSIZE}-1
  write_sge
  qsub job_${FIRST}_${LAST}.sge
done
