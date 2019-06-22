function varargout = iEEGview(varargin)
% IEEGVIEW MATLAB code for iEEGview.fig
%      IEEGVIEW, by itself, creates a new IEEGVIEW or raises the existing
%      singleton*.
%
%      H = IEEGVIEW returns the handle to a new IEEGVIEW or the handle to
%      the existing singleton*.
%
%      IEEGVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IEEGVIEW.M with the given input arguments.
%
%      IEEGVIEW('Property','Value',...) creates a new IEEGVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before iEEGview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to iEEGview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help iEEGview

% Last Modified by GUIDE v2.5 05-May-2019 16:33:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @iEEGview_OpeningFcn, ...
    'gui_OutputFcn',  @iEEGview_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before iEEGview is made visible.
function iEEGview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iEEGview (see VARARGIN)

% Choose default command line output for iEEGview

% set the file path before processing
ConfigurationPath.subject_directory = cd;
% ConfigurationPath.spm_fspath = [cd,'/Applications'];
ConfigurationPath.iEEGview_directory = [cd];%[cd,'/iEEGview'];
ConfigurationPath.freesurfer_directory = '/Applications';
ConfigurationPath.subject_name = 'Demo';
ConfigurationPath.DICOM_directory = [cd,'/DICOM'];

set(handles.edit1,'string',ConfigurationPath.subject_directory);
% set(handles.edit2,'string',ConfigurationPath.spm_fspath);
set(handles.edit3,'string',ConfigurationPath.iEEGview_directory);
set(handles.edit4,'string',ConfigurationPath.freesurfer_directory);
set(handles.edit5,'string',ConfigurationPath.subject_name);
set(handles.edit6,'string',ConfigurationPath.DICOM_directory);

handles.ConfigurationPath = ConfigurationPath;
handles.ConfigurationPath
% addpath(genpath(handles.ConfigurationPath.spm_fspath));
addpath(genpath(handles.ConfigurationPath.iEEGview_directory));
addpath(genpath(handles.ConfigurationPath.subject_directory));
addpath(genpath([handles.ConfigurationPath.freesurfer_directory '/freesurfer/fsfast/toolbox']));
addpath(genpath([handles.ConfigurationPath.freesurfer_directory '/freesurfer/matlab']));

addpath(genpath(cd));

handles.output = hObject;

handles.CalculationFlag = 0; % the calculation flag of model building
handles.CalculationFlag_Activation = 0;
handles.CalculationFlag_Activation_std = 0;

handles.KernelType_lasttime = zeros(1,4);

handles.ActivationData = []; % the activation data

handles.ElectrodeIndex = get(handles.popupmenu_ElectrodeType,'value'); % the index of electrode type

handles.specspec = [];

axes(handles.axes_Display);
axis off;
% the sjtu picture loading
% axes(handles.axes_SJTU);
% ii = imread('SJTU.jpg');
% image(ii);
% axis off;
% Update handles structure

set(hObject,'toolbar','figure')

mkdir([handles.ConfigurationPath.subject_directory '/States'])
filename = [handles.ConfigurationPath.subject_directory '/States/ProcessState_' Time2String(datetime) '.txt'];
handles.ProcessState = fopen(filename,'a');

handles.ConfigurationPath.electrodes_path = [ConfigurationPath.subject_directory,'/Electrodes/electrode_raw.mat'];
handles.ConfigurationPath.surfaces_directory = [ConfigurationPath.subject_directory,'/Segmentation/surf'];
handles.ConfigurationPath.volume_path = [ConfigurationPath.subject_directory,'/Segmentation/mri/orig.mgz'];

guidata(hObject, handles);

% UIWAIT makes iEEGview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = iEEGview_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_cogregration.
function checkbox_cogregration_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_cogregration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_cogregration


% --- Executes on button press in checkbox_electrodeselection.
function checkbox_electrodeselection_Callback(hObject, eventdata, handles)
set(handles.popupmenu_DisplayOption,'value',1); % displaying the channel selection
set(handles.uipanel_DisplayParameter,'visible','off');
% hObject    handle to checkbox_electrodeselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_electrodeselection


% --- Executes on button press in checkbox_display.
function checkbox_display_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_display


% --- Executes on button press in checkbox_segmentation.
function checkbox_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_segmentation


% --- Executes on button press in pushbutton_ModelBuild.
function pushbutton_ModelBuild_Callback(hObject, eventdata, handles)

ConfigurationPath = handles.ConfigurationPath;
set(handles.pushbutton_ModelBuild,'backgroundcolor',[1,0,0]);
% check if excuting the segmentation task
SegmentationFlag = get(handles.checkbox_segmentation,'value');
if SegmentationFlag
    nicebrain(ConfigurationPath.subject_directory, ConfigurationPath.subject_name, ConfigurationPath.freesurfer_directory, ConfigurationPath.iEEGview_directory, 1, 0,handles);
    tmptext = get(handles.edit_State,'string');
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    tic;
    set(handles.text_SegmentationTime,'visible','on');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = 'Segmentation processing... Please don''t turn off your computer!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    finishflag = 0;
    while ~finishflag
        tmpfile = ['/Applications/freesurfer/subjects/' ConfigurationPath.subject_name '/scripts/recon-all.log'];
        newfile = ['/Applications/freesurfer/subjects/' ConfigurationPath.subject_name '/scripts/tmplog.log'];
        copyfile(tmpfile,newfile);
        finishtext = [ConfigurationPath.subject_name ' finished without error'];
        fid = fopen(newfile);
        a = 0;
        while ~feof(fid)
            tline = fgetl(fid);
            if contains(tline,finishtext)
                a = a+1;
            end
        end
        fclose(fid);
        delete(newfile);
        if a>=2
            finishflag = 1;
        end
        t = toc;
        hour = floor(t/3600);
        min = floor((t-hour*3600)/60);
        sec = floor(t-hour*3600-min*60);
        tmptext = [num2str(hour) ' h ' num2str(min) ' m ' num2str(sec) ' s '];
        set(handles.text_SegmentationTime,'string',tmptext)
        pause(0.5);
    end
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = 'Segmentation completed!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    %%%%% movefile from  freesurfer directory to subject directory
    segfilefreesurfer=[ConfigurationPath.freesurfer_directory,'/freesurfer/subjects/',ConfigurationPath.subject_name];
    segfilesubject=[ConfigurationPath.subject_directory,'/Segmentation/'];
    movefile(segfilefreesurfer,segfilesubject);
    pause(10);
    
    
end

% check if excuting the cogregration task
CogregrationFlag = get(handles.checkbox_cogregration,'value');
if CogregrationFlag
    nicebrain(ConfigurationPath.subject_directory, ConfigurationPath.subject_name, ConfigurationPath.freesurfer_directory, ConfigurationPath.iEEGview_directory, 0, 1,handles);
    %     msgbox('Cogregration completed!','Cogregration');
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = 'Coregistration completed!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
end

% check if excuting the electrode selection task
ElectrodeSelectionFlag = get(handles.checkbox_electrodeselection,'value');
if ElectrodeSelectionFlag
    set(handles.uipanel_DisplayParameter,'visible','off');
    set(handles.uipanel_View,'visible','off');
    pushbutton_Reset_Callback(hObject, eventdata, handles);
    %     axes(handles.axes_Display);
    errorflag = nicebrain(ConfigurationPath.subject_directory, ConfigurationPath.subject_name, ConfigurationPath.freesurfer_directory, ConfigurationPath.iEEGview_directory, 0, 0,handles);
    if errorflag
        return;
    end
    % Electrodes saving folder
    handles.ConfigurationPath.electrodes_path = [ConfigurationPath.subject_directory,'/Electrodes/electrode_raw.mat'];
    handles.ConfigurationPath.surfaces_directory = [ConfigurationPath.subject_directory,'/Segmentation/surf'];
    handles.ConfigurationPath.volume_path = [ConfigurationPath.subject_directory,'/Segmentation/mri/orig.mgz'];
    load(handles.ConfigurationPath.electrodes_path);
    switch handles.ElectrodeIndex
        case 1
            elec_Info.name=unique(elecInfo.name,'stable');
            handles.elec_Info.name = elec_Info.name;
        case 2
            % elec_Info.name=elecInfo.name;
        case 3
            elec_Info.name=unique(elecInfo.name(1:elecInfo.seeg_points),'stable');
            handles.elec_Info.name = elec_Info.name;
    end
    
    % Add electrodes contacts information. Update this for each subject
    %%%%% check the name order of the electrodes and input the value here!!!!
    %%%%% should be in the same order with the sequence or elecInfoname
    if handles.ElectrodeIndex==1 || handles.ElectrodeIndex==3
        tmpmsg = ['Please configurate the electrode number and type in the next step!'];
        msgbox(tmpmsg);
    end
    %     msgbox('ElectrodeSelection completed!','ElectrodeSelection');
    
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = 'ElectrodeSelection completed!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
    
    set(handles.popupmenu_DisplayOption,'value',2);
    DisplayParameterConfiguration;
    cla(handles.axes_Display);
end
handles.ConfigurationPath.surfaces_directory = [ConfigurationPath.subject_directory,'/Segmentation/surf'];

set(handles.pushbutton_ModelBuild,'backgroundcolor',[0.94,0.94,0.94]);
if ElectrodeSelectionFlag+CogregrationFlag+SegmentationFlag==0
    warndlg('No process has been excuted!');
end

guidata(hObject,handles);




% hObject    handle to pushbutton_ModelBuild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Configuration.
function pushbutton_Configuration_Callback(hObject, eventdata, handles)
color = get(handles.pushbutton_Configuration,'BackgroundColor');
set(handles.pushbutton_Configuration,'BackgroundColor',[1,0,0]);
handles.ConfigurationPath = Configuration_GUI;
% uiwait(handles.figure1);
handles.ConfigurationPath
% addpath(genpath(handles.ConfigurationPath.spm_fspath));
addpath(genpath(handles.ConfigurationPath.iEEGview_directory));
addpath(genpath(cd));
guidata(hObject,handles);
% msgbox('Configuration completed!','Configuration');

tmptext = get(handles.edit_State,'string');
tmptext{end+1} = 'Configuration completed!';
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));

set(handles.pushbutton_Configuration,'BackgroundColor',color);


% hObject    handle to pushbutton_Configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Display.
% function pushbutton_Display_Callback(hObject, eventdata, handles)
% % color = get(handles.pushbutton_Display,'BackgroundColor');
% % set(handles.pushbutton_Display,'BackgroundColor',[1,0,0]);
% % ConfigurationPath = handles.ConfigurationPath;
% % plotusingmatlab(ConfigurationPath.subject_directory, ConfigurationPath.subject_name, ConfigurationPath.surfaces_directory, ConfigurationPath.freesurfer_directory, ConfigurationPath.volume_path, ConfigurationPath.iEEGview_directory, ConfigurationPath.electrodes_path);
% % set(handles.pushbutton_Display,'BackgroundColor',color);
%
% color = get(handles.pushbutton_Display,'BackgroundColor');
% set(handles.pushbutton_Display,'BackgroundColor',[1,0,0]);
%
%
% set(handles.pushbutton_Display,'BackgroundColor',[1,1,1]);
% guidata(hObject,handles)

% PlotBrain_GUI(handles.ConfigurationPath);


% hObject    handle to pushbutton_Display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_AnatomyModel.
function pushbutton_AnatomyModel_Callback(hObject, eventdata, handles)
% if handles.CalculationFlag==0
%     errordlg('No electrode localization information existing! Please plot the electrode localization first!')
%     return;
% end
ConfigurationPath = handles.ConfigurationPath;

try
    load([ConfigurationPath.subject_directory '/Electrodes/electrodes_Final.mat']);
catch
    errordlg('No electrode localization information existing! Please plot the electrode localization first!')
    return;
end
% color = get(handles.pushbutton_AnatomyModel,'BackgroundColor');
set(handles.pushbutton_AnatomyModel,'BackgroundColor',[1,0,0]);
drawnow;

% eleIndex = elec_Info_Final.eleIndex;

[cpm,ok] = listdlg('ListString',{'desikan_killiany.gcs','destrieux.simple.2009-07-28.gcs','DKTatas40.gcs'},...
    'Name','Select a cortical parcellation method',...
    'OKString','OK','CancelString','Cancel',...
    'SelectionMode','single','ListSize',[180,80]);
if ~ok
    set(handles.pushbutton_AnatomyModel,'BackgroundColor',[1,1,1]);
    return;
    %     cpm = 1;
end
handles.cpm = cpm;

save([ConfigurationPath.subject_directory '/Electrodes/AnatomyMethod.mat'],'cpm','-v7.3');
% cpm = 1; % Cortical parcellation methods which need to be added to handle here in GUI

% Calculate the center of each cortical area and Color the surface of sub-cortical structures
switch cpm
    case 1
        handles.spec = 1:36;
        set(handles.edit_ColorfulCortexSpec,'string','1:36');
    case 2
        handles.spec = 1:72;
        set(handles.edit_ColorfulCortexSpec,'string','1:76');
    case 3
        handles.spec = 1:36;
        set(handles.edit_ColorfulCortexSpec,'string','1:36');
end

tmptext = get(handles.edit_State,'string');
tmptext{end+1} = 'Anatomy model calculating...';
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
pause(0.001);

Get_3D_Cortex_Center_v3(ConfigurationPath.subject_directory);

% Transfer Electrodes into the MRI volum
% This section is used to translate the electrodes and brain model in tkRAS
% coordinate system into RAS volex system. And then visualize the
% tranformation result for comparasion. Besides, the anatomical structure
% information was obtained using this script as well at the same time.
% Electrodes information are saved in the Electrode folder\electrodes_Final_Anatomy_wm.mat.

Plot_In_RAS_WM_v2(ConfigurationPath,cpm,handles.ElectrodeIndex,handles);
set(handles.pushbutton_AnatomyModel,'BackgroundColor',[1,1,1]);

set(handles.popupmenu_DisplayOption,'value',3);
DisplayParameterConfiguration;

% msgbox('AnatomyModel completed!')
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = 'AnatomyModel completed!';
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
guidata(hObject,handles);

% hObject    handle to pushbutton_AnatomyModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Display2.
function pushbutton_Display2_Callback(hObject, eventdata, handles)
AnatomyPlot_GUI(handles.ConfigurationPath);
% hObject    handle to pushbutton_Display2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Activations.
function pushbutton_Activations_Callback(hObject, eventdata, handles)
% color = get(handles.pushbutton_Activations,'BackgroundColor');
% set(handles.pushbutton_Activations,'BackgroundColor',[1,0,0]);
% PlotActivations_GUI(handles.ConfigurationPath);
set(handles.popupmenu_DisplayOption,'value',4);
DisplayParameterConfiguration;
handles.ActivationData = [];
guidata(hObject,handles);


% hObject    handle to pushbutton_Activations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_StandardModel.
function pushbutton_StandardModel_Callback(hObject, eventdata, handles)
% StandardModelPlot_GUI(handles.ConfigurationPath);
set(handles.popupmenu_DisplayOption,'value',5);
handles.MultiSubFlag = get(handles.popupmenu_Sub,'value');
if handles.MultiSubFlag==1
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = '';
    tmptext{end+1} = 'Standard model translating...';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

    ConfigurationPath = handles.ConfigurationPath;
    [trans_matrix]=Read_Transform_Matrix(ConfigurationPath.subject_directory);
    
    std_brain_path=[ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel'];
    
    
    xfm_path=[ConfigurationPath.subject_directory,'/MATLAB/xfrm_matrices.mat'];
    %     xfrm_matrices = importdata(xfm_path);
    load(xfm_path);
    
    Norig = xfrm_matrices(1:4, :);
    Torig = xfrm_matrices(5:8, :);
    subpath{1} = [ConfigurationPath.subject_directory '/Electrodes/electrodes_Final_Anatomy_wm.mat'];
    Electrode_mni = {};
    Electrode_fsave= {};
    Electrode_AnaName = {};
    hem={};
    for sub = 1
        try
            tmpdata = load(subpath{sub});
        catch
            errordlg('No anatomy file is found. Please finish the anatomy localiazation first!');
        end
        fssurfpath=fullfile(std_brain_path,'FSAVERAGE','MATLAB','WholeCortex.mat');
        if ~exist(fssurfpath,'file')
            errordlg('No standard brain file is found. Please check and finish the brain reconstruction first!');
        else
            fsctxfile=load(fssurfpath);
        end
        subsurfpath=fullfile(ConfigurationPath.subject_directory,'MATLAB','WholeCortex.mat');
        if ~exist(subsurfpath,'file')
            errordlg('No brain file is found. Please check and finish the brain reconstruction first!');
        else
            subctxfile=load(subsurfpath);
        end
        subsurfpath=fullfile(ConfigurationPath.subject_directory,'Segmentation','surf');
        subvolpath=fullfile(ConfigurationPath.subject_directory,'Segmentation','mri','T1.mgz');
        elec_inds=cell2mat(tmpdata.elec_Info_Final_wm.pos');
        elec_inds=Norig*inv(Torig)*[elec_inds,ones(size(elec_inds,1),1)]';        
        elec_inds=elec_inds(1:3,:)';
        
        [~,elec_norm_vol]=vol_normalization(subvolpath,elec_inds);
        for j=1:length(tmpdata.elec_Info_Final_wm.pos)
            pos_norm=[tmpdata.elec_Info_Final_wm.pos{j},1]';
            if ~isempty(strmatch(tmpdata.elec_Info_Final_wm.eletype{j},'Depth','exact'))
                pos_norm=trans_matrix*Norig*inv(Torig)*[tmpdata.elec_Info_Final_wm.pos{j},1]'; %%% MNI305
                tmpdata.elec_Info_Final_wm.norm_pos_mni{j}=elec_norm_vol(j,:);
                tmpdata.elec_Info_Final_wm.norm_pos_fsave{j}=pos_norm(1:3)';
            elseif ~isempty(strmatch(tmpdata.elec_Info_Final_wm.eletype{j},'Grid','exact'))
                tmpdata.elec_Info_Final_wm.norm_pos_mni{j}=elec_norm_vol(j,:);
                tmpdata.elec_Info_Final_wm.norm_pos_fsave{j}=sub2stdbrain(tmpdata.elec_Info_Final_wm.pos{j},tmpdata.elec_Info_Final_wm.hem(j),subctxfile,fsctxfile);
            else
                errordlg('Wrong electrode type found, please check the electrode file!');
            end
            
        end
        
    end
    %%%%%%%%
    
    handles.normdist = 25;
    stdtala = tmpdata.elec_Info_Final_wm;
    stdtala.electrodes_mni=cell2mat(tmpdata.elec_Info_Final_wm.norm_pos_mni');
    stdtala.electrodes_fsave=cell2mat(tmpdata.elec_Info_Final_wm.norm_pos_fsave');
    for mdind=1:2
        switch mdind
            case 1
                stdtala.electrodes=stdtala.electrodes_mni;
                [ stdtala ] = projectElectrodesDepthGridStd(std_brain_path,stdtala,handles,'mni');
                tmpdata.elec_Info_Final_wm.norm_electrodesdur_mni=(mat2cell(stdtala.electrodesdur,ones(1,size(stdtala.electrodesdur,1)),3))';
                tmpdata.elec_Info_Final_wm.norm_trielectrodes_mni=(mat2cell(stdtala.trielectrodes,ones(1,size(stdtala.trielectrodes,1)),3))';
            case 2
                stdtala.electrodes=stdtala.electrodes_fsave;
                [ stdtala ] = projectElectrodesDepthGridStd(std_brain_path,stdtala,handles,'fsave');
                tmpdata.elec_Info_Final_wm.norm_electrodesdur_fsave=(mat2cell(stdtala.electrodesdur,ones(1,size(stdtala.electrodesdur,1)),3))';
                tmpdata.elec_Info_Final_wm.norm_trielectrodes_fsave=(mat2cell(stdtala.trielectrodes,ones(1,size(stdtala.trielectrodes,1)),3))';
        end
    end
    %%%%%%%%
    Electrode_mni{1} = tmpdata.elec_Info_Final_wm.norm_pos_mni;
    Electrode_fsave{1} = tmpdata.elec_Info_Final_wm.norm_pos_fsave;
    Electrode_AnaName{1} = tmpdata.elec_Info_Final_wm.ana_label_name;
    elec_Info_Final_wm = tmpdata.elec_Info_Final_wm;
    handles.Electrodedur_mni{1} = tmpdata.elec_Info_Final_wm.norm_electrodesdur_mni;
    handles.TriElectrode_mni{1} = tmpdata.elec_Info_Final_wm.norm_trielectrodes_mni;
    handles.Electrodedur_fsave{1} = tmpdata.elec_Info_Final_wm.norm_electrodesdur_fsave;
    handles.TriElectrode_fsave{1} = tmpdata.elec_Info_Final_wm.norm_trielectrodes_fsave;
    handles.Electrode_mni = Electrode_mni;
    handles.Electrode_fsave = Electrode_fsave;
    handles.Electrode_AnaName = Electrode_AnaName;
    handles.cpm=tmpdata.elec_Info_Final_wm.cpm;
    handles.sEEGnum(1) = tmpdata.elec_Info_Final_wm.seeg_pos;
    handles.heminfo=cell(1,1);
    handles.heminfo{1}=tmpdata.elec_Info_Final_wm.hem;
    
    save([ConfigurationPath.subject_directory,'/Electrodes/electrodes_Final_Norm.mat'],'elec_Info_Final_wm');
    
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = '';
    tmptext{end+1} = 'Standard translation completed!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
elseif handles.MultiSubFlag==2
    %%%%% select the subject path %%%%%
    %     ConfigurationPath = handles.ConfigurationPath;
    %     [trans_matrix]=Read_Transform_Matrix(ConfigurationPath.subject_directory);
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = '';
    tmptext{end+1} = 'Standard model data loading...';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

    try
        [subpath,standardpath] = StandardIntergration_GUI(handles);
    catch
        return;
    end
    for sub = 1:length(subpath)
        tmpdata = load(subpath{sub});
        Electrode_mni{sub} = tmpdata.elec_Info_Final_wm.norm_pos_mni;
        Electrode_fsave{sub} = tmpdata.elec_Info_Final_wm.norm_pos_fsave;
        TriElectrode_mni{sub} = tmpdata.elec_Info_Final_wm.norm_trielectrodes_mni;
        Electrode_AnaName{sub} = tmpdata.elec_Info_Final_wm.ana_label_name;
        Electrodedur_mni{sub} = tmpdata.elec_Info_Final_wm.norm_electrodesdur_mni;
        TriElectrode_fsave{sub} = tmpdata.elec_Info_Final_wm.norm_trielectrodes_fsave;
        Electrodedur_fsave{sub} = tmpdata.elec_Info_Final_wm.norm_electrodesdur_fsave;
        hem{sub}=tmpdata.elec_Info_Final_wm.hem;
        try
            sEEGnum(sub) = tmpdata.elec_Info_Final_wm.seeg_pos;
        catch
            sEEGnum(sub) = 0;
        end
    end
    handles.Electrodedur_mni = Electrodedur_mni;
    handles.TriElectrode_mni = TriElectrode_mni;
    handles.Electrode_mni = Electrode_mni;
    handles.Electrodedur_fsave = Electrodedur_fsave;
    handles.TriElectrode_fsave = TriElectrode_fsave;
    handles.Electrode_fsave = Electrode_fsave;
    handles.Electrode_AnaName = Electrode_AnaName;
    handles.sEEGnum = sEEGnum;
    handles.cpm=tmpdata.elec_Info_Final_wm.cpm;
    handles.heminfo=hem;
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = '';
    tmptext{end+1} = 'Standard model data loading completed!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
end
%%%%%%%%%%
DisplayParameterConfiguration;


guidata(hObject,handles);
% hObject    handle to pushbutton_StandardModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Select1.
function pushbutton_Select1_Callback(hObject, eventdata, handles)
handles.ConfigurationPath.subject_directory = uigetdir(handles.ConfigurationPath.subject_directory,'Select the subject directory');
handles.ConfigurationPath.DICOM_directory = [handles.ConfigurationPath.subject_directory '/DICOM'];
addpath(genpath(handles.ConfigurationPath.subject_directory));
addpath(genpath(handles.ConfigurationPath.DICOM_directory));
set(handles.edit1,'string',handles.ConfigurationPath.subject_directory);
set(handles.edit6,'string',handles.ConfigurationPath.DICOM_directory);

% delete(handles.ProcessState);
mkdir([handles.ConfigurationPath.subject_directory '/States'])
filename = [handles.ConfigurationPath.subject_directory '/States/ProcessState_' Time2String(datetime) '.txt'];
handles.ProcessState = fopen(filename,'a');

handles.ConfigurationPath.electrodes_path = [handles.ConfigurationPath.subject_directory,'/Electrodes/electrode_raw.mat'];
handles.ConfigurationPath.surfaces_directory = [handles.ConfigurationPath.subject_directory,'/Segmentation/surf'];
handles.ConfigurationPath.volume_path = [handles.ConfigurationPath.subject_directory,'/Segmentation/mri/orig.mgz'];

handles.CalculationFlag = 0; % the calculation flag of model building
handles.CalculationFlag_Activation = 0;
handles.CalculationFlag_Activation_std = 0;

guidata(hObject,handles);


% hObject    handle to pushbutton_Select1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
handles.ConfigurationPath.subject_name = get(handles.edit5,'string');
guidata(hObject,handles);
tmp = handles.ConfigurationPath;
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Select2.
function pushbutton_Select2_Callback(hObject, eventdata, handles)
% handles.ConfigurationPath.spm_fspath = uigetdir(handles.ConfigurationPath.spm_fspath,'Select the spm directory');
% addpath(genpath(handles.ConfigurationPath.spm_fspath));
% set(handles.edit2,'string',handles.ConfigurationPath.spm_fspath);
% guidata(hObject,handles);
% hObject    handle to pushbutton_Select2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Select3.
function pushbutton_Select3_Callback(hObject, eventdata, handles)
handles.ConfigurationPath.iEEGview_directory = uigetdir(handles.ConfigurationPath.iEEGview_directory,'Select the iEEGview directory');
addpath(genpath(handles.ConfigurationPath.iEEGview_directory));
set(handles.edit3,'string',handles.ConfigurationPath.iEEGview_directory);
guidata(hObject,handles);
% hObject    handle to pushbutton_Select3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Select4.
function pushbutton_Select4_Callback(hObject, eventdata, handles)
handles.ConfigurationPath.freesurfer_directory = uigetdir(handles.ConfigurationPath.freesurfer_directory,'Select the freesurfer directory');
addpath(genpath(handles.ConfigurationPath.freesurfer_directory));
set(handles.edit4,'string',handles.ConfigurationPath.freesurfer_directory);
guidata(hObject,handles);
% hObject    handle to pushbutton_Select4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Select5.
function pushbutton_Select5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Select5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Select6.
function pushbutton_Select6_Callback(hObject, eventdata, handles)
handles.ConfigurationPath.DICOM_directory = uigetdir(handles.ConfigurationPath.DICOM_directory,'Select the DICOM directory');
addpath(genpath(handles.ConfigurationPath.DICOM_directory));
set(handles.edit6,'string',handles.ConfigurationPath.DICOM_directory);
guidata(hObject,handles);
% hObject    handle to pushbutton_Select6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu_DP_ViewSide.
function popupmenu_DP_ViewSide_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_DP_ViewSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_DP_ViewSide contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_DP_ViewSide


% --- Executes during object creation, after setting all properties.
function popupmenu_DP_ViewSide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_DP_ViewSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_DP_Brain.
function checkbox_DP_Brain_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_DP_Brain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_DP_Brain


% --- Executes on button press in checkbox_DP_Activations.
function checkbox_DP_Activations_Callback(hObject, eventdata, handles)
activationFlag = get(handles.checkbox_DP_Activations,'value');
if activationFlag
    set(handles.uipanel_ActivationParameter,'visible','on');
else
    set(handles.uipanel_ActivationParameter,'visible','off');
end
set(handles.checkbox_DP_Electrodes,'value',0);
% hObject    handle to checkbox_DP_Activations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_DP_Activations


% --- Executes on button press in checkbox_DP_Electrodes.
function checkbox_DP_Electrodes_Callback(hObject, eventdata, handles)
set(handles.checkbox_DP_Activations,'value',0);
% hObject    handle to checkbox_DP_Electrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_DP_Electrodes


% --- Executes on button press in checkbox_DP_Trielectrodes.
function checkbox_DP_Trielectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_DP_Trielectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_DP_Trielectrodes


% --- Executes on button press in pushbutton_Save.
function pushbutton_Save_Callback(hObject, eventdata, handles)
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = '';
tmptext{end+1} = 'Saving figure...';
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

try
new_f_handle=figure('visible','on'); %
% tmph = get(handles.axes_Display,'children');
% axes;
% copyobj(tmph,gca);
new_axes=copyobj(handles.axes_Display,new_f_handle);
set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);
set(gcf,'color','w');
try
    colormap(handles.cmap);
catch
end

[filename pathname fileindex]=uiputfile({'*.fig';'*.png';'*.bmp';'*.jpg';'*.eps';},'Saved as:');
% if  filename~=0
    file=strcat(pathname,filename);
    switch fileindex
        case 1
            saveas(new_f_handle,file);
            fprintf('>>Saved to: %s\n',file);
        case 2
            print(new_f_handle,'-dpng',file);% print(new_f_handle,'-dpng',filename);
            fprintf('>>Saved to: %s\n',file);
        case 3
            print(new_f_handle,'-dbmp',file);
            fprintf('>>Saved to: %s\n',file);
        case 4
            print(new_f_handle,'-djpeg',file);
            fprintf('>>Saved to: %s\n',file);
        case 5
            print(new_f_handle,'-depsc',file);
            fprintf('>>Saved to: %s\n',file);
    end
    close(new_f_handle);
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = 'Picture saving completed!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    tmptext{end+1} = [];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
catch
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = '';
    tmptext{end+1} = 'Errors happened when saving figures!';
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
end


% hObject    handle to pushbutton_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_DP_KernelType.
function popupmenu_DP_KernelType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_DP_KernelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_DP_KernelType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_DP_KernelType


% --- Executes during object creation, after setting all properties.
function popupmenu_DP_KernelType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_DP_KernelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DP_CutoffDistance_Cortical_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DP_CutoffDistance_Cortical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DP_CutoffDistance_Cortical as text
%        str2double(get(hObject,'String')) returns contents of edit_DP_CutoffDistance_Cortical as a double


% --- Executes during object creation, after setting all properties.
function edit_DP_CutoffDistance_Cortical_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DP_CutoffDistance_Cortical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DP_CutoffDistance_CP_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DP_CutoffDistance_CP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DP_CutoffDistance_CP as text
%        str2double(get(hObject,'String')) returns contents of edit_DP_CutoffDistance_CP as a double


% --- Executes during object creation, after setting all properties.
function edit_DP_CutoffDistance_CP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DP_CutoffDistance_CP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DP_MaximumDistance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DP_MaximumDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DP_MaximumDistance as text
%        str2double(get(hObject,'String')) returns contents of edit_DP_MaximumDistance as a double


% --- Executes during object creation, after setting all properties.
function edit_DP_MaximumDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DP_MaximumDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_DP_ImportActivationData.
function pushbutton_DP_ImportActivationData_Callback(hObject, eventdata, handles)
[filename,filepath,ok] = uigetfile([handles.ConfigurationPath.subject_directory, '/*.mat'],'Select the activations file');
if ~ok
    return;
end
tmp = load([filepath filename]);
handles.ActivationData = tmp.activations;
set(handles.edit_Cmax,'string',num2str(max(tmp.activations)));
guidata(hObject,handles);
% msgbox('Activations loading completed!')
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = 'Activations loading completed!';
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
DisplayOptionAll = get(handles.popupmenu_DisplayOption,'String');
DisplayOptiomValue = get(handles.popupmenu_DisplayOption,'value');
DisplayOptiomString = DisplayOptionAll{DisplayOptiomValue};
switch DisplayOptiomString
    case 'Common brain activation'       
        handles.CalculationFlag_Activation_std = 0;
    case 'Activations'
        handles.CalculationFlag_Activation = 0;
end
guidata(hObject,handles);
% hObject    handle to pushbutton_DP_ImportActivationData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_DP_ColorfulBrain.
function checkbox_DP_ColorfulBrain_Callback(hObject, eventdata, handles)
if get(handles.checkbox_DP_ColorfulBrain,'value')
    set(handles.edit_ColorfulCortexSpec,'visible','on');
    set(handles.text_AOI,'visible','on');
    DisplayOptionAll = get(handles.popupmenu_DisplayOption,'String');
    DisplayOptiomValue = get(handles.popupmenu_DisplayOption,'value');
    DisplayOptiomString = DisplayOptionAll{DisplayOptiomValue};
    switch DisplayOptiomString
        case 'Standard'
            [cpm,ok] = listdlg('ListString',{'desikan_killiany.gcs','destrieux.simple.2009-07-28.gcs','DKTatas40.gcs'},...
                'Name','Select a cortical parcellation method',...
                'OKString','OK','CancelString','Cancel',...
                'SelectionMode','single','ListSize',[180,80]);
            if ~ok
                cpm = 1;
            end
            switch cpm
                case 1
                    %                 handles.spec = 1:36;
                    set(handles.edit_ColorfulCortexSpec,'string','1:36');
                case 2
                    %                 handles.spec = 1:72;
                    set(handles.edit_ColorfulCortexSpec,'string','1:76');
                case 3
                    %                 handles.spec = 1:36;
                    set(handles.edit_ColorfulCortexSpec,'string','1:36');
            end
            handles.cpmstd = cpm;
        otherwise
    end
else
    set(handles.edit_ColorfulCortexSpec,'visible','off');
    set(handles.text_AOI,'visible','off');
end
guidata(hObject,handles);
% hObject    handle to checkbox_DP_ColorfulBrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_DP_ColorfulBrain


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton25 and none of its controls.
function pushbutton25_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_State_Callback(hObject, eventdata, handles)
% hObject    handle to edit_State (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_State as text
%        str2double(get(hObject,'String')) returns contents of edit_State as a double


% --- Executes during object creation, after setting all properties.
function edit_State_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_State (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Reset.
function pushbutton_Reset_Callback(hObject, eventdata, handles)
cla(handles.axes_Display);
colorbar('off');
% hObject    handle to pushbutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_SelectOK.
function pushbutton_SelectOK_Callback(hObject, eventdata, handles)
global SelectionResponse
if SelectionResponse.StopSelectionFlag
    SelectionResponse.Response = 1;
else
    SelectionResponse.Response = [];
end
% SelectionResponse.flag = 1; % 1 implicates the response appeared
uiresume(handles.figure1)

% hObject    handle to pushbutton_SelectOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_SelectAgain.
function pushbutton_SelectAgain_Callback(hObject, eventdata, handles)
global SelectionResponse
SelectionResponse.Response = 0;
% SelectionResponse.flag = 1;
uiresume(handles.figure1)
% hObject    handle to pushbutton_SelectAgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Plot.
function pushbutton_Plot_Callback(hObject, eventdata, handles)
if get(handles.checkbox_DP_Activations,'value')==1 && isempty(handles.ActivationData)
    errordlg('Please import activation data first!')
    return;
end
try
    tmpdata = load([handles.ConfigurationPath.subject_directory,'/Electrodes/electrodeType.mat']);
    handles.ElectrodeType = tmpdata.ElectrodeType;
    handles.ElectrodeLength = tmpdata.ElectrodeLength;
catch
    errordlg('Please configurate the electrodes first!')
    return;
end
tmp = handles.ProcessState;
set(handles.pushbutton_Plot,'BackgroundColor',[1,0,0]);
cla(handles.axes_Display);
colorbar('off');
DisplayOptionAll = get(handles.popupmenu_DisplayOption,'String');
DisplayOptiomValue = get(handles.popupmenu_DisplayOption,'value');
DisplayOptiomString = DisplayOptionAll{DisplayOptiomValue};
switch DisplayOptiomString
    case 'Electrode localization'
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = '';
        tmptext{end+1} = 'Plot electrode localization...';
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
        viewComp = {};
        BrainFlag = get(handles.checkbox_DP_Brain,'value');
        if BrainFlag
            viewComp = [viewComp,'brain'];
        end
        ActivationsFlag = get(handles.checkbox_DP_Activations,'value');
        if ActivationsFlag
            viewComp = [viewComp,'activations'];
        end
        ElectrodesFlag = get(handles.checkbox_DP_Electrodes,'value');
        if ElectrodesFlag
            viewComp = [viewComp,'electrodes'];
        end
        TrielectrodesFlag = get(handles.checkbox_DP_Trielectrodes,'value');
        if TrielectrodesFlag
            viewComp = [viewComp,'trielectrodes'];
        end
        handles.Comp = viewComp;
        
        viewall = get(handles.popupmenu_DP_ViewSide,'string');
        viewnum = get(handles.popupmenu_DP_ViewSide,'value');
        viewside = viewall{viewnum};
        
        handles.Side = viewside;
        ConfigurationPath = handles.ConfigurationPath;
        handles = plotbrainfunction_plot(ConfigurationPath.subject_name,ConfigurationPath.subject_directory,handles);
        %         handles = plotusingmatlab(ConfigurationPath.subject_directory, ConfigurationPath.subject_name, ConfigurationPath.surfaces_directory, ConfigurationPath.freesurfer_directory, ConfigurationPath.volume_path, ConfigurationPath.iEEGview_directory, ConfigurationPath.electrodes_path, handles,2);
    case 'Anatomy localization'
        try
            load([handles.ConfigurationPath.subject_directory,'/Electrodes/AnatomyMethod.mat']);
        catch
            errordlg('Please finish the anatomy model frist!');
            return;
        end
        handles.cpm = cpm;
        
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = '';
        tmptext{end+1} = 'Plot anatomy localization...';
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
        cortexcolor = get(handles.checkbox_DP_ColorfulBrain,'value');
        % 1: show the cortical regions in color, 0: no colorful cortical regions
        
        ConfigurationPath = handles.ConfigurationPath;
        electrode_path_sub=[ConfigurationPath.subject_directory,'/Electrodes/electrodes_Final_Anatomy_wm.mat'];
        load(electrode_path_sub);
        Etala=cell2mat(elec_Info_Final_wm.pos');
        handles.cpm=elec_Info_Final_wm.cpm;
        tala=elec_Info_Final_wm;
        tala.electrodes_name = tala.ana_label_name;
        viewall = get(handles.popupmenu_DP_ViewSide,'string');
        viewnum = get(handles.popupmenu_DP_ViewSide,'value');
        ViewVector = viewall{viewnum};
        
        eval(['handles.specspec = [' get(handles.edit_ColorfulCortexSpec,'string') '];']);
        % ViewVector = input('What side of the brain do you want to view? ("front"|"top"|"lateral"|"isometric"|"right"|"left"): ');
        handles = fastrun(ConfigurationPath.subject_name,1,cortexcolor,ViewVector,handles);
        hold on
        axis off
        
        plotBalloptions(tala,handles);
        
    case 'Activations'
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = '';
        tmptext{end+1} = 'Plot activations...';
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
        ConfigurationPath = handles.ConfigurationPath;
        
        load([ConfigurationPath.subject_directory,'/MATLAB/',ConfigurationPath.subject_name,'.mat']);
        
        % the projecting parameters
        KernelType(1) = get(handles.popupmenu_DP_KernelType,'value');
        KernelType(2) = str2num(get(handles.edit_DP_CutoffDistance_Cortical,'string'));
        KernelType(3) = str2num(get(handles.edit_DP_CutoffDistance_CP,'string'));
        KernelType(4) = str2num(get(handles.edit_DP_MaximumDistance,'string'));
        
        if ~all(KernelType==handles.KernelType_lasttime)
            handles.KernelType_lasttime = KernelType;
            handles.CalculationFlag_Activation = 0;
        end
        % determine whether to re-calculation                
        tmp = get(handles.checkbox_ReCalculation,'value');
        if tmp                 
            handles.CalculationFlag_Activation = 0;                   
        end    
        % view side
        viewall = get(handles.popupmenu_DP_ViewSide,'string');
        viewnum = get(handles.popupmenu_DP_ViewSide,'value');
        viewside = viewall{viewnum};
        handles.Side = viewside;
        % activations(:,1)=rand(121,1);
        
        handles = plotactivations(cortex, tala, handles.ActivationData, KernelType,ConfigurationPath.subject_name, ConfigurationPath.subject_directory, handles);
        
    case 'Common brain activation'
        switch get(handles.popupmenu_Sub,'value')
            case 1 % activations for single subject
                
                subpath{1}= [handles.ConfigurationPath.subject_directory '/Electrodes/electrodes_Final_Norm.mat'];

                for sub = 1:length(subpath)
                    tmpdata = load(subpath{sub});
                    Electrode_mni{sub} = tmpdata.elec_Info_Final_wm.norm_pos_mni;
                    Electrode_fsave{sub} = tmpdata.elec_Info_Final_wm.norm_pos_fsave;
                    TriElectrode_mni{sub} = tmpdata.elec_Info_Final_wm.norm_trielectrodes_mni;
                    Electrode_AnaName{sub} = tmpdata.elec_Info_Final_wm.ana_label_name;
                    Electrodedur_mni{sub} = tmpdata.elec_Info_Final_wm.norm_electrodesdur_mni;
                    TriElectrode_fsave{sub} = tmpdata.elec_Info_Final_wm.norm_trielectrodes_fsave;
                    Electrodedur_fsave{sub} = tmpdata.elec_Info_Final_wm.norm_electrodesdur_fsave;
                    hem{sub}=tmpdata.elec_Info_Final_wm.hem;
                    try
                        sEEGnum(sub) = tmpdata.elec_Info_Final_wm.seeg_pos;
                    catch
                        sEEGnum(sub) = 0;
                    end
                end
                handles.Electrodedur_mni = Electrodedur_mni;
                handles.TriElectrode_mni = TriElectrode_mni;
                handles.Electrode_mni = Electrode_mni;
                handles.Electrodedur_fsave = Electrodedur_fsave;
                handles.TriElectrode_fsave = TriElectrode_fsave;
                handles.Electrode_fsave = Electrode_fsave;
                handles.Electrode_AnaName = Electrode_AnaName;
                handles.sEEGnum = sEEGnum;
                handles.cpm=tmpdata.elec_Info_Final_wm.cpm;
                handles.heminfo=hem;
                tmptext = get(handles.edit_State,'string');
                tmptext{end+1} = '';
                tmptext{end+1} = 'Standard model data loading completed!';
                fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
                set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

                
                try
                    if isempty(handles.Electrode_mni) % this is not a good judgement
                        errordlg('Please load the electrode informations of all subjects!')
                        return;
                    end
                catch
                    errordlg('Please load the electrode informations of all subjects!')
                    return;
                end
                tmptext = get(handles.edit_State,'string');
                tmptext{end+1} = '';
                tmptext{end+1} = 'Plot activations of on standard brain model...';
                fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
                set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

                ConfigurationPath = handles.ConfigurationPath;

                modeltype = get(handles.popupmenu_StandardModelType,'value');
        %         modeltype = 2;
                if modeltype==1
                    StdbrainModel_path=[ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/MNI/MATLAB/WholeCortex.mat'];
                    stdmodel = load(StdbrainModel_path);
                    cortex = stdmodel.cortex;
                    clear stdmodel
                elseif modeltype==2
                    StdbrainModel_path=[ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/FSAVERAGE/MATLAB/WholeCortex.mat'];
                    stdmodel = load(StdbrainModel_path);
                    cortex = stdmodel.cortex;
                    clear stdmodel
                end
                % determine whether to re-calculation
                try
                    if modeltype~=handles.oldModelType_std
                        handles.CalculationFlag_Activation_std = 0;
                    end
                catch 
                end
                handles.oldModelType_std = modeltype;
                
                tmp = get(handles.checkbox_ReCalculation,'value');
                if tmp                    
                    handles.CalculationFlag_Activation_std = 0;                    
                end                
                
                % the projecting parameters
                KernelType(1) = get(handles.popupmenu_DP_KernelType,'value');
                KernelType(2) = str2num(get(handles.edit_DP_CutoffDistance_Cortical,'string'));
                KernelType(3) = str2num(get(handles.edit_DP_CutoffDistance_CP,'string'));
                KernelType(4) = str2num(get(handles.edit_DP_MaximumDistance,'string'));

                if ~all(KernelType==handles.KernelType_lasttime)
                    handles.KernelType_lasttime = KernelType;
                    handles.CalculationFlag_Activation_std = 0;
                end
                % view side
                viewall = get(handles.popupmenu_DP_ViewSide,'string');
                viewnum = get(handles.popupmenu_DP_ViewSide,'value');
                viewside = viewall{viewnum};
                handles.Side = viewside;
                % activations(:,1)=rand(121,1);
                %         load([ConfigurationPath.subject_directory,'/MATLAB/',ConfigurationPath.subject_name,'.mat']);
                tala = [];
                tala.electrodes = [];
                tmpele.sEEGelectrodes = [];
                tmpele.ECoGelectrodes = [];
                tmpele.hemseeg=[];
                tmpele.hemecog=[];
                switch modeltype
                    case 1
                        for sub = 1:length(handles.Electrode_mni)
                            if handles.sEEGnum(sub)~=0
                                for ele = 1:handles.sEEGnum(sub)
                                    tmpele.sEEGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                                    tmpele.hemseeg(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                            if length(handles.Electrode_mni{sub})>handles.sEEGnum(sub)
                                for ele = handles.sEEGnum(sub)+1:length(handles.Electrode_mni{sub})
                                    tmpele.ECoGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                                    tmpele.hemecog(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                        end
                    case 2
                        for sub = 1:length(handles.Electrode_fsave)
                            if handles.sEEGnum(sub)~=0
                                for ele = 1:handles.sEEGnum(sub)
                                    tmpele.sEEGelectrodes(end+1,:) = handles.Electrode_fsave{sub}{ele};
                                    tmpele.hemseeg(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                            if length(handles.Electrode_fsave{sub})>handles.sEEGnum(sub)
                                for ele = handles.sEEGnum(sub)+1:length(handles.Electrode_fsave{sub})
                                    tmpele.ECoGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                                    tmpele.hemecog(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                        end

                end
                tala.electrodes = [tmpele.sEEGelectrodes;tmpele.ECoGelectrodes];
                tala.hem=[tmpele.hemseeg;tmpele.hemecog];
                tala.seeg_pos = sum(handles.sEEGnum);
                handles.modeltype=modeltype;
                handles = plotactivations_std(cortex, tala, handles.ActivationData, KernelType,ConfigurationPath.subject_name, ConfigurationPath.subject_directory, handles);
       
            case 2 % activations for multiple subjects
                try
                    if isempty(handles.Electrode_mni) % this is not a good judgement
                        errordlg('Please load the electrode informations of all subjects!')
                        return;
                    end
                catch
                    errordlg('Please load the electrode informations of all subjects!')
                    return;
                end
                tmptext = get(handles.edit_State,'string');
                tmptext{end+1} = '';
                tmptext{end+1} = 'Plot activations of on standard brain model...';
                fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
                set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);

                ConfigurationPath = handles.ConfigurationPath;

                modeltype = get(handles.popupmenu_StandardModelType,'value');
        %         modeltype = 2;
                if modeltype==1
                    StdbrainModel_path=[ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/MNI/MATLAB/WholeCortex.mat'];
                    stdmodel = load(StdbrainModel_path);
                    cortex = stdmodel.cortex;
                    clear stdmodel
                elseif modeltype==2
                    StdbrainModel_path=[ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/FSAVERAGE/MATLAB/WholeCortex.mat'];
                    stdmodel = load(StdbrainModel_path);
                    cortex = stdmodel.cortex;
                    clear stdmodel
                end
                % determine whether to re-calculation
                try
                    if modeltype~=handles.oldModelType_std
                        handles.CalculationFlag_Activation_std = 0;
                    end
                catch 
                end
                handles.oldModelType_std = modeltype;
                
                tmp = get(handles.checkbox_ReCalculation,'value');
                if tmp                    
                    handles.CalculationFlag_Activation_std = 0;                    
                end    

                KernelType(1) = get(handles.popupmenu_DP_KernelType,'value');
                KernelType(2) = str2num(get(handles.edit_DP_CutoffDistance_Cortical,'string'));
                KernelType(3) = str2num(get(handles.edit_DP_CutoffDistance_CP,'string'));
                KernelType(4) = str2num(get(handles.edit_DP_MaximumDistance,'string'));

                if ~all(KernelType==handles.KernelType_lasttime)
                    handles.KernelType_lasttime = KernelType;
                    handles.CalculationFlag_Activation_std = 0;
                end
                % view side
                viewall = get(handles.popupmenu_DP_ViewSide,'string');
                viewnum = get(handles.popupmenu_DP_ViewSide,'value');
                viewside = viewall{viewnum};
                handles.Side = viewside;
               
                tala = [];
                tala.electrodes = [];
                tmpele.sEEGelectrodes = [];
                tmpele.ECoGelectrodes = [];
                tmpele.hemseeg=[];
                tmpele.hemecog=[];
                switch modeltype
                    case 1
                        for sub = 1:length(handles.Electrode_mni)
                            if handles.sEEGnum(sub)~=0
                                for ele = 1:handles.sEEGnum(sub)
                                    tmpele.sEEGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                                    tmpele.hemseeg(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                            if length(handles.Electrode_mni{sub})>handles.sEEGnum(sub)
                                for ele = handles.sEEGnum(sub)+1:length(handles.Electrode_mni{sub})
                                    tmpele.ECoGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                                    tmpele.hemecog(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                        end
                    case 2
                        for sub = 1:length(handles.Electrode_fsave)
                            if handles.sEEGnum(sub)~=0
                                for ele = 1:handles.sEEGnum(sub)
                                    tmpele.sEEGelectrodes(end+1,:) = handles.Electrode_fsave{sub}{ele};
                                    tmpele.hemseeg(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                            if length(handles.Electrode_fsave{sub})>handles.sEEGnum(sub)
                                for ele = handles.sEEGnum(sub)+1:length(handles.Electrode_fsave{sub})
                                    tmpele.ECoGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                                    tmpele.hemecog(end+1,1)=handles.heminfo{sub}(ele);
                                end
                            end
                        end

                end
                tala.electrodes = [tmpele.sEEGelectrodes;tmpele.ECoGelectrodes];
                tala.hem=[tmpele.hemseeg;tmpele.hemecog];
                tala.seeg_pos = sum(handles.sEEGnum);
                handles.modeltype=modeltype;
                handles = plotactivations_std(cortex, tala, handles.ActivationData, KernelType,ConfigurationPath.subject_name, ConfigurationPath.subject_directory, handles);
        end                
    case 'Standard'
        
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = '';
        tmptext{end+1} = 'Plot electrodes in standard model...';
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
        ConfigurationPath = handles.ConfigurationPath;
        modeltype = get(handles.popupmenu_StandardModelType,'value');
%       modeltype = 2;
        if modeltype==1
            StdbrainModel_path=[ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/MNI/MATLAB/WholeCortex.mat'];
            stdmodel = load(StdbrainModel_path);
            Cortex = stdmodel.cortex;
            clear stdmodel
        elseif modeltype==2
            StdbrainModel_path=[ConfigurationPath.iEEGview_directory,'/iEEGview/StdbrainModel/FSAVERAGE/MATLAB/WholeCortex.mat'];
            stdmodel = load(StdbrainModel_path);
            Cortex = stdmodel.cortex;
            clear stdmodel
        end
        valueflag=get(handles.popupmenu_Sub,'value');
        if valueflag==1 && exist(fullfile(ConfigurationPath.subject_directory,'Electrodes','electrodes_Final_Norm.mat'),'file')
            tempfile=load(fullfile(ConfigurationPath.subject_directory,'Electrodes','electrodes_Final_Norm.mat'));
            handles.Electrode_mni{1}=tempfile.elec_Info_Final_wm.norm_pos_mni;
            handles.Electrode_fsave{1}=tempfile.elec_Info_Final_wm.norm_pos_fsave;
            handles.Electrode_AnaName{1}=tempfile.elec_Info_Final_wm.ana_label_name;
            handles.sEEGnum(1)=tempfile.elec_Info_Final_wm.seeg_pos;
            handles.TriElectrode_mni{1}=tempfile.elec_Info_Final_wm.norm_trielectrodes_mni;
            handles.Electrodedur_mni{1}=tempfile.elec_Info_Final_wm.norm_electrodesdur_mni;
            handles.TriElectrode_fsave{1}=tempfile.elec_Info_Final_wm.norm_trielectrodes_fsave;
            handles.Electrodedur_fsave{1}=tempfile.elec_Info_Final_wm.norm_electrodesdur_fsave;
            handles.cpm=tempfile.elec_Info_Final_wm.cpm;
            handles.heminfo=cell(1,1);
            handles.heminfo{1}=tempfile.elec_Info_Final_wm.hem;
            Electrode_mni = handles.Electrode_mni;
            Electrode_AnaName = handles.Electrode_AnaName;
            
            Etala.electrodes=cell2mat(Electrode_mni{1}');
        elseif valueflag==2
            Electrode = handles.Electrode_mni;
            Etala.electrodes=[];
            for j=1:length(Electrode)
                Etala.electrodes=[Etala.electrodes;cell2mat(Electrode{j}')];
            end
            Electrode_AnaName = handles.Electrode_AnaName;
        end
        viewall = get(handles.popupmenu_DP_ViewSide,'string');
        viewnum = get(handles.popupmenu_DP_ViewSide,'value');
        ViewVector = viewall{viewnum};
        
        tmp = str2double(get(handles.edit_Alpha,'string'));
        handles.modeltype=modeltype;
        handles = viewBrain(Cortex, Etala, {'brain'}, tmp, 50, ViewVector, handles);
        hold on
        axis off
        cut=0;
        ballRadius = str2double(get(handles.edit_BallRadius,'string'));
        ballColor = str2num(get(handles.edit_BallColor,'string'));
        
        tala = [];
        tala.electrodes = [];
        tala.trielectrodes = [];
        tmpele.sEEGelectrodes = [];
        tmpele.sEEGtrielectrodes = [];
        tmpele.sEEGelectrodes_name=[];
        tmpele.sEEGelectrodesdur=[];
        tmpele.ECoGelectrodes = [];
        tmpele.ECoGtrielectrodes = [];
        tmpele.ECoGelectrodes_name=[];
        tmpele.ECoGelectrodesdur=[];
        switch modeltype
            case 1
                for sub = 1:length(handles.Electrode_mni)
                    if handles.sEEGnum(sub)~=0
                        for ele = 1:handles.sEEGnum(sub)
                            tmpele.sEEGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                            tmpele.sEEGtrielectrodes(end+1,:) = handles.TriElectrode_mni{sub}{ele};
                            tmpele.sEEGelectrodesdur(end+1,:) = handles.Electrodedur_mni{sub}{ele};
                            tmpele.sEEGelectrodes_name{end+1}=handles.Electrode_AnaName{sub}{ele};
                        end
                    end
                    if length(handles.Electrode_mni{sub})>handles.sEEGnum(sub)
                        for ele = handles.sEEGnum(sub)+1:length(handles.Electrode_mni{sub})
                            tmpele.ECoGelectrodes(end+1,:) = handles.Electrode_mni{sub}{ele};
                            tmpele.ECoGtrielectrodes(end+1,:) = handles.TriElectrode_mni{sub}{ele};
                            tmpele.ECoGelectrodesdur(end+1,:) = handles.Electrodedur_mni{sub}{ele};
                            tmpele.ECoGelectrodes_name{end+1}=handles.Electrode_AnaName{sub}{ele};
                        end
                    end
                end
            case 2
                
                for sub = 1:length(handles.Electrode_fsave)
                    if handles.sEEGnum(sub)~=0
                        for ele = 1:handles.sEEGnum(sub)
                            tmpele.sEEGelectrodes(end+1,:) = handles.Electrode_fsave{sub}{ele};
                            tmpele.sEEGtrielectrodes(end+1,:) = handles.TriElectrode_fsave{sub}{ele};
                            tmpele.sEEGelectrodesdur(end+1,:) = handles.Electrodedur_fsave{sub}{ele};
                            tmpele.sEEGelectrodes_name{end+1}=handles.Electrode_AnaName{sub}{ele};
                        end
                    end
                    if length(handles.Electrode_fsave{sub})>handles.sEEGnum(sub)
                        for ele = handles.sEEGnum(sub)+1:length(handles.Electrode_fsave{sub})
                            tmpele.ECoGelectrodes(end+1,:) = handles.Electrode_fsave{sub}{ele};
                            tmpele.ECoGtrielectrodes(end+1,:) = handles.TriElectrode_fsave{sub}{ele};
                            tmpele.ECoGelectrodesdur(end+1,:) = handles.Electrodedur_fsave{sub}{ele};
                            tmpele.ECoGelectrodes_name{end+1}=handles.Electrode_AnaName{sub}{ele};
                        end
                    end
                end
        end
        tala.electrodes = [tmpele.sEEGelectrodes;tmpele.ECoGelectrodes];
        tala.trielectrodes = [tmpele.sEEGtrielectrodes;tmpele.ECoGtrielectrodes];
        tala.electrodesdur = [tmpele.sEEGelectrodesdur;tmpele.ECoGelectrodesdur];
        tala.electrodes_name = [tmpele.sEEGelectrodes_name';tmpele.ECoGelectrodes_name'];
        tala.seeg_pos = sum(handles.sEEGnum);
        
        plotBalloptions(tala,handles);
        
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = '';
        tmptext{end+1} = 'Standard model displaying completed!';
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
        
    case 'Electrode selection'
        errordlg('Please select other opitons to plot!')
end
colorbar off;
set(handles.uipanel_View,'visible','on');
guidata(hObject,handles);
set(handles.pushbutton_Plot,'BackgroundColor',[0.94,0.94,0.94]);

% hObject    handle to pushbutton_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_DisplayOption.
function popupmenu_DisplayOption_Callback(hObject, eventdata, handles)
DisplayParameterConfiguration;
handles.ActivationData = [];
guidata(hObject,handles);
% if get(handles.popupmenu_DisplayOption,'value')>1
%     set(handles.uipanel_DisplayParameter,'visible','on');
%     if get(handles.popupmenu_DisplayOption,'value')~=3
%         set(handles.checkbox_DP_ColorfulBrain,'enable','off');
%         set(handles.checkbox_DP_Electrodes,'enable','on');
%         set(handles.checkbox_DP_Trielectrodes,'enable','on');
%         set(handles.checkbox_DP_Activations,'enable','on');
%         set(handles.checkbox_DP_Brain,'enable','on');
%     else
%         set(handles.checkbox_DP_ColorfulBrain,'enable','on');
%         set(handles.checkbox_DP_Electrodes,'enable','off');
%         set(handles.checkbox_DP_Trielectrodes,'enable','off');
%         set(handles.checkbox_DP_Activations,'enable','off');
%         set(handles.checkbox_DP_Brain,'enable','off');
%     end
% else
%     set(handles.uipanel_DisplayParameter,'visible','off');
% end
% hObject    handle to popupmenu_DisplayOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_DisplayOption contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_DisplayOption


% --- Executes during object creation, after setting all properties.
function popupmenu_DisplayOption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_DisplayOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbutton_Plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton_StandardModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_StandardModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
fclose(handles.ProcessState);
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_ElectrodeType.
function popupmenu_ElectrodeType_Callback(hObject, eventdata, handles)
handles.ElectrodeIndex = get(handles.popupmenu_ElectrodeType,'value');
set(handles.popupmenu_ElectrodesView,'value',handles.ElectrodeIndex);
guidata(hObject,handles);
% hObject    handle to popupmenu_ElectrodeType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ElectrodeType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ElectrodeType


% --- Executes during object creation, after setting all properties.
function popupmenu_ElectrodeType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ElectrodeType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_SelectStop.
function pushbutton_SelectStop_Callback(hObject, eventdata, handles)
global SelectionResponse
SelectionResponse.Response = 1;
% SelectionResponse.flag = 1; % 1 implicates the response appeared
uiresume(handles.figure1)
% hObject    handle to pushbutton_SelectStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_3DShow.
function pushbutton_3DShow_Callback(hObject, eventdata, handles)
set(handles.checkbox_DP_ColorfulBrain,'value',0);
ShowingIn3D_GUI(handles);


% hObject    handle to pushbutton_3DShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton_3DShow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_3DShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_LightPosition_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LightPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LightPosition as text
%        str2double(get(hObject,'String')) returns contents of edit_LightPosition as a double


% --- Executes during object creation, after setting all properties.
function edit_LightPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LightPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ViewVector_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ViewVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ViewVector as text
%        str2double(get(hObject,'String')) returns contents of edit_ViewVector as a double


% --- Executes during object creation, after setting all properties.
function edit_ViewVector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ViewVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_View.
function pushbutton_View_Callback(hObject, eventdata, handles)
axes(handles.axes_Display);
viewstruct.lightpos = str2num(get(handles.edit_LightPosition,'string'));
viewstruct.viewvect = str2num(get(handles.edit_ViewVector,'string'));
delete(handles.light);
view(viewstruct.viewvect);
handles.light = light('Position', viewstruct.lightpos, 'Style', 'infinite');
guidata(hObject,handles);
% % hObject    handle to pushbutton_View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_SelectOK.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SelectOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_SelectAgain.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SelectAgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_SelectStop.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SelectStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Rotate.
function pushbutton_Rotate_Callback(hObject, eventdata, handles)
axes(handles.axes_Display);
if get(handles.pushbutton_Rotate,'backgroundcolor') == [1,1,1]
    rotate3d on;
    set(handles.pushbutton_Rotate,'backgroundcolor',[0,1,0]);
else
    set(handles.pushbutton_Rotate,'backgroundcolor',[1,1,1]);
    rotate3d off;
end
% hObject    handle to pushbutton_Rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_ReCalculation.
function checkbox_ReCalculation_Callback(hObject, eventdata, handles)
% tmp = get(handles.checkbox_ReCalculation,'value');
% if tmp
%     handles.CalculationFlag = 0;
%     handles.CalculationFlag_Activation = 0;
%     handles.CalculationFlag_Activation_std = 0;
% end
% guidata(hObject,handles);
% hObject    handle to checkbox_ReCalculation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ReCalculation


% --- Executes on selection change in popupmenu_Sub.
function popupmenu_Sub_Callback(hObject, eventdata, handles)
% if get(handles.popupmenu_Sub,'value')==2
%     set(handles.pushbutton_MultiActivation,'visible','on');
% else
%     set(handles.pushbutton_MultiActivation,'visible','off');
% end
% hObject    handle to popupmenu_Sub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Sub contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Sub


% --- Executes during object creation, after setting all properties.
function popupmenu_Sub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Sub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_StandardModelType.
function popupmenu_StandardModelType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_StandardModelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_StandardModelType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_StandardModelType


% --- Executes during object creation, after setting all properties.
function popupmenu_StandardModelType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_StandardModelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_MultiActivation.
function pushbutton_MultiActivation_Callback(hObject, eventdata, handles)
handles.ActivationData = [];
handles.CalculationFlag_Activation = 0;
set(handles.popupmenu_DisplayOption,'value',6);
DisplayParameterConfiguration;
guidata(hObject,handles);
% hObject    handle to pushbutton_MultiActivation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_ElectrodeConfiguration.
function pushbutton_ElectrodeConfiguration_Callback(hObject, eventdata, handles)
% Electrodes saving folder
ConfigurationPath = handles.ConfigurationPath;
handles.ConfigurationPath.electrodes_path = [ConfigurationPath.subject_directory,'/Electrodes/electrode_raw.mat'];
handles.ConfigurationPath.surfaces_directory = [ConfigurationPath.subject_directory,'/Segmentation/surf'];
handles.ConfigurationPath.volume_path = [ConfigurationPath.subject_directory,'/Segmentation/mri/orig.mgz'];
try
    load(handles.ConfigurationPath.electrodes_path);
catch
    errordlg('No electrode files are found in the subject directory! Please select the elctrode first.');
    return;
end

set(handles.pushbutton_ElectrodeConfiguration,'backgroundcolor',[1,0,0]);

switch handles.ElectrodeIndex
    case 1
        elec_Info.name=unique(elecInfo.name,'stable');
    case 2
    case 3
        elec_Info.name=unique(elecInfo.name(1:elecInfo.seeg_points),'stable');
end

if handles.ElectrodeIndex==1 || handles.ElectrodeIndex==3
   tmpmsg = ['Please input the electrode number of each pin (eg,16,10,10..., the numbers should be in the same order with the sequence of pin names). '...
        'The sequence of pins is ( ' elec_Info.name{:} ' )'];
    tmpanswer = inputdlg(tmpmsg,'Electrode number');
    eval(['elec_Info.number = {' tmpanswer{1} '};']);
    [ElectrodeType,ElectrodeLength] = SelectElectrodeType_GUI(elec_Info.name);
    handles.ElectrodeType = ElectrodeType;
    handles.ElectrodeLength = ElectrodeLength;
    save([handles.ConfigurationPath.subject_directory,'/Electrodes/electrode_raw.mat'],'elecMatrix','elecInfo','elec_Info');
    save([handles.ConfigurationPath.subject_directory,'/Electrodes/electrodeType.mat'],'ElectrodeType','ElectrodeLength');
else
    ElectrodeType = 0;
    ElectrodeLength = 0;
    save([handles.ConfigurationPath.subject_directory,'/Electrodes/electrodeType.mat'],'ElectrodeType','ElectrodeLength');
    save([handles.ConfigurationPath.subject_directory,'/Electrodes/electrode_raw.mat'],'elecMatrix','elecInfo');
end



tmptext = get(handles.edit_State,'string');
tmptext{end+1} = '';
tmptext{end+1} = 'Electrode localization...';
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
handles = plotusingmatlab(ConfigurationPath.subject_directory, ConfigurationPath.subject_name, ConfigurationPath.surfaces_directory, ConfigurationPath.freesurfer_directory, ConfigurationPath.volume_path, ConfigurationPath.iEEGview_directory, ConfigurationPath.electrodes_path, handles,1);

guidata(hObject,handles);
set(handles.popupmenu_DisplayOption,'value',2);
DisplayParameterConfiguration;
cla(handles.axes_Display);

set(handles.pushbutton_ElectrodeConfiguration,'backgroundcolor',[0.94,0.94,0.94]);

tmptext = get(handles.edit_State,'string');
tmptext{end+1} = '';
tmptext{end+1} = 'Localization completed!';
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);



% hObject    handle to pushbutton_ElectrodeConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton_ModelBuild_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_ModelBuild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_ColorfulCortexSpec_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ColorfulCortexSpec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ColorfulCortexSpec as text
%        str2double(get(hObject,'String')) returns contents of edit_ColorfulCortexSpec as a double


% --- Executes during object creation, after setting all properties.
function edit_ColorfulCortexSpec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ColorfulCortexSpec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbutton_ElectrodeConfiguration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_ElectrodeConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_Alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_Alpha as a double


% --- Executes during object creation, after setting all properties.
function edit_Alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Cmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Cmin as text
%        str2double(get(hObject,'String')) returns contents of edit_Cmin as a double


% --- Executes during object creation, after setting all properties.
function edit_Cmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Cmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Cmax as text
%        str2double(get(hObject,'String')) returns contents of edit_Cmax as a double


% --- Executes during object creation, after setting all properties.
function edit_Cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BallRadius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BallRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BallRadius as text
%        str2double(get(hObject,'String')) returns contents of edit_BallRadius as a double


% --- Executes during object creation, after setting all properties.
function edit_BallRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BallRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BallColor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BallColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BallColor as text
%        str2double(get(hObject,'String')) returns contents of edit_BallColor as a double


% --- Executes during object creation, after setting all properties.
function edit_BallColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BallColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ElectrodesView.
function popupmenu_ElectrodesView_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ElectrodesView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ElectrodesView contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ElectrodesView


% --- Executes during object creation, after setting all properties.
function popupmenu_ElectrodesView_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ElectrodesView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_ColorAnalysis.
function checkbox_ColorAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ColorAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ColorAnalysis



function edit_BallColor_Trielectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BallColor_Trielectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BallColor_Trielectrodes as text
%        str2double(get(hObject,'String')) returns contents of edit_BallColor_Trielectrodes as a double


% --- Executes during object creation, after setting all properties.
function edit_BallColor_Trielectrodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BallColor_Trielectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_ColorAnalysis_Trielectrodes.
function checkbox_ColorAnalysis_Trielectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ColorAnalysis_Trielectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ColorAnalysis_Trielectrodes



function edit_BallRadius_Trielectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BallRadius_Trielectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BallRadius_Trielectrodes as text
%        str2double(get(hObject,'String')) returns contents of edit_BallRadius_Trielectrodes as a double


% --- Executes during object creation, after setting all properties.
function edit_BallRadius_Trielectrodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BallRadius_Trielectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
