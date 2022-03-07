function obj = init( obj, varargin )
%  INIT - Initialize Duffy integration of BEM potentials with series.
%
%  Usage for obj = galerkin.pot1.duffy1 :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'nduffy'   :  number of Legendre-Gauss points for integration
%    'rules2'   :  quadrature rules for remaining integration
%    'order'    :  order for series expansion

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nduffy', 3 );
addParameter( p, 'rules2', [] );
addParameter( p, 'order', 3 );
%  parse input
parse( p, varargin{ : } );

obj.nduffy = p.Results.nduffy;
obj.order = 0 : p.Results.order;
