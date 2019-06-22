%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is used to obtain the 3D center of each cortical area.
% Written by Li Guangye(liguangye.hust@Gmail.com) @01/02/2018 @USA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Upated by Guangye Li (liguangye.hust@gmail.com) @2018.11.11 @SJTU
%%%%%%%%Add more Cortical Parcellation methods%%%%%%%
function Get_3D_Cortex_Center_v3(subject_directory)

M=load([subject_directory,'/MATLAB/WholeCortex.mat']);
L=M.leftcortex;
LV=length(L.vert);
R=M.rightcortex;
RV=length(R.vert);
for ii=1:3
    M=struct;
    switch ii
        case 1
            Lhanot='lh.aparc.annot';
            Rhanot='rh.aparc.annot';
        case 2
            Lhanot='lh.aparc.a2009s.annot';
            Rhanot='rh.aparc.a2009s.annot';
        case 3
                        
            if exist([subject_directory,'/Segmentation/label/rh.aparc.DKTatlas.annot'],'file')==2
                Lhanot='lh.aparc.DKTatlas.annot';
                Rhanot='rh.aparc.DKTatlas.annot';
            elseif exist([subject_directory,'/Segmentation/label/rh.aparc.DKTatlas40.annot'],'file')==2
                Lhanot='lh.aparc.DKTatlas40.annot';
                Rhanot='rh.aparc.DKTatlas40.annot';
            else
                error('No annotation file is found!! Please Check your free surfer version~~');
            end
    end
    for t=1:2
        if t==1
            [AV,BV,CV]=read_annotation([subject_directory,'/Segmentation/label/',Rhanot]);
            M(t).vert=R.vert;
            M(t).tri=R.tri; % Right hemisephera put forward
            M(t).numEntries=CV.numEntries;
            M(t).struct_names=CV.struct_names;
            M(t).table=CV.table;
            M(t).BV=BV; %% add BV
        else
            [AV,BV,CV]=read_annotation([subject_directory,'/Segmentation/label/',Lhanot]);
            M(t).vert=L.vert;
            M(t).tri=L.tri;
            M(t).numEntries=CV.numEntries;
            M(t).struct_names=CV.struct_names;
            M(t).table=CV.table;
            M(t).BV=BV;
        end
        %%
        index=cell(CV.numEntries,1);
        Cindexed=zeros(length(M(t).vert),3);
        Cindexed_spec=zeros(length(M(t).vert),3);
        Cortex_Index=[];
        Color_Index=[];
        % 	Color_Index_spec=[];
        % 	Cortex_Color_spec=[];
        M(t).Center=zeros(CV.numEntries,3);
        for  i=1:CV.numEntries
            index{i}=find(BV==CV.table(i,end));
            while isempty(index{i})
                M(t).Center(i,:)=[nan,nan,nan];
                i=i+1;
                index{i}=find(BV==CV.table(i,end));
            end
            M(t).Center(i,:)=mean(M(t).vert(index{i},:));
            Cindexed(index{i},:)=repmat((CV.table(i,1:3)),length(index{i}),1)/255;
            Cortex_Index=[Cortex_Index;index{i}];
            Color_Index=[Color_Index;Cindexed(index{i},:)];
            Cortex_Color=[Cortex_Index,Color_Index];
        end
        M(t).Cortex_Color=Cortex_Color;
    end
    switch ii
        case 1
            save([subject_directory,'/MATLAB/Cortex_Center_aparc.mat'],'M');
        case 2
            save([subject_directory,'/MATLAB/Cortex_Center_aparc2009.mat'],'M');
        case 3
            save([subject_directory,'/MATLAB/Cortex_Center_DKT40.mat'],'M');
    end
end

end
%%%%%%%%Add more Cortical Parcellation methods%%%%%%%