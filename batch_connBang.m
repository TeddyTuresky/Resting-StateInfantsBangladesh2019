clear BATCH;
% To build the BATCH variable for subsequent implementation in CONN for
% subsequent application using conn_batch(BATCH).
% For questions, please contact theodore.turesky@childrens.harvard.edu,
% 2017

load('/Volumes/FunTown/allAnalyses/BangRS/processing/sub_list_fineTune.mat');
nsub = size(sub,1);
nscan = 195;

BATCH.Setup.nsubjects = nsub;
BATCH.Setup.RT = [2.31.*ones(17,1); 2.82.*ones(15,1)];

k = num2str(sub);

% BATCH.Setup.rois.names{1} = 'sensorimotor';
% BATCH.Setup.rois.files{1} = '/Volumes/FunTown/allAnalyses/BangRS/rois/sensorimotor.nii';
% BATCH.Setup.rois.names{2} = 'sma';
% BATCH.Setup.rois.files{2} = '/Volumes/FunTown/allAnalyses/BangRS/rois/sma.nii';
% BATCH.Setup.rois.names{3} = 'visual';
% BATCH.Setup.rois.files{3} = '/Volumes/FunTown/allAnalyses/BangRS/rois/visual.nii';
% BATCH.Setup.rois.names{4} = 'supVisual';
% BATCH.Setup.rois.files{4} = '/Volumes/FunTown/allAnalyses/BangRS/rois/supVisual.nii';
% BATCH.Setup.rois.names{5} = 'leftTemp_auditory';
% BATCH.Setup.rois.files{5} = '/Volumes/FunTown/allAnalyses/BangRS/rois/leftTemp_auditory.nii';

BATCH.Setup.covariates.names{1} = 'rp';
BATCH.Setup.covariates.names{2} = 'art';

for i = 1:nsub
    
    BATCH.Setup.structurals{i} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/struct/uncWarped.nii'];
    
    files = dir(['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/w5rarest*.nii']); 
    for ii = 1:nscan
        BATCH.Setup.functionals{i}{1}{ii} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/' files(ii).name]; 
    end
    
    BATCH.Setup.masks.Grey{i} = ['/Volumes/FunTown/allAnalyses/BangRS/segs-rename2/' k(i,:) '/wgm-mask.nii'];
    BATCH.Setup.masks.White{i} = ['/Volumes/FunTown/allAnalyses/BangRS/segs-rename2/' k(i,:) '/wwm-mask.nii'];
    BATCH.Setup.masks.CSF{i} = ['/Volumes/FunTown/allAnalyses/BangRS/segs-rename2/' k(i,:) '/wcsf-mask.nii'];

    
    BATCH.Setup.covariates.files{1}{i}{1} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/rp_arest_011.txt'];
    BATCH.Setup.covariates.files{2}{i}{1} = ['/Volumes/FunTown/allAnalyses/BangRS/AnalysisData3/' k(i,:) '/resting/BadScanRegressorArtFix_1_0.5.txt'];
end


% BATCH.Setup.subjects.effect_names{1} = 'motion50';
% BATCH.Setup.subjects.effect_names{2} = 'motion20';
% BATCH.Setup.subjects.effect_names{3} = 'motion50wGlob';
% BATCH.Setup.subjects.effect_names{4} = 'motion20wGlob';
% BATCH.Setup.subjects.effects{1} = [1	1	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	0	1	1	1	1	1	0	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1];
% BATCH.Setup.subjects.effects{2} = [1	1	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	0	1	0	1	1	1	0	0	1	1	1	1	1	0	0	1	0	1	1	0	1	1	1];
% BATCH.Setup.subjects.effects{3} = [1	1	0	1	1	1	0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	0	1	0	1	1	1	0	0	1	1	1	1	1	1	0	1	0	1	1	0	1	1	1];
% BATCH.Setup.subjects.effects{4} = [0	1	0	1	1	1	0	0	1	0	1	1	0	0	1	1	0	0	1	1	0	1	0	1	0	1	0	1	0	0	1	1	1	1	1	0	0	1	0	1	1	0	0	1	1];