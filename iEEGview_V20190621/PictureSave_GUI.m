function varargout = PictureSave_GUI(varargin)
% PICTURESAVE_GUI MATLAB code for PictureSave_GUI.fig
%      PICTURESAVE_GUI, by itself, creates a new PICTURESAVE_GUI or raises the existing
%      singleton*.
%
%      H = PICTURESAVE_GUI returns the handle to a new PICTURESAVE_GUI or the handle to
%      the existing singleton*.
%
%      PICTURESAVE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICTURESAVE_GUI.M with the given input arguments.
%
%      PICTURESAVE_GUI('Property','Value',...) creates a new PICTURESAVE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PictureSave_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PictureSave_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PictureSave_GUI

% Last Modified by GUIDE v2.5 21-Dec-2018 19:02:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PictureSave_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PictureSave_GUI_OutputFcn, ...
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


% --- Executes just before PictureSave_GUI is made visible.
function PictureSave_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PictureSave_GUI (see VARARGIN)

% Choose default command line output for PictureSave_GUI
handles.output = hObject;
handles.SaveFlag = zeros(1,7);
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);




% UIWAIT makes PictureSave_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PictureSave_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.SaveFlag;
delete(handles.figure1);



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)

SaveFlag(1) = get(handles.checkbox1,'value');
SaveFlag(2) = get(handles.checkbox2,'value');
SaveFlag(3) = get(handles.checkbox3,'value');
SaveFlag(4) = get(handles.checkbox4,'value');
SaveFlag(5) = get(handles.checkbox5,'value');
SaveFlag(6) = get(handles.checkbox6,'value');
SaveFlag(7) = get(handles.checkbox7,'value');
handles.SaveFlag = SaveFlag;
guidata(hObject,handles);

uiresume(handles.figure1);

% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% SaveFlag(1) = get(handles.checkbox1,'value');
% SaveFlag(2) = get(handles.checkbox2,'value');
% SaveFlag(3) = get(handles.checkbox3,'value');
% SaveFlag(4) = get(handles.checkbox4,'value');
% SaveFlag(5) = get(handles.checkbox5,'value');
% SaveFlag(6) = get(handles.checkbox6,'value');
% SaveFlag(7) = get(handles.checkbox7,'value');
% handles.SaveFlag = SaveFlag;
% guidata(hObject,handles);
% uiresume(handles.figure1);
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% uiresume(handles.figure1);

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
