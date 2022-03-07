function obj = init( obj, varargin )
%  INIT - Initialize Duffy integration of quasistatic BEM potentials.
%
%  Usage for obj = galerkinstat.pot1.duffy :
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
