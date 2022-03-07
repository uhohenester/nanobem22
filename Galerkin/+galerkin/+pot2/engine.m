function pot = engine( varargin )
%  ENGINE - Default integration engine for potential integration.
%
%  Usage :
%    pot = galerkin.pot2.engine( PropertyPairs )
%  PropertyName
%    'rules'      :  default integration rules
%    'rules1'     :  integration rules for refinement
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules',  quadboundary.rules( 'quad3', triquad(  3 ) ) );
addParameter( p, 'rules1', quadboundary.rules( 'quad3', triquad( 11 ) ) );
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

%  default integrator
pot( 1 ) = galerkin.pot2.std( p.Results );
pot( 2 ) = galerkin.pot2.smooth( p.Results );
