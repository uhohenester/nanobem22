function obj = init( obj, varargin )
%  INIT - Initialize refined integration of BEM potentials.
%
%  Usage for obj = galerkin.pot1.smooth :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'rules1'     :  quadrature rules for singular term
%    'rules2'     :  quadrature rules for smooth term
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules1', quadboundary.rules );
addParameter( p, 'rules2', quadboundary.rules );
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

obj.rules  = p.Results.rules;
obj.rules2 = p.Results.rules2;
obj.relcutoff = p.Results.relcutoff;
