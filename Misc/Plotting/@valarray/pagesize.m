function siz = pagesize( obj, varargin )
%  PAGESIZE - Paging size of VALARRAY object or user-defined value array.
%
%  Usage for obj = valarray :
%    siz = pagesize( obj )
%    siz = pagesize( obj, val )
%  Input
%    val  :  value array

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'val', obj.val );
%  parse input
parse( p, varargin{ : } );

val = p.Results.val; 
%  size of value array
siz = size( val );  
siz = siz( 2 : end );
