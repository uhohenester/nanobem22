function obj = init2( obj, vec, varargin )
%  Initialization of VECARRAY.
%
%  Usage for obj = valarray :
%    obj = init2( obj, vec )
%    obj = init2( obj, vec, mode )
%  Input
%    vec    :  vector array
%    mode   :  'cone' or 'arrow'

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'mode', 'cone' );
%  parse input
parse( p, varargin{ : } );

[ obj.vec, obj.mode ] = deal( vec, p.Results.mode );
