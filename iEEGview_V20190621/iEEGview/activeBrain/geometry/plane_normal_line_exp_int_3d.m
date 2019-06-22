function [ ival, pint ] = plane_normal_line_exp_int_3d ( pp, normal, p1, p2 )
%% PLANE_NORMAL_LINE_EXP_INT_3D intersection of plane and line in 3D.
%
%  Discussion:
%
%    The normal form of a plane in 3D is:
%
%      PP is a point on the plane,
%      N is a normal vector to the plane.
%
%    The explicit form of a line in 3D is:
%
%      P1, P2 are two points on the line.
%
%  Modified:
%
%    07 May 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real PP(3), a point on the plane.
%
%    Input, real NORMAL(3), a normal vector to the plane.
%
%    Input, real P1(3), P2(3), two distinct points on the line.
%
%    Output, integer IVAL, the kind of intersection;
%    0, the line and plane seem to be parallel and separate;
%    1, the line and plane intersect at a single point;
%    2, the line and plane seem to be parallel and joined.
%
%    Output, real PINT(3), the coordinates of a
%    common point of the plane and line, when IVAL is 1 or 2.
%
  ndim = 3;
%
%  Make sure the line is not degenerate.
%
  if ( line_exp_is_degenerate_nd ( ndim, p1, p2 ) )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'PLANE_NORMAL_LINE_EXP_INT_3D - Fatal error!\n' );
    fprintf ( 1, '  The line is degenerate.\n' );
    error ( 'PLANE_NORMAL_LINE_EXP_INT_3D - Fatal error!' );
  end
%
%  Make sure the plane normal vector is a unit vector.
%
  temp = sqrt ( sum ( normal(1:ndim).^2 ) );

  if ( temp == 0.0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'PLANE_NORMAL_LINE_EXP_INT_3D - Fatal error!\n' );
    fprintf ( 1, '  The normal vector of the plane is degenerate.\n' );
    error ( 'PLANE_NORMAL_LINE_EXP_INT_3D - Fatal error!' );
  end

  normal(1:ndim) = normal(1:ndim) / temp;
%
%  Determine the unit direction vector of the line.
%
  direction(1:ndim) = p2(1:ndim) - p1(1:ndim);
  temp = sqrt ( sum ( direction(1:ndim).^2 ) );
  direction(1:ndim) = direction(1:ndim) / temp;
%
%  If the normal and direction vectors are orthogonal, then
%  we have a special case to deal with.
%
  if ( normal(1:ndim) * direction(1:ndim)' == 0.0 )

    temp = normal(1:ndim) * ( p1(1:ndim) - pp(1:ndim) )';

    if ( temp == 0.0 )
      ival = 2;
      pint(1:ndim) = p1(1:ndim);
    else
      ival = 0;
      pint(1:ndim) = inf; %value of infinity
    end

    return
  end
%
%  Determine the distance along the direction vector to the intersection point.
%
  temp = ( ( pp(1:ndim) - p1(1:ndim) ) * normal(1:ndim)' )...
    /  ( direction(1:ndim) * normal(1:ndim)' );

  ival = 1;
  pint(1:ndim) = p1(1:ndim) + temp * direction(1:ndim);