function [ inside, pint ] = triangle_contains_line_exp_3d ( t, p1, p2 )
%% TRIANGLE_CONTAINS_LINE_EXP_3D finds if a line is inside a triangle in 3D.
%
%  Discussion:
%
%    A line will "intersect" the plane of a triangle in 3D if
%    * the line does not lie in the plane of the triangle
%      (there would be infinitely many intersections), AND
%    * the line does not lie parallel to the plane of the triangle
%      (there are no intersections at all).
%
%    Therefore, if a line intersects the plane of a triangle, it does so
%    at a single point.  We say the line is "inside" the triangle if,
%    regarded as 2D objects, the intersection point of the line and the plane
%    is inside the triangle.
%
%    The explicit form of a line in 3D is:
%
%      the line through the points P1, P2.
%
%    The algorithm is based in part on a note titled
%    "CS465 Notes: Simple Ray-Triangle Intersection" by Steve Marschner,
%    of Cornell University.
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
%    Input, real T(NDIM,3), the triangle vertices.
%    The vertices should be given in counter clockwise order.
%
%    Input, real P1(NDIM), P2(NDIM), two points on the line.
%
%    Output, logical INSIDE, is TRUE if the line is inside the triangle.
%
%    Output, real PINT(NDIM), the point where the line
%    intersects the plane of the triangle.
%
  ndim = 3;
%
%  Make sure the line is not degenerate.
%
  if ( line_exp_is_degenerate_nd ( ndim, p1, p2 ) )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'TRIANGLE_CONTAINS_LINE_EXP_3D - Fatal error!\n' );
    fprintf ( 1, '  The explicit line is degenerate.\n' );
    error ( 'TRIANGLE_CONTAINS_LINE_EXP_3D - Fatal error!' );
  end
%
%
%  Make sure the triangle is not degenerate.
%
  if ( triangle_is_degenerate_nd ( ndim, t ) )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'TRIANGLE_CONTAINS_LINE_EXP_3D:\n' );
    fprintf ( 1, '  The triangle is degenerate.\n' );
    t
    inside = 0;
%    pint = [NaN, NaN, NaN];
%    return;
    error ( 'TRIANGLE_CONTAINS_LINE_EXP_3D - Fatal error!' );
  end
%
%  Determine a unit normal vector associated with the plane of
%  the triangle.
%
  v1(1:ndim) = t(1:ndim,2) - t(1:ndim,1);
  v2(1:ndim) = t(1:ndim,3) - t(1:ndim,1);

  normal(1) = v1(2) * v2(3) - v1(3) * v2(2);
  normal(2) = v1(3) * v2(1) - v1(1) * v2(3);
  normal(3) = v1(1) * v2(2) - v1(2) * v2(1);

  temp = sqrt ( sum ( normal(1:ndim).^2 ) );
  normal(1:ndim) = normal(1:ndim) / temp;
%
%  Find the intersection of the plane and the line.
%
  [ ival, pint ] = ...
    plane_normal_line_exp_int_3d ( t(1:ndim,1)', normal, p1, p2 );

  if ( ival == 0 )
    inside = 0;
    pint(1:ndim) = inf;
    return
  elseif ( ival == 2 )
    inside = 0;
    pint(1:ndim) = p1(1:ndim);
    return
  end
%
%  Now, check that all three triangles made by two vertices and
%  the intersection point have the same "clock sense" as the
%  triangle's normal vector.
%
  v1(1:ndim) = t(1:ndim,2)  - t(1:ndim,1);
  v2(1:ndim) = pint(1:ndim) - t(1:ndim,1)';

  normal2(1) = v1(2) * v2(3) - v1(3) * v2(2);
  normal2(2) = v1(3) * v2(1) - v1(1) * v2(3);
  normal2(3) = v1(1) * v2(2) - v1(2) * v2(1);

  if ( normal(1:ndim) * normal2(1:ndim)' < 0.0 )
    inside = 0;
    return
  end

  v1(1:ndim) = t(1:ndim,3)  - t(1:ndim,2);
  v2(1:ndim) = pint(1:ndim) - t(1:ndim,2)';

  normal2(1) = v1(2) * v2(3) - v1(3) * v2(2);
  normal2(2) = v1(3) * v2(1) - v1(1) * v2(3);
  normal2(3) = v1(1) * v2(2) - v1(2) * v2(1);

  if ( normal(1:ndim) * normal2(1:ndim)' < 0.0 )
    inside = 0;
    return
  end

  v1(1:ndim) = t(1:ndim,1)  - t(1:ndim,3);
  v2(1:ndim) = pint(1:ndim) - t(1:ndim,3)';

  normal2(1) = v1(2) * v2(3) - v1(3) * v2(2);
  normal2(2) = v1(3) * v2(1) - v1(1) * v2(3);
  normal2(3) = v1(1) * v2(2) - v1(2) * v2(1);

  if ( normal(1:ndim) * normal2(1:ndim)' < 0.0 )
    inside = 0;
    return
  end

  inside = 1;