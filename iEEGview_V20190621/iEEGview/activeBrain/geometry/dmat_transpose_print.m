function dmat_transpose_print ( m, n, a, title )

%% DMAT_TRANSPOSE_PRINT prints a double precision matrix, transposed.
%
%  Modified:
%
%    10 August 2004
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer M, N, the number of rows and columns.
%
%    Input, real A(M,N), an M by N matrix to be printed.
%
%    Input, character ( len = * ) TITLE, an optional title.
%
  dmat_transpose_print_some ( m, n, a, 1, 1, m, n, title );