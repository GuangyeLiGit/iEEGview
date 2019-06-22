function M = finerModel(M, level)
%FINERMODEL  Make a brain model finer by adding centroids of its triangles as new vertices.
%
%   The centroid of a triangle is the intersection of the medians. A median
%   of a triangle is a line connecting any vertex to the midpoint of the
%   opposite side. The centroid might be considered as the "center of gravity".
%
%   The procedure is called recursively for level times.
%
%
%   CALLING SEQUENCE:
%       M = finerModel(M, level)
%
%   INPUT:
%       M:       struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model
%           (M is the invariant of the recursion)
%       level:   recursively repeat the procedure level times to obtain finer models
%           (level is the variant of the recursion)
%
%   OUTPUT:
%       M:       struct('vert', Vx3matrix, 'tri', Tx3matrix) - finer brain model
%
%   REMARK:
%       This procedure does not really make the model finer - it only adds
%       vertices as the triangle centroids - this may be useful when one
%       has a coarse brain model and still needs to display nice
%       activations (so that they do not look as triangles).
%
%   Example:
%       M = finerModel(M, 2);
%           runs finerModel twice to achieve quadruple vertex density
%
%   See also DEMO, COARSERMODEL, SMOOTHMODEL, HULLMODEL.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.


disp(sprintf('Level of recursion: %d', level));
%recursion code, Matlab 6.5 JIT accelerator processed:
    Tt = length(M.tri);
    tri = zeros(3 * Tt, 3); %every triangle will be broken into 3 ones
    Vv = length(M.vert);
    vert = zeros(Vv + Tt, 3); %one new centroid per triangle
    vert(1 : Vv, :) = M.vert;
    for k = 1 : Tt,
        tr = M.tri(k, :);
        t = [vert(tr(1), :); vert(tr(2), :); vert(tr(3), :)];
        pint = (t(1, :) + t(2, :) + t(3, :)) / 3; %the centroid, JIT code
        VI = Vv + k; %last vertex index
        vert(VI, :) = pint;
        %create 3 new resulting triangles:
        p1 = tr(1);        %the triangle edge indices
        p2 = tr(2);        %the triangle edge indices
        p3 = tr(3);        %the triangle edge indices
        %new triangles:
        t1 = [VI, p2, p1];
        t2 = [VI, p3, p2];
        t3 = [VI, p1, p3];
        %store them:
        tri(3 * (k - 1) + 1 : 3 * k, :) = [t1; t2; t3];
    end
    M.tri = tri; %use only the newly created triangles
    M.vert = vert; %add the centroids to the set of vertices

if level > 1,
    M = finerModel(M, level - 1); %recursive call
end