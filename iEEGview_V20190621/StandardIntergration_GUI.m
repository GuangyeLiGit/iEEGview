function varargout = StandardIntergration_GUI(varargin)
% STANDARDINTERGRATION_GUI MATLAB code for StandardIntergration_GUI.fig
%      STANDARDINTERGRATION_GUI, by itself, creates a new STANDARDINTERGRATION_GUI or raises the existing
%      singleton*.
%
%      H = STANDARDINTERGRATION_GUI returns the handle to a new STANDARDINTERGRATION_GUI or the handle to
%      the existing singleton*.
%
%      STANDARDINTERGRATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STANDARDINTERGRATION_GUI.M with the given input arguments.
%
%      STANDARDINTERGRATION_GUI('Property','Value',...) creates a new STANDARDINTERGRATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StandardIntergration_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StandardIntergration_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StandardIntergration_GUI

% Last Modified by GUIDE v2.5 10-Mar-2019 14:46:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StandardIntergration_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StandardIntergration_GUI_OutputFcn, ...
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


% --- Executes just before StandardIntergration_GUI is made visible.
function StandardIntergration_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StandardIntergration_GUI (see VARARGIN)

% Choose default command line output for StandardIntergration_GUI
handles.mainfigure = varargin{1};
handles.output = hObject;
handles.SubPath{1}= [handles.mainfigure.ConfigurationPath.subject_directory '/Electrodes/electrodes_Final_Norm.mat'];
handles.StandardPath{1} = [handles.mainfigure.ConfigurationPath.subject_directory '/iEEGview/StdbrainModel/MATLAB/WholeCortex.mat'];
set(handles.listbox_SubPath,'string',handles.SubPath);
set(handles.text_Standard,'string',handles.StandardPath);

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes StandardIntergration_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StandardIntergration_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.SubPath;
varargout{2} = handles.StandardPath;
delete(handles.figure1);


% --- Executes on selection change in listbox_SubPath.
function listbox_SubPath_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_SubPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_SubPath contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_SubPath


% --- Executes during object creation, after setting all properties.
function listbox_SubPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_SubPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Add.
function pushbutton_Add_Callback(hObject, eventdata, handles)
[filename,filepath] = uigetfile('*.mat','Select the electrode file');
handles.SubPath{end+1} = [filepath, filename];
set(handles.listbox_SubPath,'string',handles.SubPath);
guidata(hObject,handles);
% hObject    handle to pushbutton_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Delete.
function pushbutton_Delete_Callback(hObject, eventdata, handles)
sub = get(handles.listbox_SubPath,'value');
handles.SubPath(sub) = [];
set(handles.listbox_SubPath,'string','');
set(handles.listbox_SubPath,'string',handles.SubPath);
guidata(hObject,handles);
% hObject    handle to pushbutton_Delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Complete.
function pushbutton_Complete_Callback(hObject, eventdata, handles)
if isempty(handles.SubPath)
    errordlg('Please select at least one subject path');
    return;
elseif isempty(handles.StandardPath)
    errordlg('Please select the standard model path');
    return;
end
uiresume(handles.figure1);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Standard.
function pushbutton_Standard_Callback(hObject, eventdata, handles)
[filename,filepath] = uigetfile('*.mat','Select the standard model');
handles.StandardPath = [filepath,filename];
set(handles.text_Standard,'string',handles.StandardPath);
guidata(hObject,handles);
% hObject    handle to pushbutton_Standard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Clear.
function pushbutton_Clear_Callback(hObject, eventdata, handles)
handles.SubPath = {};
set(handles.listbox_SubPath,'string',handles.SubPath);
guidata(hObject,handles);
% hObject    handle to pushbutton_Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_Cancel.
function pushbutton_Cancel_Callback(hObject, eventdata, handles)
delete(handles.figure1);
% hObject    handle to pushbutton_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
