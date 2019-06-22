function [ Mout ] = transformBrain( Min, t_struct, s_struct, r_struct, phi )
%TRANSFORMBRAIN    Transform all vertices of a brain model.
%
%   Translation, rotation and scaling is supported by setting the arguments
%   appropriately - see transf3Dmatrix for the t_struct, s_struct,
%   r_struct, phi arguments.
%
%
%   CALLING SEQUENCE:
%       [ Mout ] = transformBrain( Min, t_struct, s_struct, r_struct, phi )
%
%   INPUT:
%       Min:    struct('vert', Nx3matrix, ...) - brain model
%       see transf3Dmatrix for the t_struct, s_struct, r_struct, phi arguments
%
%   OUTPUT:
%       Mout:   struct('vert', Nx3matrix, ...) - transformed brain model
%
%   Example:
%       t_struct.x = 10;
%       t_struct.y = 20;
%       t_struct.z = 30;
%
%       s_struct.x = 1.1;
%       s_struct.y = 1.2;
%       s_struct.z = -1.4;
%
%       r_struct.x = 1;
%       r_struct.y = 0;
%       r_struct.z = 0;
%       phi = pi/4;
%
%       [ Mout ] = transformBrain( Min, t_struct, s_struct, r_struct, phi );
%
%   See also TRANSF3DMATRIX.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.


p = Min.vert;
S = size(p);
if S(2) < S(1), p = p'; end
p(4, :) = 1;

[ M ] = transf3Dmatrix( t_struct, s_struct, r_struct, phi );

p = M * p;

Mout = Min;
Mout.vert = p';