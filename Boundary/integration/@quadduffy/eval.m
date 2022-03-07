function varargout = eval( obj, i1 )
%  EVAL - Evaluate integration points and basis functions.
%
%  Usage for obj = quadduffy :
%    [ pos, f, fp ] = eval( obj, i1 )
%  Input
%    i      :  evaluation for first or second boundary
%  Output
%    pos    :  integration positions
%    f      :  shape functions
%    fp     :  divergence of shape functions (only for edge elements)

switch class( obj.tau1 )
  case 'BoundaryVert'
    [ varargout{ 1 : nargout } ] = eval1( obj, i1 );
  case 'BoundaryEdge'
    [ varargout{ 1 : nargout } ] = eval2( obj, i1 );
end
