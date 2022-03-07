function obj = init( obj, varargin )
%  INIT - Initialize refined integration of BEM potentials w/o series.
%
%  Usage for obj = galerkin.pot1.refine1 :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'rules1'     :  quadrature rules for refined integration
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules1', quadboundary.rules );
addParameter( p, 'order', 0 : 2 );
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

obj.rules1 = p.Results.rules1;
obj.relcutoff = p.Results.relcutoff;
