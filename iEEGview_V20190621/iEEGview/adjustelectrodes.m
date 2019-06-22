function adjustelectrodes(subjdir)
%
% Use this function if the automatic electrode projection doesn't do a good
% enough job. 
%
% subjdir is the full path to the subject directory
% subjmatfile file name of the subject's .mat file in its MATLAB/
% sub-directory.
% assumes standard directory structure and that 

fprintf('Open the point set for your ordered electrodes in freeview.\n');
fprintf('Step through the coronal slices using the page up and page down\n');
fprintf('keys, clicking and dragging the obscured electrodes to the\n');
fprintf('cortical surface as you do so.\n\n');

fprintf('When finished, save the point set and hit enter in this window.\n\n');
input('');

% import electrodes as adjustedelectrodes.mat
elecdatfile = strcat(subjdir, '/Electrodes/elecPointSet.dat');

elecMatrix = importelectrodes(elecdatfile);
save(strcat(subjdir, '/Electrodes/projelectrodes.mat'), 'elecMatrix');

fprintf('The adjusted electrodes have been saved as projelectrodes.mat\n');
fprintf('in your subject''s Electrodes sub-directory.\n\n');

fprintf('Use plotusingmatlab with the pathToElectrodes argument set to\n');
fprintf('<subjdir>/Electrodes/projelectrodes.mat in order to view the\n');
fprintf('adjusted electrodes in MATLAB and to save the adjusted and\n');
fprintf('coordinate system transformed electrodes in tala.electrodes.\n');
end

