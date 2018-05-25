#!/bin/bash

#En este script se alinean los resultados con un genoma de referencia usando BWA, luego se corre gstacks y un módulo de populations

#BSUB -J concolor_p3
#BSUB -q q_residual
#BSUB -oo salida
#BSUB -eo error
#BSUB -n 8
#BSUB -R "span[hosts=1]"

#cargar los programas
module load samtools/1.0-gcc-4.4.6-s-serial
module load stacks2/2.0-b8c

#lista de individuos

files="Gs_05_32	
Gs_05_33	
Gs_05_35	
Gs_06_11	
Gs_06_13	
Gs_06_17	
Gs_06_22	
Gs_06_23	
Gs_06_24	
Gs_06_25	
Gs_06_26	
Gs_06_27	
Ki_05_24	
Ki_05_25	
Ki_05_26	
Ki_05_28	
Ki_05_29	
Ki_05_30	
Ki_05_31	
Ki_05_32	
Ki_05_33	
Ki_05_34	
Ki_05_35	
Ki_05_36	
Ki_05_37	
Ki_05_38	
Ki_05_39	
Ki_05_40	
Ki_05_41	
Ki_05_42	
Ki_05_43	
Ki_05_44	
Ki_05_47	
Ki_05_48	
Ki_05_49	
Ki_05_50	
Ki_07_117	
Ki_07_120	
Ki_07_121	
Ki_07_122	
Ki_07_124	
Ki_07_125	
Ki_07_126	
Ki_07_127	
Ki_07_128	
Ki_07_130	
Ki_07_131	
Ki_08_26	
Li_06_27	
Li_06_28	
Li_06_29	
Li_06_30	
Pn_06_14	
Pn_06_18	
Pn_06_19	
Pn_06_20	
Pn_06_24	
Pn_06_25	
Pn_06_28	
Pn_06_29	
Pn_06_30	
Pn_06_31	
Pn_06_32	
Pn_06_33	
Pn_06_34	
Pn_06_35	
Pn_07_10	
Pn_07_11	
Pn_07_12	
Pn_07_13	
Pn_07_14	
Pn_07_15	
SC_06_31	
SC_06_55	
SC_06_56	
SC_06_57	
SC_06_58	
SF_06_25	
SF_06_26	
SF_08_12	
SF_08_14	
SF_08_15	
SF_08_16	
SF_08_17	
SF_08_18	
SF_08_19	
SF_08_20	
SF_08_21	
SF_08_22	
SF_08_23	
SF_08_24	
SF_08_25	
SF_08_27	
SF_08_29	
SF_08_30	
SF_08_32"

#genoma de referencia:
#crear un directorio llamado refs en donde se guarden las secuencias fasta que usaré como genoma de referencia
mkdir -p refs

#declarar variable que enrute mi genoma de referencia
REF=$TMPU/maria/RADcap/refs/S_concolor_p3final.fasta

####build an index or database with bwa
bwa index $REF

#your source are your individuals fastq

#declarar variable que lleva a source (los archivos fastq de cada individuo ya demultiplexados)
src=/tmpu/pindaro_g/cdm_a/maria/RADcap/src


# Align paired-end data with BWA,
mkdir -p /tmpu/pindaro_g/cdm_a/maria/RADcap/aligned
for sample in $files
do
bwa mem -t 8 -M $REF $src/Sc_${sample}.1.fq $src/Sc_${sample}.2.fq > $TMPU/maria/RADcap/aligned/${sample}.sam
done


##Comprimir nuestro archivo de alineamiento SAM con SAMTOOLS, Samtools generate "-b" output BAM; -T reference file; -o output filename; -
mkdir -p /tmpu/pindaro_g/cdm_a/maria/RADcap/aligned2bam
mkdir -p /tmpu/pindaro_g/cdm_a/maria/RADcap/refs_sam
cp	  /tmpu/pindaro_g/cdm_a/maria/RADcap/refs/S_concolor_p3final.fasta $TMPU/maria/RADcap/refs_sam

#declarar variable
REF_SAM=/tmpu/pindaro_g/cdm_a/maria/RADcap/refs_sam/S_concolor_p3final.fasta
#indexar tu referencia con samtools
#samtools faidx $REF_SAM

#NEXT WE NEED TO CONVERT THE SAM FILE INTO A BAM FILE
for sample in $files
do
samtools import $REF_SAM.fai $TMPU/maria/RADcap/aligned/${sample}.sam $TMPU/maria/RADcap/aligned2bam/$sample.bam
done


#NOW, we need to sort BAM files
mkdir -p $TMPU/maria/RADcap/bam_sort
for sample in ${files}
do
samtools sort -O bam  -T $TMPU/maria/RADcap/${sample} -o $TMPU/maria/RADcap/bam_sort/$sample.bam $TMPU/maria/RADcap/aligned2bam/$sample.bam
done

for sample in ${files}
do
samtools index $TMPU/maria/RADcap/bam_sort/${sample}.bam
done


# Run gstacks to build loci from the aligned paired-end data.
#In the fifth stage, the gstacks program is executed to assemble and merge paired-end contigs, call variant sites in the population and genotypes in each sample.
mkdir -p $TMPU/maria/RADcap/gstacks_output
gstacks -I /tmpu/pindaro_g/cdm_a/maria/RADcap/bam_sort -M ./PopmapConcolorRADCap.txt --paired -O ./gstacks_output -t 16 &> ./gstacks_Ma.log

#In the final stage, the populations program is executed, depending on the type of input data.
## Run populations. Calculate Hardy-Weinberg deviation, population statistics,
### smooth the statistics across the genome. Export several output files.
populations -P ./gstacks_output/ -M ./PopmapConcolorRADCap.txt -r 0.80 --vcf --genepop --structure -fstats --hwe --smooth -t 8

# -P,--in_path — path to the directory containing the Stacks files. -M,--popmap — path to a population map. (Format is 'SAMPLE1POP1\n...'.). --genepop — output results in GenePop format. --structure — output results in Structure format.
#-r [float] — minimum percentage of individuals in a population required to process a locus for that population. --hwe — calculate divergence from Hardy-Weinberg equilibrium for each locus.
#
