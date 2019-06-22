function D=eucDistMat(posX,posY)
% Meassure distance between posX points (Mx3) posY points(Px3)   
% and make a distance matrix D (MxP)
% A Blenkmann
%%%%%%%%%%%%%This is the function by A Blenkmann %%%%%%%%%%%%%%%%
M=size(posX,1);
P=size(posY,1);

% pos1=repmat(single(posY),[1,1,M]);
% pos2=repmat(permute(single(posX),[3,2,1]),[P,1,1]);
pos1=repmat((posY),[1,1,M]);
pos2=repmat(permute((posX),[3,2,1]),[P,1,1]);

D=squeeze(sqrt(sum((pos1-pos2).^2,2)));
