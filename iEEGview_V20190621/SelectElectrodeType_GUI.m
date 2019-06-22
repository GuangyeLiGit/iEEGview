function [ElectrodeType,ElectrodeLength] = SelectElectrodeType_GUI(ElectrodeName)
% ElectrodeName = {'A','B','C','D','E','F','G'};
PinNum = length(ElectrodeName);
typestring = {'Normal','8+8, 70mm','10+6, 80mm'};
figure1 = figure('position',[100,100,300,PinNum*40+240],'color',[1,1,1]);

for ele = 1:PinNum
    tmptext{ele} = uicontrol('Style', 'text','Position', [50,40*(ele-1)+160,50,30],'String',ElectrodeName{ele},'FontSize', 12,'backgroundcolor',[1,1,1]);
    tmpmenu{ele} = uicontrol('Style','popupmenu','Position',[100,40*(ele-1)+160,100,30],'String',typestring,'FontSize',12,'backgroundcolor',[1,1,1]);
%     eval(['text' num2str(ele) '=tmptext;']);
%     eval(['type' num2str(ele) '=tmpmenu;']);
end

notice = uicontrol('Style', 'text','Position', [50,40*(ele-1)+210,200,30],'String','Select the electrode type','FontSize', 14,'backgroundcolor',[1,1,1]);
okbutton = uicontrol('Style','pushbutton','position',[120,10,50,30],'string','OK','FontSize', 12,'backgroundcolor',[1,1,1],'Callback',@OKfunction);
txt1 = uicontrol('Style', 'text','Position', [20,90,150,20],'String','Inter-contact distance (mm)','FontSize', 12,'backgroundcolor',[1,1,1]);
txt2 = uicontrol('Style', 'text','Position', [20,120,150,20],'String','Contact length (mm)','FontSize', 12,'backgroundcolor',[1,1,1]);
edit1 = uicontrol('Style','edit','Position',[180,90,70,20],'String','3.5','FontSize',12,'backgroundcolor',[1,1,1]);
edit2 = uicontrol('Style','edit','Position',[180,120,70,20],'String','2','FontSize',12,'backgroundcolor',[1,1,1]);

txt3 = uicontrol('Style', 'text','Position', [20,60,150,20],'String','Contact diameter (mm)','FontSize', 12,'backgroundcolor',[1,1,1]);
edit3 = uicontrol('Style','edit','Position',[180,60,70,20],'String','0.8','FontSize',12,'backgroundcolor',[1,1,1]);
% pop1 = uicontrol('Style','popupmenu','Position',[100,40,100,30],'String',{'3.5mm','2mm'},'FontSize',12,'backgroundcolor',[1,1,1]);
% pop2 = uicontrol('Style','popupmenu','Position',[100,70,100,30],'String',{'1mm'},'FontSize',12,'backgroundcolor',[1,1,1]);

uiwait(figure1)


function OKfunction(object,eventdata)
for ele = 1:PinNum
%     eval(['tmpmenu=type' num2str(ele) ';']);
    ElectrodeType(ele) = get(tmpmenu{ele},'value');
end
% switch get(pop1,'value')
%     case 1
%         ElectrodeLength.ContactLength = 3.5;
%     case 2
%         ElectrodeLength.ContactLength = 2;
% end
% switch get(pop2,'value')
%     case 1
%         ElectrodeLength.InterContactLength = 1;
% end
ElectrodeLength.ContactLength = str2double(get(edit2,'string'));
ElectrodeLength.InterContactDistance = str2double(get(edit1,'string'));
ElectrodeLength.Diameter = str2double(get(edit3,'string')); 
uiresume(figure1);
close;
end

end

