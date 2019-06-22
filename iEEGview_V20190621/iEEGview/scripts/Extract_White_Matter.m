function Extract_White_Matter()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Extract the whitematter surface of brain
%%% Written by Li Guangye(liguangye.hust@gmail.com) @USA @2017.04.04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pathToLhPial = strcat('Segmentation\surf', '\lh.white');
pathToRhPial = strcat('Segmentation\surf', '\rh.white');

% make sure that the matlab folder inside the freesurfer folder is on the
% matlab path or else read_surf will be missing
[LHtempvert, LHtemptri] = read_surf(pathToLhPial);
[RHtempvert, RHtemptri] = read_surf(pathToRhPial);

% references to vert matrix must be 1-based
LHtemptri = LHtemptri + 1;
RHtemptri = RHtemptri + 1;

% all RH verts come after all LH verts
adjustedRHtemptri = RHtemptri + size(LHtempvert, 1);

leftwhite.vert= LHtempvert;
leftwhite.tri = LHtemptri;
rightwhite.vert= RHtempvert;
rightwhite.tri = RHtemptri;

white.vert = [LHtempvert; RHtempvert];

% put all tris in same matrix, with corrected RH tris
white.tri = [LHtemptri; adjustedRHtemptri];
save('MATLAB\Whitematter.mat','white','leftwhite','rightwhite');

end