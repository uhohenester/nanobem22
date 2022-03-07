function obj = init( obj, varargin )
%  INIT - Initialize refined integration of BEM potentials.
%
%  Usage for obj = galerkin.pot2.smooth :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'rules '     :  quadrature rules for smooth term
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules1', quadboundary.rules );
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

obj.rules1 = p.Results.rules1;
obj.relcutoff = p.Results.relcutoff;
