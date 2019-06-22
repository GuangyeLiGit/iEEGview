%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script is used to calculate the Proximal Tissue Density (PTD)
%%%%% for each contact
%%%%% PTD=(nGray-nWhite)/(nGray+nWhite) local
%%%%% by Li Guangye(liguangye.hust@gmail.com) @2018/09/27 @SJTU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LocalPTD=[];
ano_pos=new_Cord_ele_uni;
lindex=[];
label_name=[];
for d=1:length(ano_pos)
    lindex(d)=VOLWM.vol(ano_pos(d,1),ano_pos(d,2),ano_pos(d,3));
    label_name{1,d}=AsegWM.name{find(AsegWM.index==lindex(d)),1};
    if ~isempty(strfind(label_name{1,d},'ctx'))||~isempty(strfind(label_name{1,d},'cortex'))
        CTX_WM_Label(d)=1;
    elseif ~isempty(strfind(label_name{1,d},'WhiteMatter'))||~isempty(strfind(label_name{1,d},'WM')) ||~isempty(strfind(label_name{1,d},'wm'))
        CTX_WM_Label(d)=2;
    elseif ~isempty(strfind(label_name{1,d},'Hippocampus'))
        CTX_WM_Label(d)=3;
    elseif ~isempty(strfind(label_name{1,d},'Amygdala'))
        CTX_WM_Label(d)=4;
    elseif ~isempty(strfind(label_name{1,d},'Putamen'))
        CTX_WM_Label(d)=5;
    else
        CTX_WM_Label(d)=6;
    end
end

if length(find(CTX_WM_Label==6))>=round(1*size(ano_pos,1)/2)
    LocalPTD=nan;
elseif length(find(CTX_WM_Label==3))>=round(1*size(ano_pos,1)/2)
    LocalPTD=3;
elseif length(find(CTX_WM_Label==4))>=round(1*size(ano_pos,1)/2)
    LocalPTD=4;
elseif length(find(CTX_WM_Label==5))>=round(1*size(ano_pos,1)/2)
    LocalPTD=5;
elseif length(find(CTX_WM_Label==1))+length(find(CTX_WM_Label==2))>=round(1*size(ano_pos,1)/2)
    LocalPTD=(length(find(CTX_WM_Label==1))-length(find(CTX_WM_Label==2)))/(length(find(CTX_WM_Label==1))+length(find(CTX_WM_Label==2)));
else
    LocalPTD=nan;
end