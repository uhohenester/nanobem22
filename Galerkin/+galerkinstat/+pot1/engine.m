function pot = engine( varargin )
%  ENGINE - Default integration engine for potential integration.
%
%  Usage :
%    pot = galerkinstat.pot1.engine( PropertyPairs )
%  PropertyName
%    'nduffy'     :  number of Legendre-Gauss points for Duffy integration
%    'rules'      :  default integration rules
%    'rules1'     :  integration rules for refinement
%    'relcutoff'  :  relative cutoff for refined integration
%    'mode'       : engine mode 'duffy' or 'smooth'

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nduffy', 4 );
addParameter( p, 'rules',  quadboundary.rules( 'quad3', triquad(  3 ) ) );
addParameter( p, 'rules1', quadboundary.rules( 'quad3', triquad( 11 ) ) );
addParameter( p, 'relcutoff', 2 );
addParameter( p, 'mode', 'smooth' );
%  parse input
parse( p, varargin{ : } );

%  default integrator
switch p.Results.mode
  case 'duffy'
    %  Duffy integration
    pot( 1 ) = galerkinstat.pot1.std( p.Results );
    pot( 2 ) = galerkinstat.pot1.refine( p.Results );
    pot( 3 ) = galerkinstat.pot1.duffy( p.Results ); 
  case 'smooth'
    %  analytic integration
    pot( 1 ) = galerkinstat.pot1.std( p.Results );
    pot( 2 ) = galerkinstat.pot1.smooth( p.Results );
end
