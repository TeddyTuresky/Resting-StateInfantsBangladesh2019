function y = cfmiartrepair_4BEAN(var1,var2,scanDir)
%%%% Writes out initial parameters
% Written by Kyle Shattuck, CFMI @ Georgetown University (https://cfmi.georgetown.edu/)
% for questions, please contact theodore.turesky@childrens.harvard.edu

%----- Edit Below

perc=1; %%%% perc = cut-off of global signal percent
mvmt=0.5;%%% mvmt = cut-off of movement in mm

%------

writeout=1;
MasterBadScanList=[];
MasterBadScanList{1,1}='Subject'; 
MasterBadScanList{1,2}='Perc. Global Signal Scans'; 
MasterBadScanList{1,3}='Perc. Movement Scans'; 
MasterBadScanList{1,4}='Perc. All Scans';

%Gets input parameters

ThrowOutSubjectThresh = var1; %input('What is your cut-off for percent of bad scans before subject is thrown out? ');

clear RegressorType

global RegressorType;
RegressorType = var2; % input('Do you want regressors based on Global Signal (1), Movement (2), or Both (3): ');


myfolder= scanDir; % spm_select(Inf,'dir','Select Scan Folders');
[m,n] = size(myfolder);

for i=1:m
currfolder=strtrim(myfolder(i,:));
fnames=dir(fullfile(currfolder,'swr*.nii'));
fnames=char(fnames.name);



if (length(fnames(:,1) ~= 0))
for ii=1:length(fnames(:,1));
fnames1=fnames(ii,:);
fpaths(ii,:)=[currfolder '/' fnames1];
end
end

rpname=dir(fullfile(currfolder,'rp_*.txt'));
rpname=char(rpname.name);
rppath=[currfolder '/' rpname];

WIP_art_global_regressors_4BEAN(fpaths,rppath,perc,mvmt,writeout);



%Declares percentages of bad scans to global variables

MasterBadScanList{i+1,1}=currfolder;
global pglobalscans;
MasterBadScanList{i+1,2}=pglobalscans;
global pmvscans;
MasterBadScanList{i+1,3}=pmvscans;
global pallscans;
MasterBadScanList{i+1,4}=pallscans;

clear fpaths

end

%Calculates percent of scans to throw out based on each metric, for each
%subject

tempGlobPer=0;
tempMvtPer=0;
tempTotPer=0;

sizea=size(MasterBadScanList,1);
sizeb=size(MasterBadScanList,2);

for a=1:sizea
    for b=1:sizeb

        if (str2num(char(MasterBadScanList(a,b)))>ThrowOutSubjectThresh)
             MasterBadScanList((a),(b+4))={'1'};
    
             if b==2
                 tempGlobPer=tempGlobPer+1;
             end
             if b==3
               tempMvtPer=tempMvtPer+1;
             end
            if b==4
                tempTotPer=tempTotPer+1;
             end
    
        end
    end 
end 

%Calculates percent for each subject


MasterBadScanList{(sizea+2),1}='Percent of Subjects Thrown-Out';
MasterBadScanList((sizea+2),2)={tempGlobPer/(sizea-1)};
MasterBadScanList((sizea+2),3)={tempMvtPer/(sizea-1)};
MasterBadScanList((sizea+2),4)={tempTotPer/(sizea-1)};                  
            
    
%Writes out a .csv file with all bad scans and percentages

datei = fopen(['BadScanList_' num2str(perc) '_' num2str(mvmt) '.csv'],'w');

for z=1:size(MasterBadScanList,1)
    for s=1:size(MasterBadScanList,2)
        
        var = eval(['MasterBadScanList{z,s}']);
        
        if size(var,1) == 0
            var = '';
        end
        
        if isnumeric(var) == 1
            var = num2str(var);
        end

        fprintf(datei,var);
        
        if s ~= size(MasterBadScanList,2);
            fprintf(datei,[',']);
        end
    end
    fprintf(datei,'\n');
end
fclose(datei);

end
