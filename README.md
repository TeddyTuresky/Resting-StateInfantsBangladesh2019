**Resting-StateInfantsBangladesh2019**

This repository houses code (or links to code) used for the article:

*Turesky T, Jensen S, Yu X, Kumar S, Wang Y, Sliva D, Gagoski B, Sanfilippo J, Zöllei L, Boyd E, Haque R, Kakon S, Islam N, Petri W, Nelson C, N G. 2019. The relationship between biological and psychosocial risk factors and resting-state functional connectivity in 2-month-old Bangladeshi infants: a feasibility and pilot study. Dev Sci. e12841.*

All code has been customized to the input for this particular study, and implemented on MacOSX, but can be adapted be replacing pertinent paths, filenames, etc. 

This study relied on code from several toolkits (ANTs, FreeSurfer, SPM, CONN) and written in bash shell and Matlab. The following outline details the processing steps taken and specifies which scripts in this repository or outside packages were used to do so:

MPRAGE segmentation: 
##### * bias corrected --> N4biasCorrect.sh 
##### * registered to neonate template (https://www.nitrc.org/projects/pediatricatlas) --> antsNormalize.sh 
##### * infant FreeSurfer --> https://surfer.nmr.mgh.harvard.edu/fswiki/infantFS 
##### * registered segmentations from native to neonate template in one interpolation --> antsTransformsMasks.sh


Resting-State: 
* discarded first 10 volumes 
* slice-time corrected and realigned --> %SPM12 ./spmBatches/ 
* estimated registration to MPRAGE --> antsCoreg.sh 
* registered from native to neonate template --> antsTransforms.sh + BETA*.nii reference image 
* smoothed with 6.0 mm FWHM Gaussian kernel --> %SPM12 ./spmBatches/ 
* identified inter-volume head motion ≥0.5 mm root‐mean‐square displacement --> 
* built CONN batch --> 
* (in CONN dialogue, step #2) five principal components and band‐pass filter of 0.008–0.09 Hz 
* transformed average ROI timeseries to single value decomposition -->
