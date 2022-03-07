function varargout = plot( obj, varargin )
%  PLOT - Plot particle or function values on particle.
%
%  Usage for obj = particle :
%    h = plot( obj,      PropertyPair )
%    h = plot( obj, val, PropertyPair )
%  Input
%    val    :  value array
%  PropertyName
%    'EdgeColor'    :  edge color
%    'FaceColor'    :  face color
%    'FaceAlpha'    :  transparency of faces
%    'nvec',        :  plot normal vector
%  Output
%    h              :  figure handle

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'val', [] );
addParameter( p, 'EdgeColor', [] );
addParameter( p, 'FaceColor', [ 1, 0.6, 0 ] );
addParameter( p, 'FaceAlpha', 1 );
addParameter( p, 'nvec', 0 );
addParameter( p, 'cone', [] );
addParameter( p, 'vec', [] );
%  parse input
parse( p, varargin{ : } );

%  get BEMPLOT object
h = bemplot.get( varargin{ : } );

%  plot value array 
if isempty( p.Results.val )
  val = repmat( p.Results.FaceColor, size( obj.verts, 1 ), 1 );
  h = plottrue( h, obj, val, varargin{ : } );
else
  varargin = varargin( 2 : end );
  h = plotval( h, obj, interp( obj, p.Results.val ), varargin{ : } );
end

%  plot edges
if ~isempty( p.Results.EdgeColor )
  hold on;
  net = edges( obj );
  %  connection function
  fun = @( i ) [ obj.verts( net( :, 1 ), i ),  ...
                 obj.verts( net( :, 2 ), i ), nan( size( net, 1 ), 1 ) ]';
  %  plot connections
  plot3( fun( 1 ), fun( 2 ), fun( 3 ), p.Results.EdgeColor );
end 

%  plot outer surface normals
if p.Results.nvec
  h = plotarrow( h, obj.pos, obj.nvec, varargin{ : } );  
end
%  cone or vector plot
if ~isempty( p.Results.cone )
  h = plotcone( h, obj.pos, p.Results.cone, varargin{ : } );  
elseif ~isempty( p.Results.vec )
  h =  plotarrow( h, obj.pos, p.Results.vec,  varargin{ : } );  
end

%  set output
[ varargout{ 1 : nargout } ] = deal( h );
%  plot options
lighting phong;  
shading interp;
