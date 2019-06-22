function M = coarserModel(M, r,handles)
%COARSERMODEL   Make a brain model coarser by calling reducepatch.
%
%   reducepatch(M, r) reduces the number of faces of the patch identified by M,
%   while attempting to preserve the overall shape of the original object.
%   MATLAB interprets the reduction factor r in one of two ways depending on its value:
%   If r is less than 1, r is interpreted as a fraction of the original number of faces.
%   For example, if you specify r as 0.2, then the number of faces is reduced to 20% of the number in the original patch.
%   If r is greater than or equal to 1, then r is the target number of faces.
%   For example, if you specify r as 400, then the number of faces is reduced until there are 400 faces remaining.
%
%
%   CALLING SEQUENCE:
%       M = coarserModel(M, r)
%
%   INPUT:
%       M:   struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model
%       r:   the reduction factor as discussed above
%
%   OUTPUT:
%       M:       struct('vert', Vx3matrix, 'tri', Tx3matrix) - coarser brain model
%
%   Example:
%       M = coarserModel(M, 10000);
%           reduce the model to 10000 triangles
%       M = coarserModel(M, 0.1);
%           reduce the model to 10% of the original number of triangles
%
%   See also DEMO, SMOOTHMODEL, HULLMODEL, FINERMODEL.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.


Mf.faces = M.tri;
Mf.vertices = M.vert;

fprintf('Reducing the model...');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Reducing the model...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
pause(0.001);
Mf = reducepatch(Mf, r);
fprintf('done\n');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['done...'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));
pause(0.001);


M.tri = Mf.faces;
M.vert = Mf.vertices;