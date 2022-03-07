function plot( obj, varargin )
%  PLOT - Plot polygon.
%
%  Usage for obj = polygon :
%    plot( obj, PropertyPairs )
%  Input
%    obj    :  single object or array
%  PropertyName
%    'nvec'     :  plot also normal vectors
%    'scale'    :  scaling for normal vectors

%  first varargin element can be line specification
if ~isempty( varargin ) && mod( numel( varargin ), 2 ) == 1
  [ line, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
else
  line = '-';
end

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nvec', 0 );
addParameter( p, 'scale', 1 );
%  parse input
parse( p, varargin{ : } );

for it = 1 : length( obj )
  pos = obj( it ).pos; 
  builtin( 'plot', [ pos( :, 1 ); pos( 1, 1 ) ],  ...
                   [ pos( :, 2 ); pos( 1, 2 ) ], line );  hold on;
  
end
%  normal vectors
if p.Results.nvec
  nvec = p.Results.scale * norm( obj );
  quiver( pos( :, 1 ), pos( :, 2 ), nvec( :, 1 ), nvec( :, 2 ), p.Results.scale );    
end
