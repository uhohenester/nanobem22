function pot = engine( varargin )
%  ENGINE - Default integration engine for potential integration.
%
%  Usage :
%    pot = galerkin.pot1.engine( PropertyPairs )
%  PropertyName
%    'nduffy'     :  number of Legendre-Gauss points for Duffy integration
%    'rules'      :  default integration rules
%    'rules1'     :  integration rules for refinement
%    'order'      :  orders for series expansion
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nduffy', 3 );
addParameter( p, 'rules',  quadboundary.rules( 'quad3', triquad(  3 ) ) );
addParameter( p, 'rules1', quadboundary.rules( 'quad3', triquad( 11 ) ) );
addParameter( p, 'rules2', [] );
addParameter( p, 'order', 3 );
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

%  default integrator
pot( 1 ) = galerkin.pot1.std( p.Results );
%  refinement integrators
if isempty( p.Results.order )
  pot( 2 ) = galerkin.pot1.refine1( p.Results );
  pot( 3 ) = galerkin.pot1.duffy1( p.Results ); 
else
  pot( 2 ) = galerkin.pot1.refine2( p.Results );
  pot( 3 ) = galerkin.pot1.duffy2( p.Results ); 
end
