Resting-StateInfantsBangladesh2019

This repository houses code (or links to code) used for the article:

Turesky T, Jensen S, Yu X, Kumar S, Wang Y, Sliva D, Gagoski B, Sanfilippo J, Zöllei L, Boyd E, Haque R, Kakon S, Islam N, Petri W, Nelson C, N G. 2019. The relationship between biological and psychosocial risk factors and resting-state functional connectivity in 2-month-old Bangladeshi infants: a feasibility and pilot study. Dev Sci. e12841.

All code has been customized to the input for this particular study, and implemented on MacOSX, but can be adapted be replacing pertinent paths, filenames, etc. 

This study relied on code from several toolkits (ANTs, FreeSurfer, SPM, CONN) and written in bash shell and Matlab. The following outline details the processing and analysis steps taken and specifies which scripts in this repository or outside packages were used to do so:

MPRAGE segmentation:
1. registration to neonate template (with cerebellum; https://www.nitrc.org/projects/pediatricatlas) --> *antsRegistrationSyNQuick module (Avants et al., 2011)

2. Infant FreeSurfer --> https://surfer.nmr.mgh.harvard.edu/fswiki/infantFS

3. Segmentations from #2 consolidated into gray matter, white matter, and cerebrospinal fluid ROIs

4. registered segmentations from #3 from native to standard space in one interpolation --> *antsApplyTransforms


Resting-State:
1. Slice-time correction and realignment --> SPM12 
2. Coregistration to MPRAGE --> 
3. 
4. Smoothing with 6.0 mm FWHM Gaussian kernel 
5. inter‐volume head motion ≥0.5 mm root‐mean‐square (RMS) displacement (i.e. d2=∆x2+∆y2+∆z2+ [(30π/180)2·(∆pitch2+∆roll2+∆yaw2)])
6. Discard first 10 volumes
7. CONN script
8. Five principal components per participant designated for WM and CSF were en‐ tered as additional temporal confounding factors. 
9. A band‐pass filter of 0.008–0.09 Hz
10. 

Next, denoised BOLD time series for voxels constituting these seeds underwent single value decomposition (SVD), yielding one (eigenvariate) time series for each seed. In the adult brain, signal heterogeneity exists within brain regions labeled according to the AAL atlas (Gordon et al., 2016). 

Generation of between‐group brain maps similarly relied on a main effect of bilateral seeds combined, but were modeled to iden‐ tify effects of poverty (BPL>APL and AP>BPL contrasts). Resultant clusters from these second‐level analyses were reported significant using an FDR cluster‐level correction of p < 0.05 and an uncorrected height threshold of p < 0.001.
