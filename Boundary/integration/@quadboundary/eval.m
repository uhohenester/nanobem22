function varargout = eval( obj, varargin )
%  EVAL - Evaluate integration points and basis functions.
%
%  Usage for obj = quadboundary :
%    [ pos, w, f, fp ] = eval( obj )
%  Output
%    pos    :  integration positions
%    w      :  integration weights
%    f      :  shape functions
%    fp     :  divergence of shape functions (only for edge elements)

%  quadrature points and integration weights
quad = obj.quad;
w = vertcat( obj.tau.area ) * quad.w;

switch class( obj.tau )
  case 'BoundaryVert'
    [ f, pos ] = basis( obj.tau, quad.x, quad.y, varargin{ : } );
    %  set output
    [ varargout{ 1 : 3 } ] = deal( pos, w, f );
  case 'BoundaryEdge'
    [ f, fp, pos ] = basis( obj.tau, quad.x, quad.y, varargin{ : }  );
    %  set output
    [ varargout{ 1 : 4 } ] = deal( pos, w, f, fp );
end
