#!/bin/bash

#este script sirve para correr el process_radtags desde Miztli. Se usan rutas absolutas.

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

#descompresión archivosque salieron del clone filter

gunzip /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/*

#correr el programa de process, se ingresan los 2 documentos del pool .fq ya filtrados.
#-b es el archivo de barcodes, c — clean data, remove any read with an uncalled base, q — discard reads with low quality scores, r — rescue barcodes and RAD-Tags.
#--renz son los nombres de las 2 enizimas utilizadas
#Se manda a hacer un archivo .log para guardar todo el procedimiento.

process_radtags  -1 /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/S_concolor_Pool3.1.1.fq -2 /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/S_concolor_Pool3.2.2.fq -b /tmpu/pindaro_g/cdm_a/maria/RADcap/barcodes_pool3.txt -o /tmpu/pindaro_g/cdm_a/maria/RADcap/process_p3  -c -q -r --inline_inline --renz_1 xbaI --renz_2 ecoRI &>> /tmpu/pindaro_g/cdm_a/maria/RADcap/process.log

