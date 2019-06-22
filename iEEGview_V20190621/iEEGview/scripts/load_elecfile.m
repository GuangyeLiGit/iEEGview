
function load_elecfile(electrodesDirectory)
electrodesvtk = dir(strcat(electrodesDirectory, '/*.vtk'));

% converts .vtk file into matlab-compatible matrix
electrodesSurf = importisosurface(strcat(electrodesDirectory, '/', electrodesvtk.name));

% displays electrodes surfaces in matlab
trisurf(electrodesSurf.triangles, electrodesSurf.vertices(:,1), electrodesSurf.vertices(:,2), electrodesSurf.vertices(:,3));

% start electrode numbering script and store data points
% saves the data as a matrix in a .mat file for use with activate brain
[elecMatrix,elecInfo] = sortelec();
save(strcat(electrodesDirectory, '/', 'electrode_raw.mat'), 'elecInfo','elecMatrix');

% saves the electrode data as a point set for use in freeview
elecFileName = strcat(electrodesDirectory, '/elecPointSet.dat');
fileID = fopen(elecFileName, 'w+');

% writes the coordinates and header info to a .dat file so the clicked
% electrodes can be opened in freeview
for i = 1:size(elecMatrix, 1)
    fprintf(fileID, '%.4f %.4f %.4f\n', elecMatrix(i, :));
end

fprintf(fileID, '%s\n', 'info');
fprintf(fileID, '%s %u\n', 'numpoints', size(elecMatrix, 1));
fprintf(fileID, '%s\n', 'useRealRAS 1');

disp('The ordered electrodes have now been saved in');
disp('the subject directory in the Electrodes folder');
disp('as electrodes.mat. To view the brain and its');
disp('electrodes you can use the function plotusingmatlab()');
disp('or you can load the point set called elecPointSet.dat');
disp('into freeview along with one of the brains volumes');
disp('and its pial surfaces.');
end