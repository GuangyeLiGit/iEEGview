function varargout = ShowingIn3D_GUI(varargin)
% SHOWINGIN3D_GUI MATLAB code for ShowingIn3D_GUI.fig
%      SHOWINGIN3D_GUI, by itself, creates a new SHOWINGIN3D_GUI or raises the existing
%      singleton*.
%
%      H = SHOWINGIN3D_GUI returns the handle to a new SHOWINGIN3D_GUI or the handle to
%      the existing singleton*.
%
%      SHOWINGIN3D_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOWINGIN3D_GUI.M with the given input arguments.
%
%      SHOWINGIN3D_GUI('Property','Value',...) creates a new SHOWINGIN3D_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ShowingIn3D_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ShowingIn3D_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ShowingIn3D_GUI

% Last Modified by GUIDE v2.5 19-Jun-2019 09:19:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ShowingIn3D_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ShowingIn3D_GUI_OutputFcn, ...
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


% --- Executes just before ShowingIn3D_GUI is made visible.
function ShowingIn3D_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ShowingIn3D_GUI (see VARARGIN)

% Choose default command line output for ShowingIn3D_GUI
handles.mainGUIhandles = varargin{1};

% axes(handles.axes_Coordinate);
% axis off;

Data1 = load([handles.mainGUIhandles.ConfigurationPath.subject_directory,'/Electrodes/electrodes_Final_Anatomy_wm.mat']);
Data2 = load([handles.mainGUIhandles.ConfigurationPath.subject_directory,'/Electrodes/VolWM.mat']);
Data3 = load([handles.mainGUIhandles.ConfigurationPath.subject_directory,'/MATLAB/WholeCortex.mat']);

% VOL=MRIread([SubFolder,'/orig.mgh']);% read volume for windows
VOL=MRIread([handles.mainGUIhandles.ConfigurationPath.subject_directory,'/Segmentation/mri/orig.mgz']);% read volume for MAC


handles.Img = VOL.vol;
% from the first file
handles.elec = Data1.elec_Info_Final_wm.ana_pos_accu;
handles.elec_name = Data1.elec_Info_Final_wm.name;
handles.disprange = [];
handles.elec_Info_Final_wm= Data1.elec_Info_Final_wm;
handles.AsegWM = Data1.AsegWM;

% from the second file
handles.VOLWM = Data2.VOLWM;
% from the thrid file
handles.cortex = Data3.cortex;

handles.sno = size(handles.Img);  % image size
handles.sno_a = handles.sno(2);  % number of axial slices
handles.S_a = round(handles.sno_a/2);
handles.sno_s = handles.sno(3);  % number of sagittal slices
handles.S_s = round(handles.sno_s/2);
handles.sno_c = handles.sno(1);  % number of coronal slices
handles.S_c = round(handles.sno_c/2);
handles.S = handles.S_a;
handles.elecpos=cell2mat(handles.elec');

set(handles.slider_Sagittal,'Min',1,'Max',handles.sno_s,'Value',handles.S_s,'SliderStep',[1/(handles.sno_s-1) 10/(handles.sno_s-1)]);
set(handles.text_Sagittal,'String',['Slice: ' num2str(handles.S_s) '/' num2str(handles.sno_s)])
set(handles.slider_Axial,'Min',1,'Max',handles.sno_a,'Value',handles.S_a,'SliderStep',[1/(handles.sno_a-1) 10/(handles.sno_a-1)]);
set(handles.text_Axial,'String',['Slice: ' num2str(handles.S_a) '/' num2str(handles.sno_a)])
set(handles.slider_Coronal,'Min',1,'Max',handles.sno_c,'Value',handles.S_c,'SliderStep',[1/(handles.sno_c-1) 10/(handles.sno_c-1)]);
set(handles.text_Coronal,'String',['Slice: ' num2str(handles.S_c) '/' num2str(handles.sno_c)])

set(handles.slider_WS,'Min',1,'Max',255,'Value',255,'SliderStep',[1/(255-1) 10/(255-1)]);
set(handles.slider_WA,'Min',1,'Max',255,'Value',255,'SliderStep',[1/(255-1) 10/(255-1)]);
set(handles.slider_WC,'Min',1,'Max',255,'Value',255,'SliderStep',[1/(255-1) 10/(255-1)]);
set(handles.slider_LS,'Min',1,'Max',255,'Value',128,'SliderStep',[1/(255-1) 10/(255-1)]);
set(handles.slider_LA,'Min',1,'Max',255,'Value',128,'SliderStep',[1/(255-1) 10/(255-1)]);
set(handles.slider_LC,'Min',1,'Max',255,'Value',128,'SliderStep',[1/(255-1) 10/(255-1)]);

set(gcf,'menubar','figure');

MinV = 0;
MaxV = max(handles.Img(:));
handles.LevV = (double( MaxV) + double(MinV)) / 2;
handles.Win = double(MaxV) - double(MinV);
handles.WLAdjCoe = (handles.Win + 1)/1024;
handles.FineTuneC = [1 1/16];    % Regular/Fine-tune mode coefficients

if isa(handles.Img,'uint8')
    MaxV = uint8(Inf);
    MinV = uint8(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'uint16')
    MaxV = uint16(Inf);
    MinV = uint16(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'uint32')
    MaxV = uint32(Inf);
    MinV = uint32(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'uint64')
    MaxV = uint64(Inf);
    MinV = uint64(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'int8')
    MaxV = int8(Inf);
    MinV = int8(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'int16')
    MaxV = int16(Inf);
    MinV = int16(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'int32')
    MaxV = int32(Inf);
    MinV = int32(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'int64')
    MaxV = int64(Inf);
    MinV = int64(-Inf);
    handles.LevV = (double( MaxV) + double(MinV)) / 2;
    handles.Win = double(MaxV) - double(MinV);
    handles.WLAdjCoe = (handles.Win + 1)/1024;
elseif isa(handles.Img,'logical')
    MaxV = 0;
    MinV = 1;
    handles.LevV =0.5;
    handles.Win = 1;
    handles.WLAdjCoe = 0.1;
end
% ImgAx=Img;
if verLessThan('matlab', '8')
    handles.ImgSg = flipdim(permute(handles.Img, [3 1 2 4]),1);   % Sagittal view image
    handles.ImgCr = flipdim(permute(handles.Img, [3 2 1 4]),1);   % Coronal view image
else
     %%%%%%%% Guangye Li %%%%%rotate the sagittal view%%%%%%%%%
      handles.ImgAx = permute(handles.Img,[2 3 1 4]);
      T=affine2d([0 1 0;1 0 0;0 0 1]);%构造空间变换结构T.这里为转置变换矩阵
      handles.ImgAx=imwarp(handles.ImgAx,T);
      handles.ImgAx=flip(handles.ImgAx,1);
      handles.ImgSg = permute(handles.Img, [1 3 2 4]);   % Sagittal view image
      handles.ImgCr = permute(handles.Img, [1 2 3 4]);   % Coronal view image
    %%%%%%%%%%%%%%%end of GYL%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     ImgCr = flip(permute(Img, [3 2 1 4]),1);   % Coronal view image
end

% if (nargin < 2)
%     [Rmin Rmax] = WL2R(handles.Win, handles.LevV);
% elseif
if numel(handles.disprange) == 0
    [handles.Rmin handles.Rmax] = WL2R(handles.Win, handles.LevV);
else
    handles.LevV = (double(handles.disprange(2)) + double(handles.disprange(1))) / 2;
    handles.Win = double(handles.disprange(2)) - double(handles.disprange(1));
    handles.WLAdjCoe = (handles.Win + 1)/1024;
    [handles.Rmin handles.Rmax] = WL2R(handles.Win, handles.LevV);
end

elec_num=length(handles.elec_Info_Final_wm.pos);
handles.fontsizeval=12;
handles.fontmarkerval=6;
%% sagittal
% sagittal_MRI plot
axes(handles.axes_Sagittal_MRI);
imshow(squeeze(handles.ImgSg(:,:,handles.S_s,:)), [handles.Rmin handles.Rmax])
[X_Data,Y_Data,ename]=locateelec('S',handles.elecpos,handles.S_s,handles.elec_name);
if ~isempty(X_Data)
    hold on
    plot(X_Data,Y_Data,'ro','markersize',handles.fontmarkerval,'markerfacecolor','r','markeredgecolor','r');
    hold on
    if get(handles.checkbox_ElectrodeName,'value')         
        text(X_Data+3,Y_Data+3,ename,'color','y','fontsize',handles.fontsizeval);     
    end
end
% sagittal_Atlas plot
S = handles.S_s;
axes(handles.axes_Sagittal_Atlas);
imagesc(squeeze(handles.VOLWM.vol(:,S,:)));
axis off;
box off;
colormap(handles.AsegWM.color);
hold on;
tmpelectrodename = {};
for j=1:elec_num
    if S==handles.elec_Info_Final_wm.ano_pos{1,j}(2)
        plot(handles.elec_Info_Final_wm.ano_pos{1,j}(3),handles.elec_Info_Final_wm.ano_pos{1,j}(1),'wo','markersize',handles.fontmarkerval,'markerfacecolor','r');
        if get(handles.checkbox_ElectrodeName,'value')
            text(handles.elec_Info_Final_wm.ano_pos{1,j}(3)+3,handles.elec_Info_Final_wm.ano_pos{1,j}(1)-3,...
                strcat(handles.elec_Info_Final_wm.name{j}()),'Fontsize',handles.fontsizeval,'Fontweight','bold','color','w');
        end
        tmpelectrodename{end+1} = strcat(handles.elec_Info_Final_wm.name{j}(),'/',handles.elec_Info_Final_wm.ana_label_name{j}());
    end
end
hold off;
handles.Electrode_Sview = tmpelectrodename;
%% axial
% axial_MRI plot
axes(handles.axes_Axial_MRI);
imshow(squeeze(handles.ImgAx(:,:,handles.S_a,:)), [handles.Rmin handles.Rmax])
[X_Data,Y_Data,ename]=locateelec('A',handles.elecpos,handles.S_a,handles.elec_name);
if ~isempty(X_Data)
    hold on
    plot(X_Data,Y_Data,'ro','markersize',handles.fontmarkerval,'markerfacecolor','r','markeredgecolor','r');
    hold on
    if get(handles.checkbox_ElectrodeName,'value')         
        text(X_Data+3,Y_Data+3,ename,'color','y','fontsize',handles.fontsizeval);   
    end
end
% axial_Atlas plot
S = handles.S_a;
axes(handles.axes_Axial_Atlas);
ImgA = squeeze(handles.VOLWM.vol(S,:,:))';
tform=maketform('affine',[1 0 0;0 -1 0;0 0 1]);
ImgA=imtransform(ImgA,tform,'nearest');
imagesc(ImgA);
axis off;
box off;
colormap(handles.AsegWM.color);
hold on;
tmpelectrodename = {};
for j=1:elec_num
    if S==handles.elec_Info_Final_wm.ano_pos{1,j}(1)
        plot(handles.elec_Info_Final_wm.ano_pos{1,j}(2),size(ImgA,2)-handles.elec_Info_Final_wm.ano_pos{1,j}(3),'wo','markersize',handles.fontmarkerval,'markerfacecolor','r');
        if get(handles.checkbox_ElectrodeName,'value')
            text(handles.elec_Info_Final_wm.ano_pos{1,j}(2)+3,size(ImgA,2)-handles.elec_Info_Final_wm.ano_pos{1,j}(3)-3,...
                strcat(handles.elec_Info_Final_wm.name{j}()),'Fontsize',handles.fontsizeval,'Fontweight','bold','color','w');
        end
        tmpelectrodename{end+1} = strcat(handles.elec_Info_Final_wm.name{j}(),'/',handles.elec_Info_Final_wm.ana_label_name{j}());
    end
end
hold off;
handles.Electrode_Aview = tmpelectrodename;
%% coronal
% coronal_MRI plot
axes(handles.axes_Coronal_MRI);
imshow(squeeze(handles.ImgCr(:,:,handles.S_c,:)), [handles.Rmin handles.Rmax])
[X_Data,Y_Data,ename]=locateelec('C',handles.elecpos,handles.S_c,handles.elec_name);
if ~isempty(X_Data)
    hold on
    plot(X_Data,Y_Data,'ro','markersize',handles.fontmarkerval,'markerfacecolor','r','markeredgecolor','r');
    hold on
    if get(handles.checkbox_ElectrodeName,'value')         
        text(X_Data+3,Y_Data+3,ename,'color','y','fontsize',handles.fontsizeval);   
    end
end
% coronal_Atlas plot
S = handles.S_c;
axes(handles.axes_Coronal_Atlas);
imagesc(squeeze(handles.VOLWM.vol(:,:,S)));
axis off;
box off;
colormap(handles.AsegWM.color);
hold on;
tmpelectrodename = {};
for j=1:elec_num
    if S==handles.elec_Info_Final_wm.ano_pos{1,j}(3)
        plot(handles.elec_Info_Final_wm.ano_pos{1,j}(2),handles.elec_Info_Final_wm.ano_pos{1,j}(1),'wo','markersize',handles.fontmarkerval,'markerfacecolor','r');
        if get(handles.checkbox_ElectrodeName,'value')
            text(handles.elec_Info_Final_wm.ano_pos{1,j}(2)+3,handles.elec_Info_Final_wm.ano_pos{1,j}(1)-3,...
                strcat(handles.elec_Info_Final_wm.name{j}()),'Fontsize',handles.fontsizeval,'Fontweight','bold','color','w');
        end
        tmpelectrodename{end+1} = strcat(handles.elec_Info_Final_wm.name{j}(),'/',handles.elec_Info_Final_wm.ana_label_name{j}());
    end
end
hold off;
handles.Electrode_Cview = tmpelectrodename;

%%%%% plot the 3D coordinate in the brain %%%%%
axes(handles.axes_Coordinate);
tmphandles.axes_Display = handles.axes_Coordinate;
tmphandles.ConfigurationPath = handles.mainGUIhandles.ConfigurationPath;
tmphandles.checkbox_DP_ColorfulBrain = handles.mainGUIhandles.checkbox_DP_ColorfulBrain;
% tmphandles = handles.mainGUIhandles;
tmphandles.cpmstd = 1;
tmphandles.modeltype = get(handles.mainGUIhandles.popupmenu_StandardModelType,'value');
Etala.electrodes=cell2mat(handles.elec_Info_Final_wm.pos');

viewall = get(handles.popupmenu_ViewSide,'string');
viewnum = get(handles.popupmenu_ViewSide,'value');
view_vect = viewall{viewnum};
viewBrain(handles.cortex, Etala, {'brain','electrodes'}, 0.1, 50, view_vect,tmphandles);
axis off;
colorbar off
hold on
%% Get the current value of A R S value from the MRI file
handles.Mat=VOL.tkrvox2ras;
Ss=handles.S_s;
As=handles.S_a;
Cs=handles.S_c;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Coordi=handles.Mat*[Ss,As,Cs,1]';
Coordi=Coordi(1:3);
handles.coordinate1 = plot3(Coordi(1),Coordi(2),Coordi(3),'r+','markersize',50);
hold on
handles.coordinate2 = plot3(Coordi(1),Coordi(2),Coordi(3),'r.','markersize',50);

%%%%% show the electrode name
tmptext = {'-------Sagittal-------',handles.Electrode_Sview{:},'','-------Axial-------',handles.Electrode_Aview{:},'','-------Coronal-------',handles.Electrode_Cview{:}};
set(handles.edit_Electrode,'string',tmptext);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ShowingIn3D_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ShowingIn3D_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_Sagittal_Callback(hObject, eventdata, handles)

%%%%% the sagittal view of MRI %%%%%
S = round(get(handles.slider_Sagittal,'Value'));
% if handles.sno_s > 1
    set(handles.text_Sagittal, 'String', ['Slice: ' num2str(S) '/' num2str(handles.sno_s)]);
% else
%     set(handles.text_Sagittal, 'String', '2D image');
% end

axes(handles.axes_Sagittal_MRI);
img = handles.ImgSg;
view = 'S';
% handles.S_s = round(get(handles.slider_Sagittal,'Value'));
imagegca=get(handles.axes_Sagittal_MRI,'children');

set(imagegca(end),'cdata',squeeze(img(:,:,S,:)))
hold on
if length(imagegca)>1
    for ii=1:length(imagegca)-1
        delete(imagegca(ii))
    end
end
[X_Data,Y_Data,ename]=locateelec(view,handles.elecpos,S,handles.elec_name);
if ~isempty(X_Data)
%     set(handles.plotele_MRI_S,'xdata',X_Data,'ydata',Y_Data);
%     set(handles.plottext_MRI_S,'position',[X_Data+3;Y_Data+3]','text',ename);
    plot(X_Data,Y_Data,'ro','markersize',handles.fontmarkerval,'markerfacecolor','r','markeredgecolor','r');
    if get(handles.checkbox_ElectrodeName,'value')
        text(X_Data+3,Y_Data+3,ename,'color','y','fontsize',handles.fontsizeval);
    end
    
% else
%     set(handles.plotele_MRI_S,'xdata',[],'ydata',[]);
%     set(handles.plottext_MRI_S,'string',[]);
end
% tic
Win = get(handles.slider_WS,'value');
LevV = get(handles.slider_LS,'value');
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
caxis(handles.axes_Sagittal_MRI,[Rmin, Rmax]);
% toc


%%%%% the sagittal view of Altas %%%%%
elec_num=length(handles.elec_Info_Final_wm.pos);
% tic
axes(handles.axes_Sagittal_Atlas);%toc
imagesc(squeeze(handles.VOLWM.vol(:,S,:)));%toc
axis off;
box off;
colormap(handles.AsegWM.color);
hold on;
tmpelectrodename = {};
for j=1:elec_num
    if S==handles.elec_Info_Final_wm.ano_pos{1,j}(2)
        plot(handles.elec_Info_Final_wm.ano_pos{1,j}(3),handles.elec_Info_Final_wm.ano_pos{1,j}(1),'wo','markersize',handles.fontmarkerval,'markerfacecolor','r');
        if get(handles.checkbox_ElectrodeName,'value')
            text(handles.elec_Info_Final_wm.ano_pos{1,j}(3)+3,handles.elec_Info_Final_wm.ano_pos{1,j}(1)-3,...
                strcat(handles.elec_Info_Final_wm.name{j}()),'Fontsize',handles.fontsizeval,'Fontweight','bold','color','w');
        end
        tmpelectrodename{end+1} = strcat(handles.elec_Info_Final_wm.name{j}(),'/',handles.elec_Info_Final_wm.ana_label_name{j}());
    end
end
hold off;
handles.Electrode_Sview = tmpelectrodename;
%%%%% show the electrode name
tmptext = {'-------Sagittal-------',handles.Electrode_Sview{:},'','-------Axial-------',handles.Electrode_Aview{:},'','-------Coronal-------',handles.Electrode_Cview{:}};
set(handles.edit_Electrode,'string',tmptext);

% toc
%%%%% change the 3D coordinate in the brain %%%%%
Ss = get(handles.slider_Sagittal,'value');
As = get(handles.slider_Axial,'value');
Cs = get(handles.slider_Coronal,'value');

Coordi=handles.Mat*[Ss,As,Cs,1]';
Coordi=Coordi(1:3);

set(handles.coordinate1,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));
set(handles.coordinate2,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));

guidata(hObject,handles);

% hObject    handle to slider_Sagittal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_Sagittal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Sagittal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_Axial_Callback(hObject, eventdata, handles)
S = round(get(handles.slider_Axial,'Value'));
if handles.sno_a > 1
    set(handles.text_Axial, 'String', ['Slice: ' num2str(S) '/' num2str(handles.sno_a)]);
else
    set(handles.text_Axial, 'String', '2D image');
end
axes(handles.axes_Axial_MRI);
img = handles.ImgAx;
view = 'A';
% handles.S_s = round(get(handles.slider_Sagittal,'Value'));
imagegca=get(handles.axes_Axial_MRI,'children');

set(imagegca(end),'cdata',squeeze(img(:,:,S,:)))
hold on
if length(imagegca)>1
    for ii=1:length(imagegca)-1
        delete(imagegca(ii))
    end
end
[X_Data,Y_Data,ename]=locateelec(view,handles.elecpos,S,handles.elec_name);
if ~isempty(X_Data)
    plot(X_Data,Y_Data,'ro','markersize',handles.fontmarkerval,'markerfacecolor','r','markeredgecolor','r');
    if get(handles.checkbox_ElectrodeName,'value')         
        text(X_Data+3,Y_Data+3,ename,'color','y','fontsize',handles.fontsizeval);     
    end
end

Win = get(handles.slider_WA,'value');
LevV = get(handles.slider_LA,'value');
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
caxis([Rmin, Rmax]);

%%%%% the axial view of Altas %%%%%
elec_num=length(handles.elec_Info_Final_wm.pos);

axes(handles.axes_Axial_Atlas);
ImgA = squeeze(handles.VOLWM.vol(S,:,:))';
tform=maketform('affine',[1 0 0;0 -1 0;0 0 1]);
ImgA=imtransform(ImgA,tform,'nearest');
imagesc(ImgA);
axis off;
box off;
colormap(handles.AsegWM.color);
hold on;
tmpelectrodename = {};
for j=1:elec_num
    if S==handles.elec_Info_Final_wm.ano_pos{1,j}(1)
        plot(handles.elec_Info_Final_wm.ano_pos{1,j}(2),size(ImgA,2)-handles.elec_Info_Final_wm.ano_pos{1,j}(3),'wo','markersize',handles.fontmarkerval,'markerfacecolor','r');
        if get(handles.checkbox_ElectrodeName,'value')
            text(handles.elec_Info_Final_wm.ano_pos{1,j}(2)+3,size(ImgA,2)-handles.elec_Info_Final_wm.ano_pos{1,j}(3)-3,...
                strcat(handles.elec_Info_Final_wm.name{j}()),'Fontsize',handles.fontsizeval,'Fontweight','bold','color','w');
        end
        tmpelectrodename{end+1} = strcat(handles.elec_Info_Final_wm.name{j}(),'/',handles.elec_Info_Final_wm.ana_label_name{j}());
    end
end

hold off;
handles.Electrode_Aview = tmpelectrodename;
%%%%% show the electrode name
tmptext = {'-------Sagittal-------',handles.Electrode_Sview{:},'','-------Axial-------',handles.Electrode_Aview{:},'','-------Coronal-------',handles.Electrode_Cview{:}};
set(handles.edit_Electrode,'string',tmptext);

%%%%% change the 3D coordinate in the brain %%%%%
Ss = get(handles.slider_Sagittal,'value');
As = get(handles.slider_Axial,'value');
Cs = get(handles.slider_Coronal,'value');

Coordi=handles.Mat*[Ss,As,Cs,1]';
Coordi=Coordi(1:3);

set(handles.coordinate1,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));
set(handles.coordinate2,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));

guidata(hObject,handles);
% hObject    handle to slider_Axial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_Axial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Axial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_Coronal_Callback(hObject, eventdata, handles)
S = round(get(handles.slider_Coronal,'Value'));
% if handles.sno_c > 1
    set(handles.text_Coronal, 'String', ['Slice: ' num2str(S) '/' num2str(handles.sno_c)]);
% else
%     set(handles.text_Coronal, 'String', '2D image');
% end

axes(handles.axes_Coronal_MRI);
img = handles.ImgCr;
view = 'C';
% handles.S_s = round(get(handles.slider_Sagittal,'Value'));
imagegca=get(handles.axes_Coronal_MRI,'children');

set(imagegca(end),'cdata',squeeze(img(:,:,S,:)))
hold on
if length(imagegca)>1
    for ii=1:length(imagegca)-1
        delete(imagegca(ii))
    end
end
[X_Data,Y_Data,ename]=locateelec(view,handles.elecpos,S,handles.elec_name);
if ~isempty(X_Data)
    plot(X_Data,Y_Data,'ro','markersize',handles.fontmarkerval,'markerfacecolor','r','markeredgecolor','r');
    if get(handles.checkbox_ElectrodeName,'value')         
        text(X_Data+3,Y_Data+3,ename,'color','y','fontsize',handles.fontsizeval);     
    end
end
Win = get(handles.slider_WC,'value');
LevV = get(handles.slider_LC,'value');
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
caxis([Rmin, Rmax]);

% %%%%% the coronal view of Altas %%%%%
elec_num=length(handles.elec_Info_Final_wm.pos);

axes(handles.axes_Coronal_Atlas);
imagesc(squeeze(handles.VOLWM.vol(:,:,S)));
axis off;
box off;
colormap(handles.AsegWM.color);
hold on;
tmpelectrodename = {};
for j=1:elec_num
    if S==handles.elec_Info_Final_wm.ano_pos{1,j}(3)
        plot(handles.elec_Info_Final_wm.ano_pos{1,j}(2),handles.elec_Info_Final_wm.ano_pos{1,j}(1),'wo','markersize',handles.fontmarkerval,'markerfacecolor','r');
        if get(handles.checkbox_ElectrodeName,'value')
            text(handles.elec_Info_Final_wm.ano_pos{1,j}(2)+3,handles.elec_Info_Final_wm.ano_pos{1,j}(1)-3,...
                strcat(handles.elec_Info_Final_wm.name{j}()),'Fontsize',handles.fontsizeval,'Fontweight','bold','color','w');
        end
        tmpelectrodename{end+1} = strcat(handles.elec_Info_Final_wm.name{j}(),'/',handles.elec_Info_Final_wm.ana_label_name{j}());
    end
end
hold off;
handles.Electrode_Cview = tmpelectrodename;
%%%%% show the electrode name
tmptext = {'-------Sagittal-------',handles.Electrode_Sview{:},'','-------Axial-------',handles.Electrode_Aview{:},'','-------Coronal-------',handles.Electrode_Cview{:}};
set(handles.edit_Electrode,'string',tmptext);

%%%%% change the 3D coordinate in the brain %%%%%

Ss = get(handles.slider_Sagittal,'value');
As = get(handles.slider_Axial,'value');
Cs = get(handles.slider_Coronal,'value');
Coordi=handles.Mat*[Ss,As,Cs,1]';
Coordi=Coordi(1:3);

set(handles.coordinate1,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));
set(handles.coordinate2,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));

guidata(hObject,handles);
% hObject    handle to slider_Coronal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_Coronal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Coronal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_Window_Sg_Callback(hObject, eventdata, handles)
Win = str2double(get(handles.edit_Window_Sg, 'string'));
LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Sagittal_MRI);
caxis([Rmin, Rmax])
% hObject    handle to edit_Window_Sg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Window_Sg as text
%        str2double(get(hObject,'String')) returns contents of edit_Window_Sg as a double


% --- Executes during object creation, after setting all properties.
function edit_Window_Sg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Window_Sg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Level_Sg_Callback(hObject, eventdata, handles)
Win = str2double(get(handles.edit_Window_Sg, 'string'));
LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Sagittal_MRI);
caxis([Rmin, Rmax])
% hObject    handle to edit_Level_Sg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level_Sg as text
%        str2double(get(hObject,'String')) returns contents of edit_Level_Sg as a double


% --- Executes during object creation, after setting all properties.
function edit_Level_Sg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level_Sg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Window_Ax_Callback(hObject, eventdata, handles)
Win = str2double(get(handles.edit_Window_Ax, 'string'));
LevV = str2double(get(handles.edit_Level_Ax,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Axial_MRI);
caxis([Rmin, Rmax])
% hObject    handle to edit_Window_Ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Window_Ax as text
%        str2double(get(hObject,'String')) returns contents of edit_Window_Ax as a double


% --- Executes during object creation, after setting all properties.
function edit_Window_Ax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Window_Ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Level_Ax_Callback(hObject, eventdata, handles)
Win = str2double(get(handles.edit_Window_Ax, 'string'));
LevV = str2double(get(handles.edit_Level_Ax,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Axial_MRI);
caxis([Rmin, Rmax])
% hObject    handle to edit_Level_Ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level_Ax as text
%        str2double(get(hObject,'String')) returns contents of edit_Level_Ax as a double


% --- Executes during object creation, after setting all properties.
function edit_Level_Ax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level_Ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Window_Cr_Callback(hObject, eventdata, handles)
Win = str2double(get(handles.edit_Window_Cr, 'string'));
LevV = str2double(get(handles.edit_Level_Cr,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Coronal_MRI);
caxis([Rmin, Rmax])
% hObject    handle to edit_Window_Cr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Window_Cr as text
%        str2double(get(hObject,'String')) returns contents of edit_Window_Cr as a double


% --- Executes during object creation, after setting all properties.
function edit_Window_Cr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Window_Cr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Level_Cr_Callback(hObject, eventdata, handles)
Win = str2double(get(handles.edit_Window_Cr, 'string'));
LevV = str2double(get(handles.edit_Level_Cr,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Coronal_MRI);
caxis([Rmin, Rmax])
% hObject    handle to edit_Level_Cr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Level_Cr as text
%        str2double(get(hObject,'String')) returns contents of edit_Level_Cr as a double


% --- Executes during object creation, after setting all properties.
function edit_Level_Cr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Level_Cr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
UPDN = eventdata.VerticalScrollCount;
tmpCursorPosition = get(handles.figure1,'CurrentPoint');
figuresize = get(handles.figure1,'position');
tmpCursorPosition = tmpCursorPosition./figuresize(3:4);

PS = get(handles.slider_Sagittal,'position');
PA = get(handles.slider_Axial,'position');
PC = get(handles.slider_Coronal,'position');
if (tmpCursorPosition(2)<= (PS(2)+PS(4))) && (tmpCursorPosition(2)>= PS(2))
    if tmpCursorPosition(1)>=PS(1) && tmpCursorPosition(1)<=PS(1)+PS(3)
        S = get(handles.slider_Sagittal,'value');
        if S-UPDN<0 || S-UPDN>handles.sno_s
            return;
        end
        set(handles.slider_Sagittal,'value',S-UPDN);
        slider_Sagittal_Callback(hObject, eventdata, handles);
    elseif tmpCursorPosition(1)>=PA(1) && tmpCursorPosition(1)<=PA(1)+PA(3)
        S = get(handles.slider_Axial,'value');
        if S-UPDN<0 || S-UPDN>handles.sno_a
            return;
        end
        set(handles.slider_Axial,'value',S-UPDN);
        slider_Axial_Callback(hObject, eventdata, handles);
    elseif tmpCursorPosition(1)>=PC(1) && tmpCursorPosition(1)<=PC(1)+PC(3)
        S = get(handles.slider_Coronal,'value');
        if S-UPDN<0 || S-UPDN>handles.sno_c
            return;
        end
        set(handles.slider_Coronal,'value',S-UPDN);
        slider_Coronal_Callback(hObject, eventdata, handles);
    end
end


% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_ViewSide.
function popupmenu_ViewSide_Callback(hObject, eventdata, handles)
%%%%% plot the 3D coordinate in the brain %%%%%
axes(handles.axes_Coordinate);
tmphandles.axes_Display = handles.axes_Coordinate;
tmphandles.ConfigurationPath = handles.mainGUIhandles.ConfigurationPath;
Etala.electrodes=cell2mat(handles.elec_Info_Final_wm.pos');

viewall = get(handles.popupmenu_ViewSide,'string');
viewnum = get(handles.popupmenu_ViewSide,'value');
view_vect = viewall{viewnum};
viewBrain(handles.cortex, Etala, {'brain','electrodes'}, 0.1, 50, view_vect,tmphandles);
axis off;
colorbar off
hold on

Ss = get(handles.slider_Sagittal,'value');
As = get(handles.slider_Axial,'value');
Cs = get(handles.slider_Coronal,'value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Coordi=handles.Mat*[Ss,As,Cs,1]';
Coordi=Coordi(1:3);
% set(handles.coordinate1,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));
% set(handles.coordinate2,'xdata',Coordi(1),'ydata',Coordi(2),'zdata',Coordi(3));
handles.coordinate1 = plot3(Coordi(1),Coordi(2),Coordi(3),'r+','markersize',30);
hold on
handles.coordinate2 = plot3(Coordi(1),Coordi(2),Coordi(3),'r.','markersize',20);
guidata(hObject,handles)
% hObject    handle to popupmenu_ViewSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ViewSide contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ViewSide


% --- Executes during object creation, after setting all properties.
function popupmenu_ViewSide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ViewSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_LC_Callback(hObject, eventdata, handles)
Win = get(handles.slider_WC,'value');
LevV = get(handles.slider_LC,'value');
set(handles.text_LC,'string',['Level: ' num2str(LevV) '/255']);
% str2double(get(handles.edit_Window_Sg, 'string'));
% LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Coronal_MRI);
caxis([Rmin, Rmax]);
% hObject    handle to slider_LC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_LC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_LC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_LA_Callback(hObject, eventdata, handles)
Win = get(handles.slider_WA,'value');
LevV = get(handles.slider_LA,'value');
set(handles.text_LA,'string',['Level: ' num2str(LevV) '/255']);
% str2double(get(handles.edit_Window_Sg, 'string'));
% LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Axial_MRI);
caxis([Rmin, Rmax]);
% hObject    handle to slider_LA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_LA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_LA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_LS_Callback(hObject, eventdata, handles)
Win = get(handles.slider_WS,'value');
LevV = get(handles.slider_LS,'value');
set(handles.text_LS,'string',['Level: ' num2str(LevV) '/255']);
% str2double(get(handles.edit_Window_Sg, 'string'));
% LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Sagittal_MRI);
caxis([Rmin, Rmax]);
% hObject    handle to slider_LS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_LS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_LS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_WC_Callback(hObject, eventdata, handles)
Win = get(handles.slider_WC,'value');
LevV = get(handles.slider_LC,'value');
set(handles.text_WC,'string',['Window: ' num2str(Win) '/255']);
% str2double(get(handles.edit_Window_Sg, 'string'));
% LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Coronal_MRI);
caxis([Rmin, Rmax]);
% hObject    handle to slider_WC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_WC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_WC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_WA_Callback(hObject, eventdata, handles)
Win = get(handles.slider_WA,'value');
LevV = get(handles.slider_LA,'value');
set(handles.text_WA,'string',['Window: ' num2str(Win) '/255']);
% str2double(get(handles.edit_Window_Sg, 'string'));
% LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Axial_MRI);
caxis([Rmin, Rmax]);
% hObject    handle to slider_WA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_WA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_WA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_WS_Callback(hObject, eventdata, handles)
Win = get(handles.slider_WS,'value');
LevV = get(handles.slider_LS,'value');
set(handles.text_WS,'string',['Window: ' num2str(Win) '/255']);
% str2double(get(handles.edit_Window_Sg, 'string'));
% LevV = str2double(get(handles.edit_Level_Sg,'string'));
if (Win < 1)
    Win = 1;
end
[Rmin, Rmax] = WL2R(Win,LevV);
axes(handles.axes_Sagittal_MRI);
caxis([Rmin, Rmax]);

% hObject    handle to slider_WS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_WS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_WS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function text_Sagittal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Sagittal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
tmpCursorPosition = get(handles.figure1,'CurrentPoint')

% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider20_Callback(hObject, eventdata, handles)
% hObject    handle to slider20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider21_Callback(hObject, eventdata, handles)
% hObject    handle to slider21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider22_Callback(hObject, eventdata, handles)
% hObject    handle to slider22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider23_Callback(hObject, eventdata, handles)
% hObject    handle to slider23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider24_Callback(hObject, eventdata, handles)
% hObject    handle to slider24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider25_Callback(hObject, eventdata, handles)
% hObject    handle to slider25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider26_Callback(hObject, eventdata, handles)
% hObject    handle to slider26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider27_Callback(hObject, eventdata, handles)
% hObject    handle to slider27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider28_Callback(hObject, eventdata, handles)
% hObject    handle to slider28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_Save.
function pushbutton_Save_Callback(hObject, eventdata, handles)
% figurepath = [handles.mainGUIhandles.ConfigurationPath.subject_directory '/Figure/'];
% mkdir(figurepath);
% savefig([figurepath,'Test2.fig']);

try
    SaveFlag = PictureSave_GUI;
catch
    return;
end
figurepath = [handles.mainGUIhandles.ConfigurationPath.subject_directory '/Figure/'];
mkdir(figurepath);
   
if SaveFlag(1)
    new_f_handle=figure('visible','on'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes_Sagittal_MRI,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    saveas(new_f_handle,[figurepath handles.mainGUIhandles.ConfigurationPath.subject_name '_MRI_Sagittal.fig']);
    close(new_f_handle);
end
if SaveFlag(2)
    new_f_handle=figure('visible','on'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes_Axial_MRI,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    saveas(new_f_handle,[figurepath handles.mainGUIhandles.ConfigurationPath.subject_name '_MRI_Axial.fig']);
    close(new_f_handle);
end
if SaveFlag(3)
    new_f_handle=figure('visible','on'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes_Coronal_MRI,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    saveas(new_f_handle,[figurepath handles.mainGUIhandles.ConfigurationPath.subject_name '_MRI_Coronal.fig']);
    close(new_f_handle);
end
if SaveFlag(4)
    new_f_handle=figure('visible','on'); %新建一个不可见的figure
%     set(gcf,'position',[80 80 400 400]);
    new_axes=copyobj(handles.axes_Sagittal_Atlas,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中      
    set(new_axes,'Units','normalized','Position',[0.2 0.1 0.6 0.8]);%将图线缩放
%     set(new_axes,'Units','centimeter','Position',[1 1 15 15]);%将图线缩放
    colormap(handles.AsegWM.color);
    saveas(new_f_handle,[figurepath handles.mainGUIhandles.ConfigurationPath.subject_name '_Atlas_Sagittal.fig']);
    close(new_f_handle);
end
if SaveFlag(5)
    new_f_handle=figure('visible','on'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes_Axial_Atlas,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.2 0.1 0.6 0.8]);%将图线缩放
    colormap(handles.AsegWM.color);
    saveas(new_f_handle,[figurepath handles.mainGUIhandles.ConfigurationPath.subject_name '_Atlas_Axial.fig']);
    close(new_f_handle);
end
if SaveFlag(6)
    new_f_handle=figure('visible','on'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes_Coronal_Atlas,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.2 0.1 0.6 0.8]);%将图线缩放
    colormap(handles.AsegWM.color);
    saveas(new_f_handle,[figurepath handles.mainGUIhandles.ConfigurationPath.subject_name '_Atlas_Coronal.fig']);
    close(new_f_handle);
end
if SaveFlag(7)
    new_f_handle=figure('visible','on'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes_Coordinate,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    saveas(new_f_handle,[figurepath handles.mainGUIhandles.ConfigurationPath.subject_name '_BrainCoordinate.fig']);
    close(new_f_handle);
end
msgbox('Save completed!')
% hObject    handle to pushbutton_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_Electrode_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Electrode as text
%        str2double(get(hObject,'String')) returns contents of edit_Electrode as a double


% --- Executes during object creation, after setting all properties.
function edit_Electrode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Electrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_ElectrodeName.
function checkbox_ElectrodeName_Callback(hObject, eventdata, handles)
slider_Coronal_Callback(hObject, eventdata, handles);
slider_Axial_Callback(hObject, eventdata, handles);
slider_Sagittal_Callback(hObject, eventdata, handles);
% hObject    handle to checkbox_ElectrodeName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ElectrodeName
