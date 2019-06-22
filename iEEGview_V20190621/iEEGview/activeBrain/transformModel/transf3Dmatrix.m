function [ Mx ] = transf3Dmatrix( t_struct, s_struct, r_struct, phi )
%TRANSF3DMATRIX    Compute general 3D transformation matrix.
%
%   The resulting matrix allows scaling, translation and rotation around an
%   arbitrary vector.
%   The resulting 3D transformation matrix dimension is (3 x 4), allowing
%   translation when multiplied by a point [x; y; z; 1].
%
%   CALLING SEQUENCE:
%       [ Mx ] = transf3Dmatrix( t_struct, s_struct, r_struct, phi )
%
%   INPUT:
%       all input structures of type struct('x', xval, 'y', yval, 'z', zval)
%       phi:        double (angle in rad)
%
%   OUTPUT:
%       Mx:          the resulting 3D transformation matrix (3 x 4)
%
%   REMARKS:
%       rotation about any arbitrary axis:
%       phi is the angle to rotate about the r_struct(x, y, z) vector,
%       clockwise when looking in the (x, y, z) direction
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
%       [ Mx ] = transf3Dmatrix( t_struct, s_struct, r_struct, phi );
%
%   See also TRANSFORMBRAIN.

%   Author: Jan Kubanek
%   Institution: Czech Technical University in Prague
%   Date: August 2005
%   This procedure is a part of the activeBrain Matlab package which was
%   designed for internal purposes of the BCI group at the Wadsworth Institute,
%   Albany, NY.


xt = t_struct.x;
yt = t_struct.y;
zt = t_struct.z;

xs = s_struct.x;
ys = s_struct.y;
zs = s_struct.z;

x = r_struct.x;
y = r_struct.y;
z = r_struct.z;

c = cos(phi);
s = sin(phi);
t = 1 - cos(phi);

Mx = ...
[xs * (t*x*x + c),	t*x*y - s*z,        t*x*z + s*y,    	xt;...
 t*x*y + s*z,       ys * (t*y*y + c),	t*y*z - s*x,        yt;...
 t*x*z - s*y,       t*y*z + s*x,    	zs * (t*z*z + c),	zt];