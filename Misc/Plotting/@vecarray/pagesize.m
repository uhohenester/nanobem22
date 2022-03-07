function siz = pagesize( obj, varargin )
%  PAGESIZE - Paging size of VECARRAY object or user-defined vector array.
%
%  Usage for obj = vecarray :
%    siz = pagesize( obj )
%    siz = pagesize( obj, vec )
%  Input
%    vec  :  vector array

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'vec', obj.vec );
%  parse input
parse( p, varargin{ : } );

vec = p.Results.vec;
%  size of value array
if ismatrix( vec )
  siz = 1;
else
  siz = size( vec );  
  siz = siz( 3 : end );
end
