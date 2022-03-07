function obj = setrules( obj, varargin )
%  SETRULES - Set integration rules for boundary elements.
%
%  Usage for obj = quadboundary :
%    obj = setrules( obj, PropertyPairs )
%  PropertyName
%    'quad3'    :  quadrature points for triangle integration
%    'quad4'    :  quadrature points for quadrilateral integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'quad3', triquad( 3 ) );
addParameter( p, 'quad4', [] );
%  parse input
parse( p, varargin{ : } );

if isscalar( obj )
  switch obj.npoly
    case 3
      obj.quad = p.Results.quad3;
  end
else
  obj = cellfun( @( x ) setrules( x, varargin{ : } ), obj, 'uniform', 0 );
  obj = horzcat( obj );
end
