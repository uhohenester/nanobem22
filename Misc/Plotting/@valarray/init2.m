function obj = init2( obj, val, varargin )
%  Initialization of VALARRAY.
%
%  Usage for obj = valarray :
%    obj = init2( obj, val )
%    obj = init2( obj, val, 'truecolor' )
%    obj = init2( obj, [],  'truecolor' )
%  Input
%    val  :  value array

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'truecolor', 0 );
%  parse input
parse( p, varargin{ : } );

[ obj.val, obj.truecolor ] = deal( val, p.Results.truecolor );
