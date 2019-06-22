function handles = plotusingmatlab(pathToSubjectDir, subjectID, pathToCorticalSurfacesDir, pathToFsInstallDirectory, pathToVolume, scriptDirectory, pathToElectrodes,handles,EnvFcnFlag)
%
% This function uses the results of nicebrain() (a segmentation,
% coregistered CT and MRI scans, and a .mat file containing ordered
% electrodes to create a MATLAB figure of the subject using activateBrain.
% It also saves the results in a .mat file that is compatible with
% activateBrain use. The .mat file is placed in the MATLAB subdirectory of
% the subject directory.
%
% The matlab/ directory of the your freesurfer installation must be on the
% path.
%
% pathToSubjectDir should be the absolute path up to and including the
% subject directory (not the one in freesurfer)
% e.g.: /Desktop/brains/subject017
%
% subjectID is ID of your subject that will be saved as a .mat file. Pick a
% new subject ID if you don't want the data from a previous run to be
% overwritten.
% e.g.: subject017
%
% pathToCorticalSurfacesDir should be the path to the directory containing
% the rh.pial and lh.pial files.
%
% pathToFsInstallDirectory should be the absolute path up of the freesurfer
% installation directory, not including freesurfer/.
% e.g.: /Applications
%
% pathToVolume should be a path up to and including the orig.mgz volume located in
% <pathToFsInstallDirectory>/freesurfer/subjects/<subjectID>/mri/ or
% wherever you have put the results of the subject's segmentation.
% e.g.: /Applications/freesurfer/subjects/subject22/mri/orig.mgz
%
% scriptDirectory is the directory in which this script is placed.
% e.g.: '/Users/ncollisson/Dropbox/brainresearch'
% This script should be kept in the same directory as the other files that
% come with this package.
%
% pathtoelecs is the path to the electrodes you want to plot on the brain.
% This is probably either <subjdir>/Electrodes/electrodes.mat or
% <subjdir>/Electrodes/projelectrodes.mat
%
% The data structure produced looks like one below:
%
% subject
% \_ .cortex
%    \_ .tri
%    \_ .vert
% \_ .tala
%    \_ .electrodes
%
% When it is this way it works easily with the plotbrainfunction
%
% plotbrainfunction will then save the data in the standard activateBrain
% format
eleIndex = handles.ElectrodeIndex;

% check to make sure arguments exist
if ~exist(pathToSubjectDir, 'dir')
    disp(pathToSubjectDir);
    disp('Subject directory does not exist');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = [pathToSubjectDir,'---Subject directory does not exist...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

if ~exist(pathToCorticalSurfacesDir, 'dir')
    disp(pathToCorticalSurfacesDir);
    disp('Directory containing cortical surfaces does not exist');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = [pathToCorticalSurfacesDir,'---Directory containing cortical surfaces does not exist...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end


if ~exist(pathToVolume, 'file')
    disp(pathToVolume);
    disp('Volume does not exist');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = [pathToVolume,'---Volume does not exist...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

if ~exist(scriptDirectory, 'dir')
    disp(scriptDirectory);
    disp('Script directory does not exist');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = [scriptDirectory,'---Script directory does not exist...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

if ~exist(pathToElectrodes, 'file')
    disp(pathToElectrodes);
    disp('Electrodes file does not exist');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = [pathToElectrodes,'---Electrodes file does not exist...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

if ~exist(fullfile(pathToFsInstallDirectory,'freesurfer'), 'file')
    disp(pathToFsInstallDirectory);
    disp('freesurfer does not exist');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = [fullfile(pathToFsInstallDirectory,'freesurfer'),'---freesurfer does not exist...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

% set path to and load subject electrodes into tempelec

%pathToElectrodes = strcat(pathToSubjectDir, '/Electrodes/electrodes.mat');
tempelec = load(pathToElectrodes);
tempelec.elecMatrix =tempelec.elecMatrix;

% tempelec_dat = importelectrodes(pathToElectrodes);
% tempelec.elecMatrix = tempelec_dat;

% run a shell script to obtain transformation matrices to get electrodes
% into the same coordinate system as the brain
% load the transform matrices generated by the shell script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XFRM_PATH=strcat(pathToSubjectDir,'/MATLAB');
if ~exist(XFRM_PATH)
    mkdir(XFRM_PATH);
end
% shellcommand = [scriptDirectory '/get_xfrm_matrices.sh ' pathToFsInstallDirectory ' ' pathToVolume ' ' XFRM_PATH '&'];
% system(shellcommand);
% pause(10)

% orgfile=fullfile(pathToSubjectDir,'Segmentation','mri','orig.mgz');
M=MRIread(pathToVolume);
xfrm_matrices=[M.vox2ras;M.tkrvox2ras];
save(fullfile(XFRM_PATH,'xfrm_matrices.mat'),'xfrm_matrices');
path_to_xfrm_matrices = strcat(pathToSubjectDir, '/MATLAB/xfrm_matrices');
% xfrm_matrices = importdata(path_to_xfrm_matrices);
load(path_to_xfrm_matrices);

% move the transform matrices into their own variables
Norig = xfrm_matrices(1:4, :);
Torig = xfrm_matrices(5:8, :);

tala.electrodes = tempelec.elecMatrix;

% apply xfrm matrices to electrodes
tala.electrodes = (Torig*inv(Norig)*[tala.electrodes(:, 1), tala.electrodes(:, 2), tala.electrodes(:, 3), ones(size(tala.electrodes, 1), 1)]')';
tala.electrodes = tala.electrodes(:, 1:3);

if eleIndex==3
    ecog_electrodes=tala.electrodes(tempelec.elecInfo.seeg_points+1:end,:);
end

subject=struct;
if eleIndex==1 || eleIndex==3
    IntCont = handles.ElectrodeLength.InterContactDistance;
    eleclen = handles.ElectrodeLength.ContactLength;
    
    tempelec.elec_Info.vector=[];
    tempelec.elec_Info.stp=[];
    elec_Info_Final.name=[];
    elec_Info_Final.pos=[];
    elec_Info_Final.seeg_pos=[];
    elec_Info_Final.eletype = [];
    mm=0;
    for ii=1:length(tempelec.elec_Info.name)
        if strcmp(tempelec.elec_Info.name{ii},tempelec.elecInfo.name{(ii-1)*4+1})
            [tempelec.elec_Info.vector{ii},tempelec.elec_Info.stp{ii}]=fitline_get(tala.electrodes((ii-1)*4+(1:4),:));
            tempelec.elec_Info.vector{ii}(4:6)=tempelec.elec_Info.vector{ii}(4:6)/norm(tempelec.elec_Info.vector{ii}(4:6),2);
            if handles.ElectrodeType==1
                for jj=1:tempelec.elec_Info.number{ii}
                    mm=mm+1;
                    elec_Info_Final.pos{mm}=tempelec.elec_Info.stp{ii}+(jj-1)*IntCont*tempelec.elec_Info.vector{ii}(4:6)+eleclen/2*tempelec.elec_Info.vector{ii}(4:6);
                    elec_Info_Final.name{mm}=[strcat(tempelec.elec_Info.name{ii},num2str(jj))];
                    
                end
            elseif handles.ElectrodeType==2
                for jj=1:tempelec.elec_Info.number{ii}
                    mm=mm+1;
                    if jj>=9 %% special correction for the customized electrode for P10
                        elec_Info_Final.pos{mm}=tempelec.elec_Info.stp{ii}+(jj-9)*IntCont*tempelec.elec_Info.vector{ii}(4:6)+44.5*tempelec.elec_Info.vector{ii}(4:6);
                    else
                        elec_Info_Final.pos{mm}=tempelec.elec_Info.stp{ii}+(jj-1)*IntCont*tempelec.elec_Info.vector{ii}(4:6)+1*tempelec.elec_Info.vector{ii}(4:6);
                    end
                    elec_Info_Final.name{mm}=[strcat(tempelec.elec_Info.name{ii},num2str(jj))];
                end
            elseif handles.ElectrodeType==3
                for jj=1:tempelec.elec_Info.number{ii}
                    mm=mm+1;
                    if jj>=11 %% special correction for the customized electrode for P10
                        elec_Info_Final.pos{mm}=tempelec.elec_Info.stp{ii}+(jj-11)*IntCont*tempelec.elec_Info.vector{ii}(4:6)+61.5*tempelec.elec_Info.vector{ii}(4:6);
                    else
                        elec_Info_Final.pos{mm}=tempelec.elec_Info.stp{ii}+(jj-1)*IntCont*tempelec.elec_Info.vector{ii}(4:6)+1*tempelec.elec_Info.vector{ii}(4:6);
                    end
                    elec_Info_Final.name{mm}=[strcat(tempelec.elec_Info.name{ii},num2str(jj))];
                end
            end
        else
            error('check the name order of the electrodes!!!')
        end
    end
    tala.electrodes = [];
    for im=1:mm
        tala.electrodes(im,:)=elec_Info_Final.pos{im};
        if tala.electrodes(im,1)<0
            elec_Info_Final.hem(im,1)=1;
        else
            elec_Info_Final.hem(im,1)=2;
        end
        tala.name{im,1}=elec_Info_Final.name{im};
        elec_Info_Final.eletype{im,1}='Depth';
    end
    tala.number=tempelec.elec_Info.number;
    elec_Info_Final.seeg_pos=mm;
    tala.seeg_pos=mm;
    
    if eleIndex==3
        ecoghem=[];
        for ec=1:size(ecog_electrodes,1)
            if ecog_electrodes(ec,1)<0
                ecoghem(ec,1)=1;
            else
                ecoghem(ec,1)=2;
            end
        end
        tala.electrodes=[tala.electrodes;ecog_electrodes];
        tala.name=[tala.name;tempelec.elecInfo.name(tempelec.elecInfo.seeg_points+1:end)'];
        elec_Info_Final.pos=[elec_Info_Final.pos,(mat2cell(ecog_electrodes,ones(1,size(ecog_electrodes,1)),3))'];
        elec_Info_Final.name=tala.name';
        elec_Info_Final.hem=[elec_Info_Final.hem;ecoghem];
        for ie=1:length(ecog_electrodes)
            elec_Info_Final.eletype{mm+ie,1}='Grid';
        end
    end
else
    tala.name=(tempelec.elecInfo.name)';
    tala.number = 1;
    tala.seeg_pos=0;
    elec_Info_Final.pos=(mat2cell(tala.electrodes,ones(1,size(tala.electrodes,1))))';
    elec_Info_Final.name=tempelec.elecInfo.name;
    elec_Info_Final.seeg_pos=0;
    
    for ec=1:length(elec_Info_Final.pos)
        elecpos=elec_Info_Final.pos{ec};
        if elecpos(1)<0
            elec_Info_Final.hem(ec,1)=1;
        else
            elec_Info_Final.hem(ec,1)=2;
        end
    end
    for ie=1:length(elec_Info_Final.pos)
        elec_Info_Final.eletype{ie,1}='Grid';
    end
end
hemnum=unique(elec_Info_Final.hem);
if length(hemnum)==2
    ihindex=[];
    for ih=1:2 % 1 or 2
        ihindex{ih}=find(elec_Info_Final.hem==ih);
        if length(ihindex{ih})<=2 % this works most time but should check here when errors appears
            otherside=setdiff(hemnum,ih);
            elec_Info_Final.hem(ihindex{ih})=otherside;
        end
    end
end
tala.hem=elec_Info_Final.hem;
tala.eleIndex=eleIndex;
tala.eletype=elec_Info_Final.eletype;
subject.tala=tala;
elec_Info_Final.eleIndex=eleIndex;

save([pathToSubjectDir, '/Electrodes/electrodes_Final.mat'],'elec_Info_Final','tala');

subject.tala.electrodes = tala.electrodes;
subject.tala.name=tala.name;
subject.tala.number=tala.number;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pathtosegmentationdir=[pathToSubjectDir,'/Segmentation'];
ntools_elec_outer_brain(pathtosegmentationdir,scriptDirectory,handles.ConfigurationPath.freesurfer_directory,handles);
pathToLhPialout = strcat(pathToCorticalSurfacesDir, '/lh.pial-outer-smoothed');
pathToRhPialout = strcat(pathToCorticalSurfacesDir, '/rh.pial-outer-smoothed');
leftcortexout=[];
rightcortexout=[];
pause(10);

[LHtempvertout, LHtemptriout] = read_surf(pathToLhPialout);
[RHtempvertout, RHtemptriout] = read_surf(pathToRhPialout);

% references to vert matrix must be 1-based
LHtemptriout = LHtemptriout + 1;
RHtemptriout = RHtemptriout + 1;

leftcortexout.vert= LHtempvertout;
leftcortexout.tri = LHtemptriout;
rightcortexout.vert= RHtempvertout;
rightcortexout.tri = RHtemptriout;
cortexout.vert = [LHtempvertout; RHtempvertout];
cortexout.tri = [LHtemptriout; RHtemptriout+size(LHtempvertout, 1)];

pathToLhPial = strcat(pathToCorticalSurfacesDir, '/lh.pial');
pathToRhPial = strcat(pathToCorticalSurfacesDir, '/rh.pial');

leftcortex=[];
rightcortex=[];
% make sure that the matlab folder inside the freesurfer folder is on the
% matlab path or else read_surf will be missing
[LHtempvert, LHtemptri] = read_surf(pathToLhPial);
[RHtempvert, RHtemptri] = read_surf(pathToRhPial);

% references to vert matrix must be 1-based
LHtemptri = LHtemptri + 1;
RHtemptri = RHtemptri + 1;

% all RH verts come after all LH verts
adjustedRHtemptri = RHtemptri + size(LHtempvert, 1);
%%
subject.leftcortex.vert= LHtempvert;
subject.leftcortex.tri = LHtemptri;
subject.rightcortex.vert= RHtempvert;
subject.rightcortex.tri = RHtemptri;
% put all verts in same matrix, RH after LH
subject.cortex.vert = [LHtempvert; RHtempvert];

% put all tris in same matrix, with corrected RH tris
subject.cortex.tri = [LHtemptri; adjustedRHtemptri];
cortex=subject.cortex;
leftcortex=subject.leftcortex;
rightcortex=subject.rightcortex;

pathToLhPial = strcat(pathToCorticalSurfacesDir, '/lh.sphere.reg');
pathToRhPial = strcat(pathToCorticalSurfacesDir, '/rh.sphere.reg');

leftcortexreg=[];
rightcortexreg=[];
% make sure that the matlab folder inside the freesurfer folder is on the
% matlab path or else read_surf will be missing
[LHtempvertreg, LHtemptrireg] = read_surf(pathToLhPial);
[RHtempvertreg, RHtemptrireg] = read_surf(pathToRhPial);

% references to vert matrix must be 1-based
LHtemptrireg = LHtemptrireg + 1;
RHtemptrireg = RHtemptrireg + 1;

% all RH verts come after all LH verts
leftcortexreg.vert= LHtempvertreg;
leftcortexreg.tri = LHtemptrireg;
rightcortexreg.vert= RHtempvertreg;
rightcortexreg.tri = RHtemptrireg;
cortexreg.vert = [LHtempvertreg; RHtempvertreg];
cortexreg.tri = [LHtemptrireg; RHtemptrireg+size(LHtemptrireg, 1)];
%%
save([pathToSubjectDir,'/MATLAB/WholeCortex.mat'],'leftcortex','rightcortex','cortex','rightcortexout','leftcortexout','cortexout','rightcortexreg','leftcortexreg','cortexreg');

%%setactivations values for each contacts
activations=ones(size(tala.electrodes,1),1); % change this value when needed

para1 = get(handles.popupmenu_DP_KernelType,'value');
para2 = str2num(get(handles.edit_DP_CutoffDistance_Cortical,'string'));
para3 = str2num(get(handles.edit_DP_CutoffDistance_CP,'string'));
kernel_curoff=[para1,para2,para3];% change this value when needed, typein 1 (gaussian) or 2 (linear)
if ~all(kernel_curoff==handles.KernelType_lasttime(1:3))
    handles.CalculationFlag = 0;
    handles.KernelType_lasttime(1:3) = kernel_curoff;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if EnvFcnFlag == 1
    handles = plotbrainfunction_alone(subject.cortex.vert, subject.cortex.tri, subject.tala, activations, subjectID, pathToSubjectDir, kernel_curoff, handles);
elseif EnvFcnFlag == 2
    handles = plotbrainfunction_plot(subject.cortex.vert, subject.cortex.tri, subject.tala, activations, subjectID, pathToSubjectDir, kernel_curoff, handles);
end
end
