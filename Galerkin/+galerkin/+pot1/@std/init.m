function obj = init( obj, varargin )
%  INIT - Initialize default evaluation of BEM potentials.
%
%  Usage for obj = galerkin.pot1.std :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'rules'      :  quadrature rules

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules', quadboundary.rules );
%  parse input
parse( p, varargin{ : } );

obj.parent = true;
obj.rules = p.Results.rules;
