function pot = engine( varargin )
%  ENGINE - Default integration engine for quasistatic potential terms.
%
%  Usage :
%    pot = galerkinstat.pot2.engine( PropertyPairs )
%  PropertyName
%    'rules'      :  default integration rules
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules', quadboundary.rules( 'quad3', triquad(  3 ) ) );
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

%  default integrator
pot( 1 ) = galerkinstat.pot2.std( p.Results );
pot( 2 ) = galerkinstat.pot2.smooth( p.Results );
