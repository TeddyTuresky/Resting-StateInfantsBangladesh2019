Resting-StateInfantsBangladesh2019

This repository houses code (or links to code) used for the article:

Turesky T, Jensen S, Yu X, Kumar S, Wang Y, Sliva D, Gagoski B, Sanfilippo J, Zöllei L, Boyd E, Haque R, Kakon S, Islam N, Petri W, Nelson C, N G. 2019. The relationship between biological and psychosocial risk factors and resting-state functional connectivity in 2-month-old Bangladeshi infants: a feasibility and pilot study. Dev Sci. e12841.

This study relied on code from several toolkits and written in several languages. The pipeline is as follows:

MPRAGE segmentation:
Infant FreeSurfer --> https://surfer.nmr.mgh.harvard.edu/fswiki/infantFS
These segmentations were subsequently consolidated into gray mat‐ ter (GM), white matter (WM), and cerebrospinal fluid (CSF) regions‐ of‐interest (ROIs) for each participant using in‐house MATLAB 2015b (MathWorks) code. 
The transforms derived in the previous step were combined and applied to the segmentations, warping them from native to standard space in one interpolation using the antsApplyTransforms module


Resting-State:
Using SPM12 (http://www.fil.ion.ucl.ac.uk/spm/), volumes were (a) slice‐ time corrected to account for sampling superior and inferior parts of the brain at different times and (b) realigned to correct for inter‐ volume head motion throughout the run, which also output six rigid body parameters
Again using ANTS, EPI images were subsequently coregistered to T1 images and normalized in one interpolation using the transforms generated in warping participant MPRAGE images to the UNC neonatal template (Shi et al., 2011).
smoothed in SPM using a 6.0 mm full width at half maxi‐ mum Gaussian kernel 
 inter‐volume head motion ≥0.5 mm (17% of the voxel size) root‐mean‐square (RMS) displacement (i.e. d2=∆x2+∆y2+∆z2+ [(30π/180)2·(∆pitch2+∆roll2+∆yaw2)], 

10 volumes discarded at the beginning of the run

Five principal components per participant designated for WM and CSF were en‐ tered as additional temporal confounding factors. 
A band‐pass filter of 0.008–0.09 Hz


Next, denoised BOLD time series for voxels constituting these seeds underwent single value decomposition (SVD), yielding one (eigenvariate) time series for each seed. In the adult brain, signal heterogeneity exists within brain regions labeled according to the AAL atlas (Gordon et al., 2016). 

Generation of between‐group brain maps similarly relied on a main effect of bilateral seeds combined, but were modeled to iden‐ tify effects of poverty (BPL>APL and AP>BPL contrasts). Resultant clusters from these second‐level analyses were reported significant using an FDR cluster‐level correction of p < 0.05 and an uncorrected height threshold of p < 0.001.
