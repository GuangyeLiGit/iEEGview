function [stdCoords]=sub2stdbrain(elecCoord,hem,subDir,fsDir)
if hem==1
n_pial_vert=size(subDir.leftcortex.vert,1);
df=subDir.leftcortex.vert-repmat(elecCoord,n_pial_vert,1);
dst=sum(df.^2,2);
[~, subVids]=min(dst);
subVids=subVids(1);

nfsVert=length(fsDir.leftcortexreg.vert);
df=fsDir.leftcortexreg.vert-repmat(subDir.leftcortexreg.vert(subVids,:),nfsVert,1);
dst=sum(df.^2,2);
[~, fsVids]=min(dst);
fsVids=fsVids(1);

stdCoords=fsDir.leftcortex.vert(fsVids,:);
else
n_pial_vert=size(subDir.rightcortex.vert,1);
df=subDir.rightcortex.vert-repmat(elecCoord,n_pial_vert,1);
dst=sum(df.^2,2);
[~, subVids]=min(dst);
subVids=subVids(1);

nfsVert=length(fsDir.rightcortexreg.vert);
df=fsDir.rightcortexreg.vert-repmat(subDir.rightcortexreg.vert(subVids,:),nfsVert,1);
dst=sum(df.^2,2);
[~, fsVids]=min(dst);
fsVids=fsVids(1);

stdCoords=fsDir.rightcortex.vert(fsVids,:);
end

end