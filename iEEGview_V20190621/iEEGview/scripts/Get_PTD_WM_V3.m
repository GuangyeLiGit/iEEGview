%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script is used to calculate the Proximal Tissue Density (PTD)
%%%%% for each contact
%%%%% PTD=(nGray-nWhite)/(nGray+nWhite)
%%%%% by Li Guangye(liguangye.hust@gmail.com) @2017/12/29 @USA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PTD=[];
Cord=round(inv(Mat)*[trans(ele,:),1]');
ano_pos=[Cord(2),Cord(1),Cord(3)];
% get a 3*3 voxel, centered at ano_pos£¬ 27 in total
x_lim=[(ano_pos(1)-1):(ano_pos(1)+1)];
y_lim=[(ano_pos(2)-1):(ano_pos(2)+1)];
z_lim=[(ano_pos(3)-1):(ano_pos(3)+1)];
voxel_ind=0;
voxel_constr=[];
for x=1:3
    for y=1:3
        for z=1:3
            voxel_ind=voxel_ind+1;
            voxel_constr(voxel_ind,:)=[x_lim(x),y_lim(y),z_lim(z)];
        end
    end
end
lindex=[];
label_name=[];
CTX_WM_Label=zeros(size(voxel_constr,1),1);
for d=1:size(voxel_constr,1)
    lindex(d)=VOLWM.vol(voxel_constr(d,1),voxel_constr(d,2),voxel_constr(d,3));
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

if length(find(CTX_WM_Label==6))>=round(1*size(voxel_constr,1)/2)
    PTD=nan;
elseif length(find(CTX_WM_Label==3))>=round(1*size(voxel_constr,1)/2)
    PTD=3;
elseif length(find(CTX_WM_Label==4))>=round(1*size(voxel_constr,1)/2)
    PTD=4;
elseif length(find(CTX_WM_Label==5))>=round(1*size(voxel_constr,1)/2)
    PTD=5;
elseif length(find(CTX_WM_Label==1))+length(find(CTX_WM_Label==2))>=round(1*size(voxel_constr,1)/2)
    PTD=(length(find(CTX_WM_Label==1))-length(find(CTX_WM_Label==2)))/(length(find(CTX_WM_Label==1))+length(find(CTX_WM_Label==2)));
else
    PTD=nan;
end




