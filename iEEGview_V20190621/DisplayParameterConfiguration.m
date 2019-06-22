set(handles.uipanel_DisplayParameter,'visible','off');
set(handles.uipanel_ActivationParameter,'visible','off');

set(handles.checkbox_DP_ColorfulBrain,'enable','off');
set(handles.checkbox_DP_Electrodes,'enable','off');
set(handles.checkbox_DP_Trielectrodes,'enable','off');
set(handles.checkbox_DP_Activations,'enable','off');
set(handles.checkbox_DP_Brain,'enable','off');
set(handles.checkbox_ColorAnalysis,'enable','off');
set(handles.checkbox_ColorAnalysis,'value',0);

% set(handles.checkbox_ColorAnalysis,'visible','off');


set(handles.checkbox_DP_ColorfulBrain,'value',0);
set(handles.checkbox_DP_Electrodes,'value',0);
set(handles.checkbox_DP_Trielectrodes,'value',0);
set(handles.checkbox_DP_Activations,'value',0);
set(handles.checkbox_DP_Brain,'value',0);

set(handles.edit_ColorfulCortexSpec,'visible','off');
set(handles.text_AOI,'visible','off');
set(handles.edit_Alpha,'string','0.1');
set(handles.edit_Alpha,'enable','on');

DisplayOption = get(handles.popupmenu_DisplayOption,'value');

switch DisplayOption
    case 1
        set(handles.uipanel_DisplayParameter,'visible','off');
    case 2
        set(handles.uipanel_DisplayParameter,'visible','on');
        set(handles.checkbox_DP_Electrodes,'enable','on');
        set(handles.checkbox_DP_Trielectrodes,'enable','on');
%         set(handles.checkbox_DP_Activations,'enable','on');
        set(handles.checkbox_DP_Brain,'enable','on');
        set(handles.checkbox_DP_Brain,'value',1);
    case 3
        set(handles.uipanel_DisplayParameter,'visible','on');
        set(handles.checkbox_DP_ColorfulBrain,'enable','on');
        set(handles.checkbox_DP_Brain,'value',1);
        set(handles.checkbox_DP_Electrodes,'enable','on');
        set(handles.checkbox_DP_Electrodes,'value',1);
        set(handles.checkbox_DP_Trielectrodes,'enable','on');
    case 4
        set(handles.uipanel_DisplayParameter,'visible','on');
        set(handles.checkbox_DP_Activations,'value',1);
        set(handles.checkbox_DP_Brain,'value',1);
        set(handles.uipanel_ActivationParameter,'visible','on');
        set(handles.edit_Alpha,'string','1');
        set(handles.edit_Alpha,'enable','off');
    case 5
        set(handles.uipanel_DisplayParameter,'visible','on');
        set(handles.checkbox_DP_Brain,'value',1);
        set(handles.checkbox_DP_Electrodes,'value',1);
        set(handles.checkbox_DP_ColorfulBrain,'enable','on');
        set(handles.checkbox_DP_Electrodes,'enable','on');
        set(handles.checkbox_DP_Trielectrodes,'enable','on');
    case 6
        set(handles.uipanel_DisplayParameter,'visible','on');
        set(handles.checkbox_DP_Activations,'value',1);
        set(handles.checkbox_DP_Brain,'value',1);
        set(handles.uipanel_ActivationParameter,'visible','on');
        set(handles.edit_Alpha,'string','1');
        set(handles.edit_Alpha,'enable','off');
%         set(handles.checkbox_DP_Trielectrodes,'enable','on');
end
        
switch get(handles.checkbox_DP_ColorfulBrain,'enable')
    case 'on'
%         set(handles.checkbox_ColorAnalysis,'visible','on');
        set(handles.checkbox_ColorAnalysis,'enable','on');
end
