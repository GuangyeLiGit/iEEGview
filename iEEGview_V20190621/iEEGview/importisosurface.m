function isosurface = importisosurface(vtkFileName, handles, originFileName)
% This function takes a .vtk file (version 3.0) and loads its information
% into a data structure (isosurface) usable by activateBrain.
% The coordinates for each vertex are loaded into isosurface.vertices
% The indices of the vertices forming each triangle are loaded into
% isosurface.triangles 
% originFileName is the name of the file which is used to transform the
% coordinates reported by Freesurfer into Talairach coordinates.

% Finds the Freesurfer coordinates of the Talairach origin
if nargin == 3
    origin = importelectrodes(originFileName);
end

vtkFileID = fopen(vtkFileName);

% Moves fscanf up to the number of vertices
fscanf(vtkFileID, '%s', 11);

% Gets the number of vertices and makes array for their storage
numberOfVertices = fscanf(vtkFileID, '%u', 1);
isosurface.vertices = zeros(numberOfVertices, 3);

% Moves fscanf up to the vertex coordinates
fscanf(vtkFileID, '%s', 1);

% Progress monitor
percentMilestones = [10:10:100];
fprintf('Reading vertex coordinates...\n');
fprintf('Percent complete: ');
% c
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Reading vertex coordinates...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))


for vertexNumber = 1:numberOfVertices
    % Reads from file the vertex data for one vertex and puts it into array
    temporaryCoordinatesHolder = transpose(fscanf(vtkFileID, '%f', 3));
    isosurface.vertices(vertexNumber, :) = temporaryCoordinatesHolder;
    
    % Progress monitor
    percentDone = 100 * vertexNumber / numberOfVertices;
    if percentDone >= percentMilestones(1)
        fprintf('%u ', percentMilestones(1));
        percentMilestones = percentMilestones(2:end);
    end
end


% Moves the isosurface into Talairach coordinates based on the origin
% provided as second argument
if nargin == 3
    isosurface.vertices = [isosurface.vertices(:,1) - origin.coordinates(1), isosurface.vertices(:,2) - origin.coordinates(2), isosurface.vertices(:,3) - origin.coordinates(3)];
end

fprintf('\n');
str = fscanf(vtkFileID, '%s', 1);

% Moves fscanf up to the number of triangles
while ~strcmp(str, 'POLYGONS')
    str = fscanf(vtkFileID, '%s', 1);
end

% Gets the number of triangles and makes array for their storage
numberOfTriangles = fscanf(vtkFileID, '%u', 1);
isosurface.triangles = zeros(numberOfTriangles, 3);

% Moves fscanf up to the triangles (indices of vertices)
fscanf(vtkFileID, '%u', 1);

% Progress monitor
percentMilestones = [10:10:100];
fprintf('Reading triangles...\n');
fprintf('Percent complete: ');
% c
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Reading triangles...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
tmptext{end+1} = [];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end))

for triangleNumber = 1:numberOfTriangles
    % Moves fscanf up to the important info
    fscanf(vtkFileID, '%u', 1);
    
    % Reads from file the information for one triangle
    temporaryVertexHolder = transpose(fscanf(vtkFileID, '%u', 3));
    % Plus one because activateBrain/matlab code expects 1-based array
    isosurface.triangles(triangleNumber, :) = temporaryVertexHolder + 1;
    
    % Progress monitor
    percentDone = 100 * triangleNumber / numberOfTriangles;
    if percentDone >= percentMilestones(1)
        fprintf('%u ', percentMilestones(1));
        percentMilestones = percentMilestones(2:end);
    end
end

fprintf('\n');

fclose(vtkFileID);
