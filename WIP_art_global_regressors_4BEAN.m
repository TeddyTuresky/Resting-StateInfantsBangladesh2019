function WIP_art_global_regressors_4BEAN(Images,RealignmentFile,Percent_thresh,mv_thresh,MakeRegressors)
% ----------------------------------------
% Images: list of epi images to analyze
%
% RealignmentFile: SPM movement regressors, rp_*.txt, which must be the same length as the number of entered images.
%
% Percent_thresh: minimum percent variation from mean scan that you deem acceptable.
%
% mv_thresh: minimum mm/TR movement that you deem acceptable.
%
% MakeRegressors: enter 1 to make text output of regressors that can be entered into a GLM as
%                 well as a text output listing the names of the scans that are beyond either threshold.
%
% Note- if you enter less than all 5 inputs into a batch, you will be asked to enter all parameters manually.
% -----------------------------------------
%
%     This script was taken from ArtRepair and modofied to suit processing at
% CFMI; specifically, it is designed to write out a text file list of
% regressors for GLM analysis.
%  
% FORMAT art_global                         (v.2.2 for SPM2 and SPM5)
%     Art_global allows visual inspection of average intensity and
% scan to scan motion of fMRI data, and offers methods to repair outliers
% in the data. Outliers are scans whose global intensity is very different
% from the mean, or whose scan-to-scan motion is large. Thresholds that
% define the outliers are shown, and they can be adjusted by the user.
% Margins are defined around the outliers to assure that the repaired
% data will satisfy the "slowly-varying" background assumption of GLM
% models. Outliers can also be defined by user manual edits.
%     A set of default thresholds is suggested ( 1.5% variation in global
% intensity, 0.5 mm/TR scan-to-scan motion.) Informally, these values
% are OK for small to moderate repairs. The thresholds can be reduced for
% good data (motion -> 0.3) , and should be raised for severely noisy data
% (motion -> 1.0). The values of the intensity and motion thresholds are
% linked and will change together. As a default, all images with total
% movement > 3 mm will also be marked for repair. For special situations,
% the outlier edit feature can mark additional scans. When motion 
% regressors will be used, suggest setting the motion threshold to 0.5
% and not applying the margins.
%     For multiple sessions, be sure to align all sessions with respect
% to the same image, e.g. V001 of first session. This art_global program
% will detect shifts in position across session boundaries.
%
% For batch scripts, use
% FORMAT art_global(Images, RealignmentFile, HeadMaskType, RepairType)
%    Images  = Full path name of images to be repaired.
%       For multiple sessions, all Images are in one array, e.g.SPM.xY.P
%    RealignmentFile = Full path name of realignment file
%       For multiple sessions, cell array with one name per session.
%    HeadMaskType  = 1 for SPM mask, = 4 for Automask
%    RepairType = 1 for ArtifactRepair alone (0.5 movment and add margin).
%               = 2 for Movement Adjusted images  (0.5 movement, no margin)
%    Hardcoded actions:
%       Does repair, does not force repair of first scan.
% ----------------------------------------------------------------------
% v2.1, Jan. 2007. PKM.
%    Prints copy of art_global figure in batch mode.
%    Allows multiple sessions in batch mode.
%       Images is full path name of all sessions, e.g. SPM.xY.P
%       Realignment file is one cell per session with full rp file name.
%    For SPM5, finds size of VY.dim.  ( Compatible with SPM2)
% v2.2, July 2007 PKM
%    Also marks scan before a big movement for mv_out repair.
%    Allows two kinds of RepairType in batch, with and without margin.
%    Fixed logic for user masked mean
%    Adds user GUI option to repair all scans with movement > 3 mm.
%    small fix to subplots
%
% Paul Mazaika, September 2006.
% This version replaces v.1 by Paul Mazaika and Sue Whitfield 2005,
%  originally derived from artdetect4.m, by Sue Whitfield,
%  Jeff Cooper, and Max Gray in 2002.
%---------------------

pfig = [];


% ------------------------
% Default values for outliers
% ------------------------
% When std is very small, set a minimum threshold based on expected physiological
% noise. Scanners have about 0.1% error when fully in spec. 
% Gray matter physiology has ~ 1% range, ~0.5% RMS variation from mean. 
% For 500 samples, expect a 3-sigma case, so values over 1.5% are
% suspicious as non-physiological noise. Data within that range are not
% outliers. Set the default minimum percent variation to be suspicious...
%     Percent_thresh = 1.5; 
%  Alternatively, deviations over 2*std are outliers, if std is not very small.
%     z_thresh = 2;  % Currently not used for default.
% Large intravolume motion may cause image reconstruction
% errors, and fast motion may cause spin history effects.
% Guess at allowable motion within a TR. For good subjects,
% would like this value to be as low as 0.3. For clinical subjects,
% set this threshold higher.
%     mv_thresh = 0.5;
                        % try 0.3 for subjects with intervals with low noise
                        % try 1.0 for severely noisy subjects

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Defaults added for CFMI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 5
Images = spm_select(Inf,'Image','Select images to evaluate');
RealignmentFile = spm_select(Inf,'rp_.*\.txt$','Select the SPM realignment text file for your images');
Percent_thresh = input('Enter percent signal change threshold (e.g. 1.5): ');
z_thresh = 2;
mv_thresh = input('Enter interscan movement threshold in mm (e.g. 0.5): ');
MakeGraph = input('Press 1 to save the figures in a PostScript file \n Or just hit Enter to only see them on the screen:  ');
if MakeGraph == 1
ScreenView = input('Press 1 to automatically clear away figures \n Or just hit enter to leave them on the screen:  ');
else ScreenView = 0;
end;
MakeRegressors = input('Press 1 to make text file regressors for scans beyond threshold \n Or just hit enter to not create text files:  ');

else
MakeGraph = 1;
Screenview = 1;
MakeRegressors = 1;
end

[program_path,nnn,eee] = fileparts(Images(1,:));
HeadMaskType = 4;
RepairType = 0;
global_type_flag = HeadMaskType;
num_sess = size(RealignmentFile,1);
realignfile = 1;
P{1} = Images;
global M
M = [];
for i = 1:num_sess
        mvmt_file = char(RealignmentFile(i,:));
        M{i} = load(mvmt_file);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%end defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    disp('Generated mask image is written to file ArtifactMask.img.')
    Pnames = P{1};
    Automask = art_automask(Pnames(1,:),-1,1);
    maskcount = sum(sum(sum(Automask)));  %  Number of voxels in mask. 
    voxelcount = prod(size(Automask));    %  Number of voxels in 3D volume.

spm_input('!DeleteInputObj');

P = char(P);
    mv_data = [];
    for i = 1:length(M)
        mv_data = vertcat(mv_data,M{i});
end


% -------------------------
% get file identifiers and Global values
% -------------------------

fprintf('%-4s: ','Mapping files...')                                  
VY     = spm_vol(P);
fprintf('%3s\n','...done')                                          

%if any(any(diff(cat(1,VY.dim),1,1),1)&[1,1,1,0])
temp = any(diff(cat(1,VY.dim),1,1),1);
if length(temp) == 4       % SPM2 case
    if any(any(diff(cat(1,VY.dim),1,1),1)&[1,1,1,0])
        error('images do not all have the same dimensions')
    end
elseif length(temp) == 3   % SPM5 nifti case
    if ~isempty(find(diff(cat(1,VY.dim)) ~= 0 ))   
	    error('images do not all have the same dimensions (SPM5)')
    end
end

nscans = size(P,1);

% ------------------------
% Compute Global variate
%--------------------------

global g
g = zeros(nscans,1);

fprintf('%-4s: %3s','Calculating globals...',' ')

    for i = 1:nscans
        Y = spm_read_vols(VY(i));
        Y = Y.*Automask;
            g(i) = mean(mean(mean(Y)))*voxelcount/maskcount;

    end
    % If computing approximate translation alignment on the fly...
    %   centroid was computed in voxels
    %   voxel size is VY(1).mat(1,1), (2,2), (3,3).
    %   calculate distance from mean as our realignment estimate
    %   set rotation parameters to zero.
    if realignfile == 0    % change to error values instead of means.
        centroidmean = mean(centroiddata,1);
        for i = 1:nscans
            mv0data(i,:) = - centroiddata(i,:) + centroidmean;
        end
        % THIS MAY FLIP L-R  (x translation)
        mv_data(1:nscans,1) = mv0data(1:nscans,1)*VY(1).mat(1,1);
        mv_data(1:nscans,2) = mv0data(1:nscans,2)*VY(1).mat(2,2);
        mv_data(1:nscans,3) = mv0data(1:nscans,3)*VY(1).mat(3,3);
        mv_data(1:nscans,4:6) = 0;
    end

% Convert rotation movement to degrees
mv_data(:,4:6)= mv_data(:,4:6)*180/pi; 
    
    
fprintf('%s%3s\n','...done\n')

if global_type_flag==4
    fprintf('\n%g voxels were in the auto generated mask.\n', maskcount)
end

% ------------------------
% Compute default out indices by z-score, or by Percent-level is std is small.
% ------------------------ 
%  Consider values > Percent_thresh as outliers (instead of z_thresh*gsigma) if std is small.
    gsigma = std(g);
    gmean = mean(g);
    pctmap = 100*gsigma/gmean;
    mincount = Percent_thresh*gmean/100;
    %z_thresh = max( z_thresh, mincount/gsigma );
    z_thresh = mincount/gsigma;        % Default value is PercentThresh.
    z_thresh = 0.1*round(z_thresh*10); % Round to nearest 0.1 Z-score value
    zscoreA = (g - mean(g))./std(g);  % in case Matlab zscore is not available
    glout_idx = (find(abs(zscoreA) > z_thresh))';

% ------------------------
% Compute default out indices from rapid movement
% ------------------------ 
%   % Rotation measure assumes voxel is 65 mm from origin of rotation.
    if realignfile == 1 | realignfile == 0
        delta = zeros(nscans,1);  % Mean square displacement in two scans
        for i = 2:nscans
            delta(i,1) = (mv_data(i-1,1) - mv_data(i,1))^2 +...
                    (mv_data(i-1,2) - mv_data(i,2))^2 +...
                    (mv_data(i-1,3) - mv_data(i,3))^2 +...
                    1.28*(mv_data(i-1,4) - mv_data(i,4))^2 +...
                    1.28*(mv_data(i-1,5) - mv_data(i,5))^2 +...
                    1.28*(mv_data(i-1,6) - mv_data(i,6))^2;
            delta(i,1) = sqrt(delta(i,1));
        end
    end
    
     % Also name the scans before the big motions (v2.2 fix)
    deltaw = zeros(nscans,1);
    for i = 1:nscans-1
        deltaw(i) = max(delta(i), delta(i+1));
    end
    delta(1:nscans-1,1) = deltaw(1:nscans-1,1);
    mvout_idx = find(delta > mv_thresh)';
    
    % Total repair list
    out_idx = unique([mvout_idx glout_idx]);

    % Initial deweight list before margins
    outdw_idx = out_idx; 
    % Initial clip list without removing large displacements
    clipout_idx = out_idx;
     
glout_idx;
mvout_idx;
out_idx;

% -----------------------
% Draw initial figure
% -----------------------


figure('Units', 'normalized', 'Position', [0.2 0.2 0.6 0.7]);
rng = max(g) - min(g);   % was range(g);
pfig = gcf;

subplot(5,1,1);
plot(g);
%xlabel(['artifact index list [' int2str(out_idx') ']'], 'FontSize', 8, 'Color','r');
%ylabel(['Range = ' num2str(rng)], 'FontSize', 8);
%print output to regressor file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Added by Jeremy
    g
dlmwrite(sprintf('%s/global_mean.txt',program_path),g,'newline', 'pc');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ylabel('Global Avg. Signal');
title(program_path);

% Add vertical exclusion lines to the global intensity plot
axes_lim = get(gca, 'YLim');
axes_height = [axes_lim(1) axes_lim(2)];

subplot(5,1,2);

zscoreA = (g - mean(g))./std(g);  % in case Matlab zscore is not available
plot(abs(zscoreA));
ylabel('Std away from mean');
xlabel('Scan Number  -  horizontal axis for all plots');

thresh_x = 1:nscans;
thresh_y = z_thresh*ones(1,nscans);
line(thresh_x, thresh_y, 'Color', 'r');

%  Mark global intensity outlier images with vertical lines
axes_lim = get(gca, 'YLim');
axes_height = [axes_lim(1) axes_lim(2)];
for i = 1:length(glout_idx)
    line((glout_idx(i)*ones(1, 2)), axes_height, 'Color', 'r');
end

if realignfile == 1
	subplot(5,1,3);
    xa = [ 1:nscans];
	plot(xa,mv_data(:,1),'b-',xa,mv_data(:,2),'g-',xa,mv_data(:,3),'r-',...
       xa,mv_data(:,4),'r--',xa,mv_data(:,5),'b--',xa,mv_data(:,6),'g--');
    
	ylabel('Realignment');
	xlabel('Translation (mm) solid lines, Rotation (deg) dashed lines');
	legend('x mvmt', 'y mvmt', 'z mvmt','pitch','roll','yaw',0);
	h = gca;
	set(h,'Ygrid','on');
elseif realignfile == 0
    subplot(5,1,3);
	plot(mv0data(:,1:3));
	ylabel('Alignment (voxels)');
	xlabel('Scans. VERY APPROXIMATE EARLY-LOOK translation in voxels.');
	legend('x mvmt', 'y mvmt', 'z mvmt',0);
	h = gca;
	set(h,'Ygrid','on');
end 

subplot(5,1,4);   % Rapid movement plot
plot(delta);
ylabel('Motion (mm/TR)');
xlabel('Scan to scan movement (~mm). Rotation assumes 65 mm from origin');
y_lim = get(gca, 'YLim');
legend('Fast motion',0);
h = gca;
set(h,'Ygrid','on');

thresh_x = 1:nscans;
thresh_y = mv_thresh*ones(1,nscans);
line(thresh_x, thresh_y, 'Color', 'r');
   
% Mark all movement outliers with vertical lines
subplot(5,1,4)
axes_lim = get(gca, 'YLim');
axes_height = [axes_lim(1) axes_lim(2)];
for i = 1:length(mvout_idx)
    line((mvout_idx(i)*ones(1,2)), axes_height, 'Color', 'r');
end

nglobscans=num2str(length(glout_idx));
percglobscans=num2str((100*length(glout_idx))/nscans,3);
nmvscans=num2str(length(mvout_idx));
percmvscans=num2str((100*length(mvout_idx))/nscans,3);
nallscans=num2str(length(out_idx));
percallscans=num2str((100*length(out_idx))/nscans,3);
stdevaglob=num2str(100*std(g)/mean(g),3);
stdevamvmt=num2str(std(delta),3);
sigthreshold=num2str(Percent_thresh);
mvmtthreshold=num2str(mv_thresh);

%%%%% added by Andrew to declare global variables to compile master list of
%%%%% bad scans when batching

global pglobalscans;
pglobalscans=percglobscans;
global pmvscans;
pmvscans=percmvscans;
global pallscans;
pallscans=percallscans;

%%%%%%%

subplot(5,1,5);
axis off;
text(0,.6,'Scans > global intensity threshold:');
text(0,.4,'Scans > movement threshold:');
text(0,.2,'Scans > either threshold:');
text(0,-.2,'% signal change std dev:');
text(0,-.4,'Movement std deviation (mm/TR):');
text(0,-.8,'Signal% from mean threshold:');
text(0,-1,'Movement threshold (mm/TR):');
text(.4,.8,'# Scans');
text(.5,.8,'% Scans');
text(.4,.6,nglobscans);
text(.5,.6,percglobscans);
text(.4,.4,nmvscans);
text(.5,.4,percmvscans);
text(.4,.2,nallscans);
text(.5,.2,percallscans);
text(.4,-.2,stdevaglob);
text(.4,-.4,stdevamvmt);
text(.4,-.8,sigthreshold);
text(.4,-1,mvmtthreshold);
axis off;

globals={percglobscans};
PercentBadScansMatrix(i,1)=globals;

if MakeGraph == 1
SavedFilename = ['QC_Stats_',date];
print('-dpsc','-append',SavedFilename);
disp(' ')
disp(['Wrote graphical output to ' SavedFilename ' in working directory.'])
end;

if MakeRegressors == 1
clear badscans
regrfile = zeros(nscans,1);
regrtxt = fullfile(program_path,['BadScanRegressors_' sigthreshold 'perc_' mvmtthreshold 'mm.txt']);
badscanstxt = fullfile(program_path,['BadScanNames_' sigthreshold 'perc_' mvmtthreshold 'mm.txt']);
fid = fopen(badscanstxt,'w');

global RegressorType;

if (RegressorType == 1)
for i=1:length(glout_idx)
regrfile(glout_idx(i))=1;
badscans(i,:) = Images(glout_idx(i),:);
fprintf(fid,'%s',badscans(i,:));
fprintf(fid,'\n');
end
elseif (RegressorType == 2)
for i=1:length(mvout_idx)
regrfile(mvout_idx(i))=1;
badscans(i,:) = Images(mvout_idx(i),:);
fprintf(fid,'%s',badscans(i,:));
fprintf(fid,'\n');
end
elseif (RegressorType == 3)
for i=1:length(out_idx)
regrfile(out_idx(i))=1;
badscans(i,:) = Images(out_idx(i),:);
fprintf(fid,'%s',badscans(i,:));
fprintf(fid,'\n');
end
end

% added by Teddy
num = nnz(regrfile);

global matreg;
if num<1
    matreg = zeros(nscans,1);
else
    matreg = zeros(nscans,num);
    k = find(regrfile);

    for ii = 1:num
        matreg(k(ii),ii) = 1;
    end

end

dlmwrite([program_path '/BadScanRegressorArtFix_' sigthreshold '_' mvmtthreshold '.txt'],matreg,'delimiter','\t');
% end Teddy


fclose(fid);
dlmwrite(regrtxt,regrfile,'delimiter','\t');
disp(' ')
disp(['Wrote regressors to ' regrtxt])
disp(' ')
disp(['Wrote list of bad scans to ' badscanstxt])
end

disp('Done')
