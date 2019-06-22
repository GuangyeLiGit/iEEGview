function [trans_matrix]=Read_Transform_Matrix(subject_directory)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function is used to get the transformation matrix for the
%%% normalization. Make sure that the brain model segmentation files 
%%% are saved within the path.
%%% Author: Guangye Li (liguangye.hust@gmail.com)@2018.02.20 @USA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename=[subject_directory,'/Segmentation/mri/transforms/talairach.xfm'];
if ~exist(filename)
    error('Transformation Matrix missing~~, Please check!');
end
 
filenametxt=[subject_directory,'/Segmentation/mri/transforms/talairach.txt'];
copyfile(filename,filenametxt);
stamp = 'Linear_Transform';  
dt = [];
fds = 0;        
fid = fopen(filenametxt);
while ~feof(fid)
    tline = fgetl(fid);
    if fds==1
        dt = [dt; str2num(tline)];
    else
        if length(tline)>16
           fds=strcmp(stamp,tline(1:16));
        end
    end
    
end
fclose(fid);
trans_matrix=dt;
end
