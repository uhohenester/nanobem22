function obj = init( obj, poly, z, varargin )
%  Initialize polygon3 object.
%
%  Usage
%    obj = polygon3( poly, z )
%    obj = polygon3( poly, z, PropertyPairs )
%  Input
%    poly     :  polygon
%    z        :  z-value of polygon
%  PropertyName
%    'edge'   :  edge profile
%    'refun'  :  refine function for plate discretization

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'edge', edgeprofile );
addParameter( p, 'refun', [] );
%  parse input
parse( p, varargin{ : } );

%  save input
[ obj.poly, obj.z ] = deal( poly, z );

obj.edge = p.Results.edge;
obj.refun = p.Results.refun;
