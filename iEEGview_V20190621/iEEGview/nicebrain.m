function errorflag = nicebrain(subjectDirectory, subjectID, fsDirectory, scriptDirectory, segment, coreg, handles)
%
% This function takes MRI and CT DICOM files. If the segment flag is 1,
% this function will start a freesurfer segmentation on the MRI DICOM
% files. If the coreg flag is 1, this function will convert both scans to
% NIfTI format and coregister them. Regardless of how the flags are set the
% function will proceed to open the NIfTI files and prompt the user to
% isolate and select the electrodes.
% 
% subjectDirectory must be full path including the actual subject
% directory.
% e.g.: '~/Desktop/Subject001Data'
% Also see the section on proper initial subject directory structure
% below.
%
% subjectID is what freesurfer will name the directory it places the
% results of recon-all in. This directory will be created in
% fsDirectory/freesurfer/subjects/
% e.g.: 'Subject001'
%  
% fsDirectory must be the directory freesurfer is installed in, not
% including the actual freesurfer directory. 
% e.g.: '/Applications', if freesurfer is installed in /Applications 
%
% scriptDirectory is the directory in which the shell scripts is placed.
% e.g.: '/Users/ncollisson/Dropbox/brainresearch'
% This script should be kept in the same directory as the other files that
% come with this package.
%
% segment is a flag that can be 1 or 0. If it is set to 1 then a freesurfer
% segmentation will be started on the MRI DICOMs.
%
% coreg is a flag that can be 1 or 0. If it is set to 1 then the DICOM
% files will be converted to NIfTI format and the CT scan will be
% coregistered to the MRI scan.
%
% Proper initial subject directory structure:
%
% SubjectDirectory
% \_ DICOM
%    \_ MRI
%    \_ CT
%
% The MRI and CT subdirectories are within the DICOM subdirectory which is
% within the main subject directory. The MRI and CT subdirectories should
% contain the MRI and CT DICOM files, respectively. The DICOM files must
% have the .dcm suffix.
%
% This function will automatically convert your DICOM files to NIfTI files,
% start a freesurfer segmentation, and open the CT and MRI NIfTI files in 
% freeview. You can confirm that the segmentation has started by using 
% activity monitor to look for a process the starts with mri_ or by
% navigating to the subject directory within freesurfer, going to scripts,
% and looking for the presence of a file called IsRunning.lh+rh. The
% ongoing process of the segmentation can and should be monitored by
% opening the recon-all.log file also in the scripts directory.
% When the CT and MRI files show up in freeview, inspect the results of the
% coregistration by changing the opacity of one of the images and viewing
% from different angles. This can be made easier by selecting "View" -> 
% "Viewport Layout" -> "1 X 1" and "3D", also under "Viewport Layout".
% 
% Select the electrodes by:
% 1. Select the CT scan (the file should start with "rs") in the window 
%    under the "Volumes" tab.
% 2. Click "Show as isosurface in 3D view"
% 3. Click "Extract all regions"
% 4. Change the values of "High threshold" and "Low threshold" until the
%    electrodes are as isolated as possible. Good values to start with
%    might be 2600 and 4600 for low and high, respectively. Most likely,
%    you will want to keep the high threshold at its maximum value.
% 5. Change the value of "Smooth iterations" to 20.
% 6. Click the button labeled "Save". Do not save by right clicking the
%    isosurface as this can cause a bug that messes up the coordinate 
%    systems.
% 7. Save the isosurface in the "Electrodes" folder of your subject
%    directory.
%
% Next, hit enter to start the sortelec() function. This function will
% allow you to select and number the electrodes in the order of your
% choosing. Once you are done selecting the electrodes, the electrodes will
% be saved in both .dat and .mat format. .dat is used for freeview and .mat
% is used for MATLAB.
% 
% The electrodes can be viewed together with the cortical surface in
% freeview or in MATLAB with activateBrain. Perform the following steps to 
% use freeview for visualization:
%
% 1. Select File -> Load Surface... and then navigate to the files rh.pial
%    and lh.pial. By default, these files are placed in <freesurfer installation
%    directory>/freeview/subjects/<your subject ID>/surf/. Select both files
%    and click open.
% 2. Select File -> Load Volume... and then navigate to one of the
%    coregistered NIfTI images in your subject directory.
% 3. Select File -> Load Point Set..., click the folder icon in the new
%    window that pops up, and then navigate to the saved .dat file of your
%    electrodes. This should be in the electrodes subdirectory of your
%    subject folder. Then click OK and view your electrodes. You can adjust
%    the size and color of the electrodes by clicking on the Point Sets tab
%    in the upper-left corner and then adjusting the properties as desired
%    in the panel below.
%
% Perform the following steps to use MATLAB with activateBrian for 
% visualization:
% 
% 1. Run the function called plotusingmatlab(). See the function for
%    documentation on how to use it.
% This is the functions from activebrain %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checks to make sure everything is in place

if exist(subjectDirectory, 'dir');
    fprintf('Subject directory found\n');
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = 'Subject directory found...';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
else
    fprintf('\nSubject directory not found at %s', subjectDirectory);
    % cc
    tmptext{1} = get(handles.edit_State,'string');
    tmptext{end+1} = ['Subject directory not found at', subjectDirectory '...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    return;
end

if exist(strcat(fsDirectory, '/freesurfer'), 'dir');
    fprintf('freesurfer directory found\n');
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = 'freesurfer directory found...';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
else
    fprintf('freesurfer directory not found in %s', fsDirectory);
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['freesurfer directory not found at', fsDirectory,'...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
end

if ~exist(strcat(scriptDirectory, '/iEEGview/importdata_recon-all.sh'), 'file')
    fprintf('Shell script importdata_recon-all.sh not found in %s', scriptDirectory);
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Shell script importdata_recon-all.sh not found in', scriptDirectory '...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
end

if ~exist(strcat(scriptDirectory, '/iEEGview/viewMRIandCT.sh'), 'file')
    fprintf('Shell script viewMRIandCT.sh not found in %s', scriptDirectory);
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Shell script viewMRIandCT.sh not found in', scriptDirectory '...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
end

yesDICOM = exist(strcat(subjectDirectory, '/DICOM'), 'dir');

if ~yesDICOM
    fprintf('Could not locate the DICOM subdirectory within the subject directory\n');
    fprintf('Refer to the documentation for the correct subject directory structure\n');
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Could not locate the DICOM subdirectory within the subject directory'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = ['Refer to the documentation for the correct subject directory structure...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

if segment || coreg

yesMRI = exist(strcat(subjectDirectory, '/DICOM/MRI'), 'dir');

if ~yesMRI
    fprintf('Could not locate the MRI DICOM subdirectory\n');
    fprintf('Refer to the documentation for the correct subject directory structure\n');
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Could not locate the MRI DICOM subdirectory'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = ['Refer to the documentation for the correct subject directory structure...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

yesCT = exist(strcat(subjectDirectory, '/DICOM/CT'), 'dir');

if ~yesCT && coreg
    fprintf('Could not locate the CT DICOM subdirectory\n');
    fprintf('Refer to the documentation for the correct subject directory structure\n');    
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Could not locate the CT DICOM subdirectory'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = ['Refer to the documentation for the correct subject directory structure...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end

% assembles path to dicoms
mriDICOMpath = strcat(subjectDirectory, '/DICOM/MRI/');
ctDICOMpath = strcat(subjectDirectory, '/DICOM/CT/');

% gets all dicom files from dicom folder
mriDICOMfiles = dir(strcat(mriDICOMpath, '/*.dcm'));
ctDICOMfiles = dir(strcat(ctDICOMpath, '/*.dcm'));


% puts dicom file names in array
mriDICOMfilenames = {mriDICOMfiles.name}';
ctDICOMfilenames = {ctDICOMfiles.name}';

% gets first dicom file from MRI dicom folder because this is what
% freesurfer needs to start the segmentation

%%%%%
firstMRIdicom = mriDICOMfilenames(1);
firstMRIdicom = firstMRIdicom{1};

% check if files are there
if isempty(mriDICOMfilenames)
    fprintf('No Corresponding Subject MRI DICOM files found in %s/DICOM/MRI/', subjectDirectory);
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['No Corresponding Subject MRI DICOM files found in', subjectDirectory, '/DICOM/MRI/...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
elseif isempty(ctDICOMfilenames) && coreg
    fprintf('No Corresponding Subject CT DICOM files found in %s/DICOM/CT/', subjectDirectory);
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['No Corresponding Subject CT DICOM files found in', subjectDirectory, '/DICOM/MRI/...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    return;
end
end
%%%%%
% only run this part of the code if the segment flag is set to true
if segment

    fprintf('\nAttempting to start freesurfer segmentation...\n\n');
    % cc
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Attempting to start freesurfer segmentation...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

    % make sure this subject doesn't already exist in freesurfer
    subjectExists = exist(strcat(fsDirectory, '/freesurfer/subjects/', subjectID), 'dir');

    if subjectExists
        fprintf('It appears that there is already a subject folder in freesurfer for this subject\n');
        fprintf('Either delete this folder (%s/freesurfer/subjects/%s/) or change the subjectID\n\n', fsDirectory, subjectID);
        fprintf('Warning: If you delete the folder, any previous segmentation results\nsaved within it will be lost\n');
        % cc
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['It appears that there is already a subject folder in freesurfer for this subject.' ...
            'Either delete this folder (' fsDirectory '/freesurfer/subjects/' subjectID '/) or change the subjectID.'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        tmptext{end+1} = ['Warning: If you delete the folder, any previous segmentation results\nsaved within it will be lost...'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        tmptext{end+1} = [];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
        
        return;
    end

    % runs script to: set up fs, import subject data, do recon-all (which is
    % segmentation on cortex)
    shellcommand = [scriptDirectory '/iEEGview/importdata_recon-all.sh ' fsDirectory ' ' subjectDirectory ' ' subjectID ' ' firstMRIdicom];
    [status,cmdout] = system([shellcommand '&']);

    
    % check if segmentation starts successfully
    % pause() is to give the IsRunning file time to appear
    for i = 1:3
        fprintf('Checking to see if freesurfer segmentation has started...\n\n');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['Checking to see if freesurfer segmentation has started...'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
        pause(10);

        notRunning = ~exist(strcat(fsDirectory, '/freesurfer/subjects/', subjectID, '/scripts/IsRunning.lh+rh'), 'file');

        if i == 3 && notRunning
            fprintf('The file %s/freesurfer/subjects/%s/scripts/IsRunning.lh+rh\n', fsDirectory, subjectID);
            fprintf('that indicates that a segmentation process is running on your subject\n');
            fprintf('cannot be found. This is most likely because freesurfer encountered\n');
            fprintf('an error trying to segment your subject. Check the log file recon-all.log\n');
            fprintf('in %s/freesurfer/subjects/%s/scripts/recon-all.log\n', fsDirectory, subjectID);

            tmptext = get(handles.edit_State,'string');
            tmptext{end+1} = ['The file ',fsDirectory,'/freesurfer/subjects/',subjectID,'/scripts/IsRunning.lh+rh'...
                'that indicates that a segmentation process is running on your subject'...
                'cannot be found. This is most likely because freesurfer encountered'...
                'an error trying to segment your subject. Check the log file recon-all.log'...
                'in ',fsDirectory,'/freesurfer/subjects/',subjectID,'/scripts/recon-all.log\n']
            fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
            set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
        
            return;
        elseif ~notRunning
            break;
        end
    end

    fprintf('Freesurfer segmentation has started; this process may take more than 24 hours\n\n');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['Freesurfer segmentation has started; this process may take more than 24 hours...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

    pause(2);
    fprintf('The progress of the segmentation process can be observed by opening\n');
    fprintf('%s/freesurfer/subjects/%s/scripts/recon-all.log\n\n', fsDirectory, subjectID);
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['The progress of the segmentation process can be observed by opening ' ...
        fsDirectory,'/freesurfer/subjects/',subjectID,'/scripts/recon-all.log'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

    pause(2);
    fprintf('When the segmentation is complete the results are saved in\n%s/freesurfer/subjects/%s/\n', fsDirectory, subjectID);
    fprintf('The pial surfaces are saved as rh.pial and lh.pial in %s/surf/\n\n', subjectID);
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['When the segmentation is complete the results are saved in ',fsDirectory,'/freesurfer/subjects/',subjectID,'/...' ...
        'The pial surfaces are saved as rh.pial and lh.pial in ',subjectID,'/surf/...'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    pause(4);

end

% only do coreg if the coreg flag is true, otherwise skip to electrode
% clicking
if coreg

fprintf('Now attempting to start DICOM to NIfTI conversion and CT to MRI coregistration\n\n');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Now attempting to start DICOM to NIfTI conversion and CT to MRI coregistration...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
pause(1);

fprintf('Checking to see that everything is in order...\n\n');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Checking to see that everything is in order...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
pause(2);

noNIfTI = ~exist(strcat(subjectDirectory, '/NIfTI'), 'dir');
noElectrodes = ~exist(strcat(subjectDirectory, '/Electrodes'), 'dir');
noMATLAB = ~exist(strcat(subjectDirectory, '/MATLAB'), 'dir');

properDirectorySetup = noNIfTI & noElectrodes & noMATLAB;

if ~properDirectorySetup
    disp('It seems that this subject already has a NIfTI, Electrodes,');
    disp('or MATLAB folder present in its directory. Please remove these');
    disp('folders from the current subject directory or start a new');
    disp('subject directory with the proper directory structure.');
    
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['It seems that this subject already has a NIfTI, Electrodes,'...
        'or MATLAB folder present in its directory. Please remove these'...
        'folders from the current subject directory or start a new'...
        'subject directory with the proper directory structure.'];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

    return;
end

fprintf('Now converting MRI DICOM to NIfTI\n\n');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Now converting MRI DICOM to NIfTI...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

% use spm functions to convert dicom to nifti
mriDICOMheaders = spm_dicom_headers(char(strcat(mriDICOMpath, mriDICOMfilenames)));
mriNIfTI = spm_dicom_convert(mriDICOMheaders,'all','flat','img');
fprintf('Now converting CT DICOM to NIfTI\n\n');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Now converting CT DICOM to NIfTI...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

ctDICOMheaders = spm_dicom_headers(char(strcat(ctDICOMpath, ctDICOMfilenames)));
ctNIfTI = spm_dicom_convert(ctDICOMheaders,'all','flat','img');

fprintf('Now coregistering the CT scan to the MRI scan\n\n');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Now coregistering the CT scan to the MRI scan...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

% make file names of nifti files into char
mriNIfTIfiles = char(mriNIfTI.files);
ctNIfTIfiles = char(ctNIfTI.files);

% remove extension, add each one later
mriNIfTIfiles = mriNIfTIfiles(1:(end - 4));
ctNIfTIfiles = ctNIfTIfiles(1:(end - 4));

% prepare the paths for the ct and mri NIfTI files to be moved to
mriPath = strcat(subjectDirectory, '/NIfTI/MRI/');
ctPath = strcat(subjectDirectory, '/NIfTI/CT/');

% make the directories to hold the NIfTI files
mkdir(mriPath);
mkdir(ctPath);

% if statements are to prevent error if files are already in the right
% directory
% shouldn't be needed anymore now that checks are performed to ensure that
% the NIfTI folder does not exist prior to conversion
if ~strcmp(mriPath, pwd)
    % move the resulting mri files (.img and .hdr) to the nifti folder
    movefile(strcat(mriNIfTIfiles, '.img'), mriPath);
    movefile(strcat(mriNIfTIfiles, '.hdr'), mriPath);
end

if ~strcmp(ctPath, pwd)
    % move the resulting ct files (.img and .hdr) to the nifti folder
    movefile(strcat(ctNIfTIfiles, '.img'), ctPath);
    movefile(strcat(ctNIfTIfiles, '.hdr'), ctPath);
end

% separate file paths and file names and save file names
[~, mrifilename] = fileparts(mriNIfTIfiles);
[~, ctfilename] = fileparts(ctNIfTIfiles);

% append extensions to file names and store for easy reference to files later on
% also prepend subject directory for full path
mriIMG = strcat(subjectDirectory, '/NIfTI/MRI/', mrifilename, '.img');
ctIMG = strcat(subjectDirectory, '/NIfTI/CT/', ctfilename, '.img');

% generate handles for mri and ct nifti images
mrihandle = spm_vol(mriIMG);
cthandle = spm_vol(ctIMG);

% put data into the job structure so that spm knows how to access it
job.ref = mrihandle;
job.source = cthandle;
%job.other = {};

job.eoptions.cost_fun = 'nmi';
job.eoptions.sep = [4 2];
job.eoptions.fwhm = [7 7];
job.eoptions.tol = [0.02, 0.02, 0.02, 0.001, 0.001, 0.001, 0.01, 0.01, 0.01, 0.001, 0.001, 0.001];

job.roptions.mask = 0;
job.roptions.interp = 1;
job.roptions.wrap = 1;
job.roptions.prefix = 'r';

% feed the job structure into spm
% I took this from the spm coreg est write function
% It makes the coreg work
% I have modified it to take my input
%%%%%%%%%%%%%%%%%%%%%%%%%%% start spm code %%%%%%%%%%%%%%%%%%%%%%%%%%%
job.other = {};

x = spm_coreg(job.ref, job.source, job.eoptions);

M = spm_matrix(x);
PO = job.source;
MM = zeros(4,4,numel(PO));
MM(:,:,1) = spm_get_space(PO.fname);
spm_get_space(PO.fname, M\MM(:,:,1));

P  = {job.ref.fname; job.source.fname};

spm_reslice(P);

out.cfiles = PO;
out.M      = M;
out.rfiles = cell(size(out.cfiles));
[pth,nam,ext,num] = spm_fileparts(out.cfiles.fname);
out.rfiles{1} = fullfile(pth,[job.roptions.prefix, nam, ext, num]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end spm code %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creates directory for electrodes
electrodesDirectory = strcat(subjectDirectory, '/Electrodes');
if ~exist('electrodesDirectory', 'dir')
    mkdir(electrodesDirectory);
end

%%%%put instructions here
A = {'The conversion has been finished. Freeview will launch automatically in the following step.'
    'Please finish the coregisration manually and save the results in the folder ''Electrodes'' in the subject directory.'
    'Select Yes to continue. Otherwise the process will stop.'};
tmptext = get(handles.edit_State,'string');
tmptext(end+1:end+3) = A;
for i = 2:-1:0
    fprintf(handles.ProcessState,[tmptext{end-i} '\r\n']);
end
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

forwardflag = questdlg(A,'','Yes','No','Yes');
switch forwardflag
    case 'Yes'
    case 'No'
        errorflag = 1;
        return;
end

shellcommand = [scriptDirectory '/iEEGview/viewMRIandCT.sh ' fsDirectory ' ' subjectDirectory '&'];
system(shellcommand)
end % start here if segment and coreg are 0

if segment || coreg
    return;
end

%%%%%%%%%%%%%%%%%%%% runs script to: set up fs, view mri and ct%%%%%%%%%%

% creates directory for electrodes
electrodesDirectory = strcat(subjectDirectory, '/Electrodes');
if ~exist('electrodesDirectory', 'dir')
    mkdir(electrodesDirectory);
end

%%%%% cc
A = {'Freeview should have already automatically opened and loaded the converted and coregistered scans. Confirm that the coregistration was successful by rotating and adjusting the opacity of the scans...'...
    'Also make sure that the MRI scan used for coregistration is the same one that was used for segmentation by loading the cortical surfaces lh.pial and rh.pial in surf/ and confirming they match up with the MRI scan...'...
    'If the coregistration was successful, isolate and save the electrodes as described in the documentation (found in this function and in the documentation file). If the coregistration was unsuccessful, see the documentation file for instructions on how to proceed...'...
    'After the electrode isosurface has been saved in the Electrodes directory, select Yes to run the electrode numbering script...'};
% tmptext = get(handles.edit_State,'string');
% tmptext{end+1} = ['Freeview should automatically open and load the converted and coregistered scans. Confirm that the coregistration was successful by rotating and adjusting the opacity of the scans. Also make sure that the MRI scan used for coregistration is the same one that was used for segmentation by loading the cortical surfaces lh.pial and rh.pial in surf/ and confirming they match up with the MRI scan. If the coregistration was successful, isolate and save the electrodes as described in the documentation (found in this function and in the documentation file). If the coregistration was unsuccessful, see the documentation file for instructions on how to proceed.' ...
% '     After the electrode isosurface has been saved in the Electrodes directory, select Yes to run the lectrode numbering script.'];
% tmptext{end+1} = [];
% set(handles.edit_State,'string',tmptext);
tmptext = get(handles.edit_State,'string');
tmptext(end+1:end+4) = A;
for i = 3:-1:0
    fprintf(handles.ProcessState,[tmptext{end-i} '\r\n']);
end
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

forwardflag = questdlg(A,'','Yes','No','Yes');
switch forwardflag
    case 'Yes'
    case 'No'
        errorflag = 1;
        return;
end


% c
% gets the vtk file in Electrodes sub-directory
electrodesvtk = dir(strcat(electrodesDirectory, '/*.vtk'));

% converts .vtk file into matlab-compatible matrix
electrodesSurf = importisosurface(strcat(electrodesDirectory, '/', electrodesvtk.name),handles);

% displays electrodes surfaces in matlab
handles.figure_ele = figure('color',[1,1,1]);
% axes(handles.axes_Display);
trisurf(electrodesSurf.triangles, electrodesSurf.vertices(:,1), electrodesSurf.vertices(:,2), electrodesSurf.vertices(:,3));

% start electrode numbering script and store data points
% saves the data as a matrix in a .mat file for use with activate brain
[elecMatrix,elecInfo] = sortelec(handles);
save(strcat(electrodesDirectory, '/', 'electrode_raw.mat'), 'elecInfo','elecMatrix');

% saves the electrode data as a point set for use in freeview
elecFileName = strcat(electrodesDirectory, '/elecPointSet.dat');
fileID = fopen(elecFileName, 'w+');

% writes the coordinates and header info to a .dat file so the clicked
% electrodes can be opened in freeview
for i = 1:size(elecMatrix, 1)
    fprintf(fileID, '%.4f %.4f %.4f\n', elecMatrix(i, :));
end


fprintf(fileID, '%s\n', 'info');
fprintf(fileID, '%s %u\n', 'numpoints', size(elecMatrix, 1));
fprintf(fileID, '%s\n', 'useRealRAS 1');

disp('The ordered electrodes have now been saved in');
disp('the subject directory in the Electrodes folder');
disp('as electrodes_raw.mat. To view the brain and its');
disp('electrodes you can use the function plotusingmatlab()');
disp('or you can load the point set called elecPointSet.dat');
disp('into freeview along with one of the brains volumes');
disp('and its pial surfaces.');
% c
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['The ordered electrodes have now been saved in',...
'the subject directory in the Electrodes folder',...
'as electrodes_raw.mat. To view the brain and its',...
'electrodes you can use the function plotusingmatlab()',...
'or you can load the point set called elecPointSet.dat',...
'into freeview along with one of the brains volumes',...
'and its pial surfaces....'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

saveas(handles.figure_ele,[handles.ConfigurationPath.subject_directory '/electrodes/ElectrodeLocalization.fig']);
close(handles.figure_ele);

errorflag = 0;
pause(1); % c


end
