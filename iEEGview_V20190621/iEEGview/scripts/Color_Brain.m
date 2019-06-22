%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% color the surface of the serveral cortex areas
%%%% Written by Li Guangye(liguangye.hust@gmail.com) @SJTU @2016.11.27
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Color_Brain(hemi)
%hemi  shall be l or r
% l ==left cortex
% r ==right cortex
if isempty(hemi)
    error(['please enter which side of brain you want to plot. "l/r"']);
end

M=load('MATLAB\WholeCortex.mat');
N=M.leftcortex;
LV=length(N.vert);
R=M.rightcortex;
RV=length(R.vert);

if strcmp(hemi,'r')==1
    [AV,BV,CV]=read_annotation('Segmentation\label\rh.aparc.annot');
    M=R;
else
    [AV,BV,CV]=read_annotation('Segmentation\label\lh.aparc.annot');
    M=N;
end
%%
index=cell(CV.numEntries,1);
Cindexed=zeros(length(M.vert),3);
Cortex_Index=[];
Color_Index=[];

for  i=1:CV.numEntries
    index{i}=find(BV==CV.table(i,end));
    i
    if isempty(index{i})
        i=i+1;
        index{i}=find(BV==CV.table(i,end));
        
    end
    if i==23 || i==25 || i==29 || i==4 || i==36
        % i=19 %% pars opercularis
        % i=21 %% pars triangularis
        % i=4 %%
        % i=29 %%
        % i=28%%
        % i=36 %%
        % i=23 %%
        % i=25, %%
        
        if i==4
            Cindexed(index{i},:)=repmat(CV.table(21,1:3),length(index{i}),1)/255;
        elseif i==25
            Cindexed(index{i},:)=repmat((CV.table(i,1:3)-[-20 0 0]),length(index{i}),1)/255;
        else
            Cindexed(index{i},:)=repmat(CV.table(i,1:3),length(index{i}),1)/255;
        end
        Cortex_Index=[Cortex_Index;index{i}];
        Color_Index=[Color_Index;Cindexed(index{i},:)];
    else
        Cindexed(index{i},:)=repmat([220,220,220],length(index{i}),1)/255;
    end
end
Cortex_Color=[Cortex_Index,Color_Index];
save('MATLAB\Cortex_Color.mat','Cortex_Color','LV','RV','Cindexed');

end

