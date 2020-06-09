#!/bin/bash

cd /Volumes/FunTown/allAnalyses/BangRS/AnalysisData4

o=struct_001.nii

sub=(`ls`)
for ((i=0; i<${#sub[*]}; i++)); do

if [ -e ${sub[i]}/struct/${o} ] 
then 
	echo ${o} exists
	N4BiasFieldCorrection -d 3 -i ${sub[i]}/struct/${o} -s 2 -c [100x100x100x100,0.0000000001] -b [200] -o ${sub[i]}/struct/N4_${o};

else
	echo ${o} does not exist
fi

done

echo done N4
