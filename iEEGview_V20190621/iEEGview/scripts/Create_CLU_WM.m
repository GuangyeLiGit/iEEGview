M=importdata([scriptdirectory,'/iEEGview/FreeSurferColorLUT_V1.txt']);%Color Look Up Table
tmpindx=ones(size(M.data,1),1);
for i=1:size(M.data,1)
    tmpindx(i)=str2num(M.textdata{i,1});
end
%%
AsegWM.color=zeros(length(tmpindx),3);
AsegWM.name=cell(size(M.textdata,1),1);
AsegWM.index=tmpindx;
for idx=1:size(M.data,1)
    AsegWM.color(idx,:)=M.data(idx,1:3)/255;
    AsegWM.name{idx,1}=M.textdata{idx,2};    
end
%%
save([subject_directory,'/Electrodes/AsegWM.mat'],'AsegWM')

