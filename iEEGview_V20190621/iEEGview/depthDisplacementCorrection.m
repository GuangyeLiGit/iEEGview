function [posDepth_e, d]=depthDisplacementCorrection(posDepth_s,posGrid_s,posGrid_e,sigmaR, sigmaS)
% correct depth electrodes position based on grid electrodes displacements
% based on Taimuri et al 2014 deformation field idea
%
% posDepth_s : depth electrodes position start
% posGrid_s : position grid electrodes start
% posGrid_e : position grid electrodes end
% sigmaR : guassian kernel sigma (regularization parameter). Used for
% electrode weighthing ~5mm
% sigmaS  : guassian kernel sigma. Used for spatial weighthing ~ 30 mm 

% posDepth_e : depth electrodes end (corrected) position 
% d : displacement

% A Blenkmann August 2016
%%%%%%%%%%% this is the function by A Blenkmann %%%%%%%%%%%%%%%%%%%%%%%

L = size(posGrid_s,1);
M = size(posDepth_s,1);


distances=eucDistMat(posGrid_s,posDepth_s);

projectionsGrid=posGrid_e-posGrid_s;

%used for the calculation of deformation vectors and weighted sum
weightsR=exp(-(distances.^2)/sigmaR^2); 
% used for spatial deformation extention
weightsS=exp(-(distances.^2)/sigmaS^2); 


for i=1:M
    %deformation vectors atenuated by distance
    deformationWeightedVector=repmat(weightsS(i,:)',1,3).*projectionsGrid;
    %weighted sum of vectors.
    projectionsDepth(i,:)=weightsR(i,:)*deformationWeightedVector./sum(weightsR(i,:));
end

posDepth_e=posDepth_s+projectionsDepth;
d=sqrt(sum((projectionsDepth).^2,2));

%% plots
% 
% figure;
% scatter3(posGrid_s(:,1),posGrid_s(:,2),posGrid_s(:,3),'b','filled');
% hold on;
% quiver3(posGrid_s(:,1),posGrid_s(:,2),posGrid_s(:,3),...
%     projectionsGrid(:,1),projectionsGrid(:,2),projectionsGrid(:,3),0,'b')
% %plotElectrodesLines(posGrid_s,8,8,[0 0 1]);
% axis image
% 
% scatter3(posDepth_s(:,1),posDepth_s(:,2),posDepth_s(:,3),'r','filled');
% quiver3(posDepth_s(:,1),posDepth_s(:,2),posDepth_s(:,3),...
%     projectionsDepth(:,1),projectionsDepth(:,2),projectionsDepth(:,3),0,'r')

