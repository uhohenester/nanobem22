function r = rules( varargin )
%  RULES - Integration rules for boundary elements.
%
%  Usage :
%    r = quadboundary.rules( PropertyPairs )
%  PropertyName
%    'quad3'    :  quadrature points for triangle integration
%    'quad4'    :  quadrature points for quadrilateral integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'key', 0 );
addParameter( p, 'quad3', triquad( 3 ) );
addParameter( p, 'quad4', [] );
%  parse input
parse( p, varargin{ : } );

if isempty( p.Results.key )
  r = struct( 'quad3', [] );
else
  r = struct( 'quad3', p.Results.quad3 );
end
