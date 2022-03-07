function varargout = interp( obj, v, varargin )
%  INTERP - Interpolate array values to boundary elements.
%
%  Usage for obj = quadboundary :
%    vi = interp( obj, v )
%  Input
%    v      :  value array 
%  Output
%    vi     :  values interpolated to boundaries

[ varargout{ 1 : nargout } ] =  ...
  interp( obj.tau, obj.quad.x, obj.quad.y, v, varargin{ : } );
