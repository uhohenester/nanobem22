function n = ndof( obj )
%  NDOF - Number of degrees of freedom.
%
%  Usage for obj = BoundaryVert :
%    n = ndof( obj )
%  Output
%    n    :  number of degrees of freedom

n = max( horzcat( obj.nu ) );
