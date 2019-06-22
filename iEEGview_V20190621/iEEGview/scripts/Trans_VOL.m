function [ xyzlab ] = Trans_VOL( VOL,ROI)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is written to translate the vol data into new coordinate
% system so that all the data can be plotted together in the same
% coordinate. 
% By Li GuangYe (liguangye.hust@gmail.com) @2017.04.08 @USA
% % VOL: original file
% ROI: ROI array
% xyzlab=coordinates of each ROI

xyzlab=[];
ROIindex=1:length(ROI);
for i=ROIindex
        indlab = find(VOL.vol==ROI(i));
        nlab = length(indlab);
        % Convert indices to row, col, slice
        [r c s] = ind2sub(size(VOL.vol),indlab);
        crs = [c r s]' ; 
        crs = [crs; ones(1,nlab)];
        
        % Convert row, col, slice to XYZ
        xyz1 = VOL.tkrvox2ras* crs;
        xyz = xyz1(1:3,:)';
        xyzlab=[xyzlab;xyz];
end

end

