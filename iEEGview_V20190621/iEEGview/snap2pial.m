function [ electri ] = snap2pial(cortex,elec)
%This script is used for finding the closet vertex
% by liguangye.hust@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=cortex.vert;
N=length(M);
electri=[];
for i=1:length(elec)
        dev_x=(M(:,1)-elec(i,1)).^2;
        dev_y=(M(:,2)-elec(i,2)).^2;
        dev_z=(M(:,3)-elec(i,3)).^2;
    temp=dev_x+dev_y+dev_z;
    [mindist,minind]=min(temp);
    clear temp
    mindist=mindist(1);
    minind=minind(1);
    electri(i,:)=M(minind,:);
end
 

end

