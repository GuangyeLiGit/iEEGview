function value = triangle_is_degenerate_nd ( ndim, t )

%% TRIANGLE_IS_DEGENERATE_ND finds if a triangle is degenerate in ND.
%
%  Discussion:
%
%    A triangle in ND is described by the coordinates of its 3 vertices.
%
%    A triangle in ND is degenerate if any two vertices are equal.
%
%  Modified:
%
%    06 May 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer NDIM, the spatial dimension.
%
%    Input, real T(NDIM,3), the triangle vertices.
%
%    Output, logical VALUE, is TRUE if the triangle is degenerate.
%
  value = ~( ( any(t(1:ndim,1) - t(1:ndim,2)) ) & ...
             ( any(t(1:ndim,2) - t(1:ndim,3)) ) & ...
             ( any(t(1:ndim,3) - t(1:ndim,1)) ) );