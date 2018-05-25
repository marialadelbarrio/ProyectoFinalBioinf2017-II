## Querido Diario:

En mi proyecto final me interesa avanzar en mi tesis, la cual se centra en buscar estructura poblacional y hacer análisis de genética de poblaciones utilizando SNPs, con el el pez endémico del Golfo de California _Scomberomorus concolor_.  
El año pasado envié a secuenciación 3 librerías con 96 individuos cada una, y a la fecha únicamente he recibido el resultado de la primera librería. Adicional a eso, se me proporcionó un "experimento piloto", que consiste en las secuencias completamente procesadas de 8 individuos de las distintas localidades que utilicé en mis muestras. Los resultados de este experimento se utilizarán como genoma de referencia para los futuros pasos del análisis. 
Los resultados de la secuenciación se recibieron en la forma de dos archivos en  formato .fastq. Estos fueron analizados con el programa FastQC (en su versión interactiva) para revisar la calidad de las muestras y asegurarse que la secuenciación había funcionado adecuadamente. Los resultados fueron satisfactorios, por lo que se procedió a demultiplexar las muestras.

Se abrió una cuenta para todo nuestro laboratorio en la supercomputadora Miztli, a fin de poder correr los análisis más rápidamente.

Lo primero que se hizo fue correr el programa clone_filter de Stacks para identificar secuencias duplicadas.

El comando utilizado para el programa de clone_filter es (se utilizan rutas absolutas, ya que así lo requiere Miztli)

    clone_filter -1 /tmpu/pindaro_g/cdm_a/maria/RADcap/raw/S_concolor_Pool3.1.fq.gz -2 /tmpu/pindaro_g/cdm_a/maria/RADcap/raw/S_concolor_Pool3.2.fq.gz -i gzfastq -o /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered -y gzfastq --inline_inline --oligo_len_2 8 &>> /tmpu/pindaro_g/cdm_a/maria/RADcap/clonefilter.log

Luego se corrió el process_radtags de Stacks para demultiplexar las muestras y descartar las lecturas defectuosas. El comando es el siguiente: 

    process_radtags  -1 /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/S_concolor_Pool3.1.1.fq -2 /tmpu/pindaro_g/cdm_a/maria/RADcap/filtered/S_concolor_Pool3.2.2.fq -b /tmpu/pindaro_g/cdm_a/maria/RADcap/barcodes_pool3.txt -o /tmpu/pindaro_g/cdm_a/maria/RADcap/process_p3  -c -q -r --inline_inline --renz_1 xbaI --renz_2 ecoRI &>> /tmpu/pindaro_g/cdm_a/maria/RADcap/process.log

El siguiente paso en el que se trabajará en los próximos días es en alinear con BWA los resultados del experimento piloto (lo cual funcionará como genoma de referencia) con los resultados de la secuenciación.
