#!/bin/bash

#este es un script para correr clone filter con stacks 2 desde miztli. Se usan rutas absolutas

#BSUB -J concolor_clonefilter
#BSUB -q q_hpc
#BSUB -oo salida
#BSUB -eo error
#BSUB -n 8
#BSUB -R "span[hosts=1]"

module load stacks2/2.0-b8c

mkdir /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered

clone_filter -1 /tmpu/pindaro_g/cdm_a/maria/RADcap/raw/S_concolor_Pool3.1.fq.gz -2 /tmpu/pindaro_g/cdm_a/maria/RADcap/raw/S_concolor_Pool3.2.fq.gz -i gzfastq -o /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered -y gzfastq --inline_inline --oligo_len_2 8 &>> /tmpu/pindaro_g/cdm_a/maria/RADcap/clonefilter.log

