#!/bin/bash

# encabezado
#BSUB -J process_concolor
#BSUB -q q_hpc
#BSUB -oo salida
#BSUB -eo error
#BSUB -n 8
#BSUB -R "span[hosts=1]"

#Cargo stacks2
module load stacks2/2.0-b8c

#creo directorio de output 

mkdir /tmpu/pindaro_g/cdm_a/maria/RADcap/process_p3

#descompresión archivos

gunzip /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/*

#process 

process_radtags  -1 /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/S_concolor_Pool3.1.1.fq -2 /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/S_concolor_Pool3.2.2.fq -b /tmpu/pindaro_g/cdm_a/maria/RADcap/barcodes_pool3.txt -o /tmpu/pindaro_g/cdm_a/maria/RADcap/process_p3  -c -q -r --inline_inline --renz_1 xbaI --renz_2 ecoRI &>> /tmpu/pindaro_g/cdm_a/maria/RADcap/process.log

