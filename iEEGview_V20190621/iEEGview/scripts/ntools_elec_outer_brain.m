function ntools_elec_outer_brain(SubjectPath,scriptDirectory,fsDirectory,handles)
%function ntools_elec_outer_brain(SubjectPath)
%
% SubjectPath = Freesurfer subject folder
% scriptDirectory = iEEGview subject folder
% fsDirectory = Freesurfer dir
%  check the outer-brain lgi surface, if they are not there, create them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is updated by Guangye Li(liguangye.hust@Gmail.com) for the
% using in Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SubjectPath = [SubjectPath '/surf/'];
lgi_lh = exist([SubjectPath 'lh.pial-outer-smoothed'],'file');
lgi_rh = exist([SubjectPath 'rh.pial-outer-smoothed'],'file');

if lgi_lh==0
    % create the lh
    if exist([SubjectPath 'lh.pial'],'file');
        fprintf('Creating the left hemisphere outer smoothed brain surface \n');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['Creating the left hemisphere outer smoothed brain surface'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

        outer_smoothed('lh',SubjectPath,scriptDirectory,fsDirectory);
    else
        fprintf('No lh.pial file detected, please finish the recon-all first \n');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['No lh.pial file detected, please finish the recon-all first'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

        return;
    end
else
    fprintf('lh.pial-outer-smoothed file detected\n');
    tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['lh.pial-outer-smoothed file detected'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
end

if lgi_rh==0
    % create the rh
    if exist([SubjectPath 'rh.pial'],'file');
        fprintf('Creating the right hemisphere outer smoothed brain surface \n');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['Creating the right hemisphere outer smoothed brain surface'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
        outer_smoothed('rh',SubjectPath,scriptDirectory,fsDirectory);
    else
        fprintf('No rh.pial file detected, please finish the recon-all first \n');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['No rh.pial file detected, please finish the recon-all first'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
        return;
    end
else
    fprintf('rh.pial-outer-smoothed file detected\n');
    tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['rh.pial-outer-smoothed file detected'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
end

function outer_smoothed(sph,Sub_Path,scriptDirectory,fsDirectory)

% this function is to create the pial-outer-smoothed surface by
% implementing first 4 steps of mris_compute_lgi

spath = [Sub_Path sph];
shellcommand = [scriptDirectory '/iEEGview/mrifilloutersurface.sh ' fsDirectory ' ' spath '&'];
[status, cmdout]=system(shellcommand);
pause(15)

make_outer_surface ([spath '.pial.filled.mgz'],15,[spath '.pial-outer']);

shellcommand=[scriptDirectory '/iEEGview/mrifilloutersurfaceextsm.sh ' fsDirectory ' ' spath];
% mris_extract = sprintf('mris_extract_main_component %s.pial-outer %s.pial-outer-main',spath,spath);
system([shellcommand '&']);




