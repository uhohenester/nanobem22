function obj = init( obj, varargin )
%  INIT - Initialize refined integration of BEM potentials with series.
%
%  Usage for obj = galerkin.pot1.refine2 :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'rules1'     :  quadrature rules for refined integration
%    'rules2'     :  quadrature rules for remaining integration
%    'order'      :  orders for series expansion
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules1', quadboundary.rules );
addParameter( p, 'rules2', [] );
addParameter( p, 'order', 3 );
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

obj.rules1 = p.Results.rules1;
obj.rules2 = p.Results.rules2;
obj.order  = 0 : p.Results.order;
obj.relcutoff = p.Results.relcutoff;
