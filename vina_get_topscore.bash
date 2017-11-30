#!/bin/bash
#################################################################### 
#   MetroDock  - MetroChem: Metrology for Computational Chemistry  #
####################################################################
#
# Diego E. B. Gomes(1,2,3) - dgomes@pq.cnpq.br
# Priscila S.F. Celestino Gomes(3) - priscila.@biof.ufrj.br
#
# 1 - Instituto Nacional de Metrologia, Qualidade e Tecnologia - Brazil
# 2 - Coordenacao Aperfeicoamento de Pessoal de Ensino Superior - CAPES - Brazil.
# 3 - Universite de Strasbourg - France
#
#===============================================================================
#
#          FILE:  vina_get_topscore.bash
#
#         USAGE:  ./vina_get_topscore.bash
#
#   DESCRIPTION: Retreive top result from Virtual Screening autodock Vina.
#
#       OPTIONS:  ---
#  REQUIREMENTS:  bash and awk
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Diego E. B. Gomes, dgomes@pq.cnpq.br
#       COMPANY:  Universite de Strasbourg / INMETRO / CAPES
#       VERSION:  1.1
#       CREATED:  Fri Jun 17 14:41:38 CEST 2016
#      REVISION:  Thu Nov 30 12:06:32 CET 2017
#===============================================================================


# Configuration
results_folder="results"
output_file="scores.csv"


######################################################################
#- Do not change anything bellow, unless you know what you're doing. #
######################################################################
if [ -f ${output_file} ] ; then rm -rf ${output_file} ; fi
for i in $(cd ${results_folder} ; ls *.out | cut -d. -f1 ) ; do
  echo -ne "Getting score for ${i} \r"
  awk -v i=${i} '/0.000      0.000/ {print i","$2}' ${results_folder}/${i}.out  >> ${output_file}
done
