function quad = triquad( varargin )
%  TRIQUAD - Integration points for unit triangle.
%
%  Usage :
%    quad = triquad( rule, PropertyPairs )
%  Input
%    rule       :  integration rule 1-19
%  PropertyName
%    'refine'   :  refine surface element
%  Output
%    quad       :  quadrature points and weights

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'rule',   11 );
addParameter( p, 'refine',  1 );
%  parse input
parse( p, varargin{ : } );

%  check input
assert( p.Results.rule >= 1 && p.Results.rule <= 19 );

%  quadrature points and weights
[ x, y, w ] = triangle_unit_set( p.Results.rule );
%  refine points?
if p.Results.refine ~= 1
  [ x, y, w ] = trisubdivide( x, y, w, p.Results.refine );  
end
%  save to output
quad = struct( 'x', x, 'y', y, 'w', w );
