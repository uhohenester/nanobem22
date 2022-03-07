function obj = init( obj, varargin )
%  INIT - Initialize Duffy integration of BEM potentials w/o series.
%
%  Usage for obj = galerkin.pot1.duffy1 :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'nduffy'   :  number of Legendre-Gauss points for integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nduffy', 3 );
%  parse input
parse( p, varargin{ : } );

obj.nduffy = p.Results.nduffy;
