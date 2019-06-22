function [M] = hullModel(M)
%HULLMODEL  Smooth a brain model by computing its convex hull.
%
%   The convex hull of a data set in n-dimensional space is defined as the
%   smallest convex region that contains the data set. For example, the convex
%   hull of a brain model results in a hull containing the whole brain
%   and touching the sulci
%
%
%   CALLING SEQUENCE:
%       M = hullModel(M)
%
%   INPUT:
%       M:          struct('vert', Vx3matrix, 'tri', Tx3matrix) - brain model
%
%   OUTPUT:
%       M:          struct('vert', Vx3matrix, 'tri', Tx3matrix) - smoothed brain model
%
%   Example:
%       M = hullModel(M);
%
%   See also DEMO, COARSERMODEL, FINERMODEL, SMOOTHMODEL, HULLMODEL.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.


M.tri = convhulln(M.vert);