function value = line_exp_is_degenerate_nd ( ndim, p1, p2 )

%% LINE_EXP_IS_DEGENERATE_ND finds if an explicit line is degenerate in ND.
%
%  Discussion:
%
%    The explicit form of a line in ND is:
%
%      the line through the points P1, P2.
%
%    An explicit line is degenerate if the two defining points are equal.
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
%    Input, real P1(NDIM), P2(NDIM), two points on the line.
%
%    Output, logical VALUE, is TRUE if the line is degenerate.
%
  value = ( p1(1:ndim) == p2(1:ndim) );