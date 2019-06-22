function [M] = smoothModel(M, smoothrad, origin, mult)
%SMOOTHMODEL    Smooth a brain model.
%
%   For every vertex vx of a given model M, this function finds all the
%   vertices vxd for which distance(vxd, vx) < smoothrad; from these vertices
%   vxd, only those vertices vxd2 that are far enough from the origin are used
%   for the final vx value vxnew = mean(vxd2). All vertices whose distance >
%   distfe are considered to be "far enought" from the origin according to the
%   parameter mult as follows:
%       med = median(distances);
%       maxv = max(distances);
%       distfe = med + (maxv - med) * mult;
%   Using mult = 0 : Only those vertices (that are to be found inside the 
%   radius sphere of a vertex) - whose distance is the median of the 
%   distances of all such vertices - will be used for the averaging.
%   For a model of the human brain, in order to flatten the model
%   reasonably (considering that the sulci should be removed), one should 
%   set mult to about mult = 0.5 so that the brain gets flattened at the half 
%   of the [median of the distances and the maximum of the distances].
%
%
%   CALLING SEQUENCE:
%      M = smoothModel(M, smoothrad, origin, mult)
%
%   INPUT:
%       M:          struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model
%       smoothrad:  the radius of the smoothing as defined above
%       origin:     the distance of the vertices from the coordinate system origin is computed relative to this origin
%
%   OUTPUT:
%       M:          struct('vert', Vx3matrix, 'tri', Tx3matrix) - smoothed brain model
%
%   REMARK:
%       The output model has the same number of triangles - the triangles that
%       had been part of a sulci prior to the smoothing will build dense
%       clusteres of triangles on the smoothed surface. Therefore,
%       coarserModel can be used to make the triangle density spatial
%       distribution more even.
%
%   Example:
%      M = smoothModel(M, 25, [0 10 20], 0.5);
%           for a brain model, starting with smoothrad > 40, the brain deforms;
%           values smoothrad < 10 lead to an insufficient number of vertices for the
%           averaging, which produces artifacts, too.
%           
%   See also DEMO, HULLMODEL, COARSERMODEL, FINERMODEL.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.


vert = M.vert;
Vv = length(vert);
smoothrad2 = smoothrad ^ 2;
vxd = zeros(1, Vv); %preallocation
vxd2 = zeros(1, Vv); %preallocation
dvect = zeros(1, Vv); %does not improve speed

fprintf('Smoothing the model...');
for vx = 1 : Vv,
       %Compute the distance of all vertices from the vertex being processed
       for vxda = 1 : Vv,
           %compute the distance and store into a vector dvect
           delta = vert(vx, :) - vert(vxda, :);
           dvect(vxda) = delta * delta';
       end
       vxd = find(dvect < smoothrad2);
       L = length(vxd);
       dvect = zeros(1, Vv); %does not improve speed
       for k = 1 : L,
           %compute the distance from the origin
           delta = vert(vxd(k), :) - origin;
           dvect(k) = delta * delta';
       end
       med = median(dvect(1 : L));
       maxv = max(dvect(1 : L));       
       dist = med + (maxv - med) * mult;
       vxd2 = find(dvect(1 : L) > dist);
       
       vxnew = mean(vert(vxd(vxd2), :));
       M.vert(vx, :) = vxnew; %update M
end
fprintf('done\n');