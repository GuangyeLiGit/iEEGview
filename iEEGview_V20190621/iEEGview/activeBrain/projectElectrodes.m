function [ subjstructs, M ] = projectElectrodes(handles, M, subjstructs, normway, interstype, intersval)
%PROJECTELECTRODES  Project electrode grids onto a brain model.
%
%   Projects the electrode grids (for every subject they are specified by 
%   a structure and the field of these structures builds subjstructs) onto
%   the model M.
%
%   The altered subjstructs is required by the electrodesContributions( M,
%   subjstructs, kernel, param, cutoff) function.
%
%   This procedure also allows to add the intersecting vertices and
%   triangles resulting from the projection onto the model M (see also NOTE below).
%
%
%   CALLING SEQUENCE:
%   [ subjstructs ] = projectElectrodes( M, subjstructs, normway, interstype, intersval)
%
%   [ subjstructs ] = projectElectrodes( M, subjstructs, normway )
%           is equivalent to
%   [ subjstructs ] = projectElectrodes( M, subjstructs, normway, '' )
%
%   INPUT:
%       M:              struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model 
%       subjstructs:    field of structures, for each subject: struct('electrodes', Nsubjx3matrix)
%       normway:        controls the way the normal vector to the surface is computed
%           possible values: [x, y, z] - every electrode is projected onto the surface using the normal vector line [electrode - [x, y, z]]
%                            normdist (double) - only those vertices vert whose distance(vert, electrode) < normdist are used to compute the average normal vector from the normals at these vertices
%       interstype:     controls the way near triangles are obtained to compute the intersections
%           possible values: '' [default] - all triangles of the model are processed
%                            'fixed' - specify a radius intersval (see below)
%                            'multipl' - the distance mindist of the closest vertex to an electrode is multiplied by intersval to obtain intersdist; all triangles of vertices vert for which distance(vert, electrode) < intersdist will then be used for the line x triangle intersection algorithm (i.e. electrode projection onto the cortex)
%       intersval:      please refer to interstype 
%
%       Remark: if interstype ~= '' and if for an electrode no intersections
%       can be found, please change interstype or increase intersval.
%
%   OUTPUT:
%       subjstructs:    field of structures for each subject: struct('electrodes', Nsubjx3matrix, 'trielectrodes', Nsubjx1matrix) - enhanced subjstructs where 'trielectrodes' are are the projected electrode coordinates
%       M:              (now redundant, see NOTE below) struct('vert', Vx3matrix, 'tri', Tx3matrix) - altered brain model (electrode intersections added as new vertices and resulting triangles)
%
%   NOTE:
%       The PROJECTION PART (see code below) has been commented out because
%       the addition of new vertices and triangles at the intersection points creates
%       shading artifacts (the intersected triangle is more apparent because it
%       is now 3x finer than the surrounding ones). When commented out, the
%       model M is not altered; however, if one is about to use a coarse M, one
%       might want to activate this part of the code and return M because one might
%       want to see the exact value of the electrode at that point
%       (for fine models M, the values at near vertices are almost identical
%       with the one that would be projected).
%
%   Example:
%       [ subjstructs ] = projectElectrodes( M, subjstructs, 25)
%           projection using the surrounding normal vectors; most commonly used for models
%           that contain low number of vertices (< 10000) - every brain
%           model can be reduced to about this number without affecting the
%           accuracy of the projection - and this is normally done (see
%           also demo.m)
%
%       [ subjstructs ] = projectElectrodes( M, subjstructs, [0 -10 20])
%           projection towards the center point - this is faster than using
%           the normals but is less accurate - a brain model is not a
%           perfect sphere with an origin
%
%       [ subjstructs ] = projectElectrodes( M, subjstructs, 25, 'fixed', 20)
%           projection using the surrounding normal vectors, using fixed distance for
%           reducing the number of considered triangles and thus speeding
%           up the projection
%
%       [ subjstructs ] = projectElectrodes( M, subjstructs, [0 -10 20], 'multipl', 5)
%           projection towards the center point, using flexible distance for
%           reducing the number of considered triangles and thus speeding
%           up the projection
%
%   See also DEMO, ELECTRODESCONTRIBUTIONS, ACTIVATEBRAIN, COARSERMODEL, SMOOTHMODEL, HULLMODEL.

%   Author: Jan Kubanek
%   Institution: Wadsworth Center, NYSDOH, Albany, NY
%   Date: August 2005
%   This procedure is a part of the NeuralAct Matlab package.
%   Updated by Guangye Li @2018.03.22 @SH @liguangye.hust@Gmail.com


if nargin < 5,
    interstype = '';
end

%THE LOOP FOR ALL ELECTRODES OF ALL SUBJETS-------------
fprintf('Projecting electrodes:\n');
tmptext = get(handles.edit_State,'string');
tmptext{end+1} = ['Projecting electrodes:'];
fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
Ss = length(subjstructs);
Vv = length(M.vert);
Tt = length(M.tri);

for subj = 1 : Ss,
    fprintf('   processing subject %d\n', subj);
    tmptext = get(handles.edit_State,'string');
    tmptext{end+1} = ['   processing subject ',subj];
    fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
    set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
   Ee = size(subjstructs(subj).electrodes, 1);
   subjstructs(subj).trielectrodes = [];
   
   for eg = 1 : Ee,
        fprintf('      processing electrode %d\n', eg);
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['      processing electrode ',num2str(eg)];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
%compute the distance of all vertices from the electrode being processed
        fprintf('           computing the distance from the electrode for all vertices\n');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['           computing the distance from the electrode for all vertices...'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
        dvect = zeros(1, Vv);
       vert = M.vert; %reallocate to speed up the loop
       electrode = subjstructs(subj).electrodes(eg, :); %reallocate to speed up the loop
       for v = 1 : Vv,
           %compute the distance ||eg - v||^2 and store into a vector dvect
           delta = electrode - vert(v, :);
           dvect(v) = delta * delta';
       end


%NORMAL VECTOR PART------------------------------------
%normal vector computation (computation of line points p1 and p2):
       fprintf('           computing the normal vector\n');
        tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['           computing the normal vector...'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
       if length(normway) == 1, %the normdist is specified, compute average normals from near vertices
           normdist = normway;
           closevert = find(dvect < normdist^2);
           if isempty(closevert),
               error('The normdist distance from electrode %d of subject %d to compute the normal vector is too large', eg, subj);
           end
       
       %compute the normal vector
           %surf the brain so that the normals get computed:
           if verLessThan('matlab', '8.4'), %<= R2014a
               h = trisurf(M.tri, M.vert(:, 1), M.vert(:, 2), M.vert(:, 3), 'FaceVertexCData', 1, 'LineStyle', 'none');
               normals = get(h, 'VertexNormals');
               close(gcf);
           else %>= R2014b
               tr = triangulation(M.tri, M.vert);
               [~, MSGID] = lastwarn();
               if ~isempty(MSGID)
               warning('off', MSGID);
               end
               normals = vertexNormal(tr);
           end
           normals2av = normals(closevert, :);
           [row, col] = find(isnan(normals2av)); %find NaN values
           normals2av(row, :) = []; %and remove them
           if length(normals2av) < 1,
               error('There is less than one normal vector used for the normal vector averaging, please increase the parameter normway to more than %d', normway);
               normal = [NaN, NaN, NaN];
           else
               normal = mean(normals2av, 1);
           end
           p1 = subjstructs(subj).electrodes(eg, :);
           p2 = p1 + normal;
       elseif length(normway) == 3,
           pointorig = normway(:)';
           p1 = subjstructs(subj).electrodes(eg, :);
           p2 = pointorig;
       else
           error('The attribute normway is specified incorrectly.');
       end

%INTERSECTION PART---------------------------------------
%compute close vertices
       switch interstype,
       case ''
       case 'fixed'
           intersdist2 = intersval^2; %fixed distance
       case 'multipl'     
           mindist = min(dvect);
           intersdist2 = intersval^2 * mindist(1);
       otherwise
           error('You have specified a wrong interstype string as an input to projectElectrodes.');       
       end

       if ~isempty(interstype),
           fprintf('           finding near vertices\n');
           tmptext = get(handles.edit_State,'string');
            tmptext{end+1} = ['           finding near vertices'];
            fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
            set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
           closevert = find(dvect < intersdist2);
           if isempty(closevert),
               error('The interdist distance from electrode %d of subject %d to compute the intersection is too large', eg, subj);
           end
           %sort the vertices with respect to the distance
           fprintf('           sorting the vertices\n');
           tmptext = get(handles.edit_State,'string');
            tmptext{end+1} = ['           sorting the vertices'];
            fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
            set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
           [closevertsort, dvecti] = sort(dvect(closevert));
           sortvert = closevert(dvecti);
           %find all triangles sorttri that contain at least one sortvert vertex
           tri = M.tri; %tri will be altered
           sorttri=[];
           Lcv = length(sortvert);
           fprintf('           finding near triangles\n');
           tmptext = get(handles.edit_State,'string');
            tmptext{end+1} = ['           finding near triangles'];
            fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
            set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
           for k = 1 : Lcv,
               cv = sortvert(k);
               [rows, columns] = find(tri == cv);
               sorttri = [sorttri; rows];
               tri(rows, :) = 0; %assign zero so that they're not added again
           end
       else %in case interstype == '', use all triangles:
           sorttri = 1 : Tt;
       end           
%----------------      
%compute the intersection with the triangles
       fprintf('           computing the intersection with the triangles\n');
       tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['           computing the intersection with the triangles...'];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
       Lct = length(sorttri);
       inside = 0;
       intersects = zeros(Lct, 4); ix = 1; %these lines are used for interstype == ''
       for k = 1 : Lct,
           tr = M.tri(sorttri(k), :);
           t = [M.vert(tr(1), :); M.vert(tr(2), :); M.vert(tr(3), :)]';
           [ inside, pint ] = triangle_contains_line_exp_3d ( t, p1, p2 );
           if inside,
               if ~isempty(interstype),               
                   break; %jump out of the loop
               else %these lines are used for interstype == ''
                   intersects(ix, :) = [pint(:)', k];
                   ix = ix + 1;               
               end
           end
       end
       
       if ~isempty(interstype),
           if ~inside,
                error('The intersection was not found');
           end
       else %these lines are used for interstype == ''
           ics = find(intersects(:, 4) == 0);
           intersects(ics, :) = [];
       
           if isempty(intersects),
               error('Electrode %d of subject %d does not project on the brain', eg, subj);
           end

           %if there are more intersecting points, select the closest to the
           %electrode:
           Si = size(intersects, 1);
           distv = zeros(Si, 1);
           for z = 1 : Si,
               delta = intersects(z, 1 : 3) - p1;
               distv(z) = delta * delta';
           end       
           [mval, mix] = min(distv);
           pint = intersects(mix, 1 : 3); %the electrode projection point
       end
       
       pint = pint(:)';
       
       disp('           (original electrode coordinates)'); disp(p1);
       disp('           (projected electrode coordinates)'); disp(pint);
       tmptext = get(handles.edit_State,'string');
        tmptext{end+1} = ['           (original electrode coordinates): ' num2str(p1)];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        tmptext{end+1} = ['           (projected electrode coordinates): ' num2str(pint)];
        fprintf(handles.ProcessState,[tmptext{end} '\r\n']);
        set(handles.edit_State,'string',tmptext(max(length(tmptext)-7,1):end));pause(0.001);
    
%PROJECTION PART-----------------------------     
%Project the electrode (i.e. set it to pint):
       subjstructs(subj).trielectrodes(eg, :) = pint;       

       
%Please activate the following code if you wish to return a model M that contains the intersecting points and triangles:
       %store the intersecting point to the list of vertices:
%       tint = k; %index of the triangle being intersected
%       M.vert = [M.vert; pint];
%       Vv2 = length(M.vert); %last vertex index
       %create 3 new resulting triangles:
%       p1 = M.tri(tint, 1);        %the triangle edge indices
%       p2 = M.tri(tint, 2);        %the triangle edge indices
%       p3 = M.tri(tint, 3);        %the triangle edge indices
       %new triangles:
%       t1 = [Vv2, p2, p1];
%       t2 = [Vv2, p3, p2];
%       t3 = [Vv2, p1, p3];
       %store them:
%       M.tri = [M.tri; t1; t2; t3];
       %remove the original triangle (it becomes redundant, when split into the 3)
%       M.tri(tint, :) = [];
   end
end