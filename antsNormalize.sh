#!/bin/bash

cd /Volumes/FunTown/allAnalyses/BangRS/AnalysisData4
temp=/Volumes/FunTown/allAnalyses/BangRS/infantTemps/nihpd_asym_02-05_t1w.nii
o=bic

sub=(`ls`)
for ((i=0; i<${#sub[*]}; i++)); do

	echo processing ${sub[i]} 
	antsRegistrationSyNQuick.sh -d 3 -f ${temp} -m ${sub[i]}/struct/N4_struct_001.nii -o ${sub[i]}/struct/${o}

done

echo done Normalizing

