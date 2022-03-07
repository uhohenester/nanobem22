function n = vecnorm2( v, varargin )
%  VECNORM2 - Norm of vector array.
%
%  Usage :
%    n = vecnorm2( v )
%    n = vecnorm2( v, 'max' )
%  Input
%    v      :  vector array of size (:,3,siz)
%  Output
%    n      :  norm array of size (:,siz) or maximum of N if 'max' set

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'key', 'default', @( x ) true );
%  parse input
parse( p, varargin{ : } );

n = squeeze( sqrt( dot( abs( v ), abs( v ), 2 ) ) );
if strcmp( p.Results.key, 'max' ),  n = max( n( : ) );  end
