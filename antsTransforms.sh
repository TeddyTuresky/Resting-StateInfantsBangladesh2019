#!/bin/bash

dir=/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3
temp=/Users/cinnamon/Documents/tempTransform
ref=/Users/cinnamon/Documents/BETA_Subject001_Condition001_Source011.nii #reference dimensions: 91x109x91 mm, voxel size: 2x2x2 mm

cd ${dir}

sub=(`ls`)


for ((k=11; k<=205; k++)); do


if [ "$k" -lt 100 ]; then


antsApplyTransforms -d 3 -i ${dir}/${sub[i]}/resting/rarest_0${k}.nii -o ${dir}/${sub[i]}/resting/w5rarest_0${k}.nii -r ${ref} -t ${dir}/${sub[i]}/struct/unc1Warp.nii.gz -t ${dir}/${sub[i]}/struct/unc0GenericAffine.mat -t ${dir}/${sub[i]}/struct/AF0GenericAffine.mat

else

antsApplyTransforms -d 3 -i ${dir}/${sub[i]}/resting/rarest_${k}.nii -o ${dir}/${sub[i]}/resting/w5rarest_${k}.nii -r ${ref} -t ${dir}/${sub[i]}/struct/unc1Warp.nii.gz -t ${dir}/${sub[i]}/struct/unc0GenericAffine.mat -t ${dir}/${sub[i]}/struct/AF0GenericAffine.mat


fi

done


echo done transforming
