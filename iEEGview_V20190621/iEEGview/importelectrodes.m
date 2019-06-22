function elecmatrix = importelectrodes(electrodesFileName)
% This function reads electrode coordinates out of a .dat file as
% produced by saving a point set in Freesurfer.
% Coordinates are loaded into electrodes.coordinates
% originFileName is an old and unneeded argument

electrodesFileID = fopen(electrodesFileName);

% Skip to number of electrodes and store it
fscanf(electrodesFileID, '%f');
numberOfElectrodes = fscanf(electrodesFileID, '%*s \n %*s %u');

elecmatrix = zeros(numberOfElectrodes, 3);

fclose(electrodesFileID);
electrodesFileID = fopen(electrodesFileName);

for electrodeNumber = 1:numberOfElectrodes
    elecmatrix(electrodeNumber, :) = transpose(fscanf(electrodesFileID, '%f', 3));
end

end