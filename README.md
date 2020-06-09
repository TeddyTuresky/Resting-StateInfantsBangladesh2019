**Resting-StateInfantsBangladesh2019**

This repository houses code (or links to code) used for the article:

##### *Turesky T, Jensen S, Yu X, Kumar S, Wang Y, Sliva D, Gagoski B, Sanfilippo J, Zöllei L, Boyd E, Haque R, Kakon S, Islam N, Petri W, Nelson C, N G. 2019. The relationship between biological and psychosocial risk factors and resting-state functional connectivity in 2-month-old Bangladeshi infants: a feasibility and pilot study. Dev Sci. e12841.*


All code has been customized to the input for this particular study, and implemented on MacOSX, but can be adapted be replacing pertinent paths, filenames, etc. 

This study relied on code from several toolkits (ANTs, FreeSurfer, SPM, CONN) and written in bash shell and Matlab. The following outline details the processing steps taken and specifies which scripts in this repository or outside packages were used to do so:
  
  
  
#### MPRAGE segmentation: 

    .
    ├── N4biasCorrect.sh                                                    <-- bias correct 
    ├── antsNormalize.sh + https://www.nitrc.org/projects/pediatricatlas    <-- register to neonate template
    ├── https://surfer.nmr.mgh.harvard.edu/fswiki/infantFS                  <-- segment with infant FreeSurfer  
    ├── antsTransformsMasks.sh                                              <-- register segmentations to neonate template in 
                                                                                one interpolation
  
    
    
#### Resting-State:

    .
    ├── batch_slice_timing.m + 01sliceTimingTemp{1..2}.mat                  <-- slice-time correct
    ├── batch_realign.m + 02realignTemp.mat                                 <-- realign 
    ├── antsCoreg.sh                                                        <-- estimat registration to MPRAGE 
    ├── antsTransforms.sh + BETA*.nii reference image                       <-- register to neonate template in one 
                                                                                interpolation 
    ├── batch_smooth.m + 05smoothTemp.mat                                   <-- smooth with 6.0 mm FWHM Gaussian kernel 
    ├── cfmiartrepair_4BEAN.m + WIP_art_global_regressors_4BEAN.m           <-- identify head displacement ≥0.5mm RMS 
    ├── batch_connBang.m                                                    <-- build CONN batch
    ├── connBangRS08-smooth6mm_mot0.5_CorPCA.mat                            <-- (in CONN dialogue, step #1): neonate template 
                                                                                five principal components and band‐pass filter 
                                                                                of 0.008–0.09 Hz
    ├── global CONN_x; CONN_x.Setup.extractSVD=true; conn save;             <-- replace ROI timeseries with first 
                                                                                eigenvariate/first component from singular 
                                                                                value decomposition   
                                                          (https://www.nitrc.org/forum/forum.php?thread_id=2667&forum_id=1144)
