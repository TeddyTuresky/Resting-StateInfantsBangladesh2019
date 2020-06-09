#!/bin/bash

diri=/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3
dir=/Volumes/FunTown/allAnalyses/BangRS/segs-rename2
cd ${diri}

sub=(`ls`)
for ((i=0; i<${#sub[*]}; i++)); do

if [ -e ${diri}/${sub[i]} ]; then

antsApplyTransforms -d 3 -i ${dir}/${sub[i]}/gm-mask.nii -o ${dir}/${sub[i]}/wgm-mask.nii -r ${diri}/${sub[i]}/struct/uncWarped.nii -t ${diri}/${sub[i]}/struct/unc1Warp.nii.gz -t ${diri}/${sub[i]}/struct/unc0GenericAffine.mat

antsApplyTransforms -d 3 -i ${dir}/${sub[i]}/wm-mask.nii -o ${dir}/${sub[i]}/wwm-mask.nii -r ${diri}/${sub[i]}/struct/uncWarped.nii -t ${diri}/${sub[i]}/struct/unc1Warp.nii.gz -t ${diri}/${sub[i]}/struct/unc0GenericAffine.mat

antsApplyTransforms -d 3 -i ${dir}/${sub[i]}/csf-mask.nii -o ${dir}/${sub[i]}/wcsf-mask.nii -r ${diri}/${sub[i]}/struct/uncWarped.nii -t ${diri}/${sub[i]}/struct/unc1Warp.nii.gz -t ${diri}/${sub[i]}/struct/unc0GenericAffine.mat

#antsApplyTransforms -d 3 -i ${diri}/${sub[i]}/tot.nii -o ${diri}/${sub[i]}/wtot.nii -r ${dir}/${sub[i]}/struct/uncWarped.nii -t ${dir}/${sub[i]}/struct/unc1Warp.nii.gz -t ${dir}/${sub[i]}/struct/unc0GenericAffine.mat

else

echo no resting state data for subject ${sub[i]}

fi

done

echo done transforming!
