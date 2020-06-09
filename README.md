**Resting-StateInfantsBangladesh2019**

This repository houses code (or links to code) used for the article:

##### *Turesky T, Jensen S, Yu X, Kumar S, Wang Y, Sliva D, Gagoski B, Sanfilippo J, Zöllei L, Boyd E, Haque R, Kakon S, Islam N, Petri W, Nelson C, N G. 2019. The relationship between biological and psychosocial risk factors and resting-state functional connectivity in 2-month-old Bangladeshi infants: a feasibility and pilot study. Dev Sci. e12841.*


All code has been customized to the input for this particular study, and implemented on MacOSX, but can be adapted be replacing pertinent paths, filenames, etc. 

This study relied on code from several toolkits (ANTs, FreeSurfer, SPM, CONN) and written in bash shell and Matlab. The following outline details the processing steps taken and specifies which scripts in this repository or outside packages were used to do so:
  
  
**MPRAGE segmentation:** 

.
├── N4biasCorrect.sh                                     <-- bias correct 
├── antsNormalize.sh                                     <-- register to neonate template (https://www.nitrc.org/projects/pediatricatlas)
├── https://surfer.nmr.mgh.harvard.edu/fswiki/infantFS   <-- segment with infant FreeSurfer  
├── antsTransformsMasks.sh                               <-- register segmentations to neonate template in one interpolation
  
    
**Resting-State:** 
    .
    ├── batch_slice_timing.m <-- slice-time correct + 01sliceTimingTemp1.mat + 01sliceTimingTemp2.mat, 
    ├── batch_realign.m <-- realign + 02realignTemp.mat
    ├── estimated registration to MPRAGE --> antsCoreg.sh 
    ├── registered from native to neonate template --> antsTransforms.sh + BETA*.nii reference image 
    ├── smoothed with 6.0 mm FWHM Gaussian kernel --> batch_smooth.m + 05smoothTemp.mat
    ├── identified inter-volume head motion ≥0.5 mm root‐mean‐square displacement --> cfmiartrepair_4BEAN.m + WIP_art_global_regressors_4BEAN.m
##### * built CONN batch --> batch_connBang.m
##### * (in CONN dialogue, step #2) five principal components and band‐pass filter of 0.008–0.09 Hz; for ours: connBangRS08-smooth6mm_mot0.5_CorPCA.mat
##### * transformed average ROI timeseries to single value decomposition --> global CONN_x; CONN_x.Setup.extractSVD=true; conn save; (https://www.nitrc.org/forum/forum.php?thread_id=2667&forum_id=1144);



## Project Organization

    .
    ├── AUTHORS.md
    ├── LICENSE
    ├── README.md
    ├── bin                <- Compiled model code can be stored here (not tracked by git)
    ├── config             <- Configuration files, e.g., for doxygen or for your model if needed
    ├── data
    │   ├── external       <- Data from third party sources.
    │   ├── interim        <- Intermediate data that has been transformed.
    │   ├── processed      <- The final, canonical data sets for modeling.
    │   └── raw            <- The original, immutable data dump.
    ├── docs               <- Poster presentation and home of the github pages data
    ├── notebooks          <- Jupyter notebooks
    ├── reports            <- Manuscript source, e.g., LaTeX, Markdown, etc., or any project reports
    │   └── figures        <- Figures for the manuscript or reports
    └── src                <- Source code for this project
        ├── data           <- scripts and programs to process data
        ├── external       <- Any external source code, e.g., pull other git projects, or external libraries
        ├── models         <- Source code for your own model
        ├── tools          <- Any helper scripts go here
        └── visualization  <- Scripts for visualisation of your results, e.g., matplotlib, related.

## Prerequisites

### Docker-based installation

We recommend that you use the supplied docker image to reproduce the results of this paper.
To build the docker image, type
```bash
make docker-build
```
