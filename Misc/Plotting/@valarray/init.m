function obj = init( obj, p1, val, varargin )
%  Initialization of VALARRAY.
%
%  Usage for obj = valarray :
%    obj = init( obj, p1, val )
%    obj = init( obj, p1, val, 'truecolor' )
%    obj = init( obj, p1, [],  'truecolor' )
%  Input
%    p1   :  particle
%    val  :  value array

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter(  p, 'truecolor', 0 );
%  parse input
parse( p, varargin{ : } );

[ obj.p, obj.val, obj.truecolor ] = deal( p1, val, p.Results.truecolor );
