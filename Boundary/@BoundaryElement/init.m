function obj = init( ~, mat, varargin )
%  INIT - Initialize boundary element.
%
%  Usage :
%    obj = init(  mat, p1, inout1, p2, inout2, ... )
%  Input
%    mat    :  material parameters
%    inout  :  index to material at inside and outside
%    p      :  discretized particle boundary

if numel( varargin ) > 2
  fun = @( p, inout ) BoundaryElement( mat, p, inout );
  %  initialize boundaries
  obj = cellfun(  ...
    fun, varargin( 1 : 2 : end ), varargin( 2 : 2 : end ), 'uniform', 0 );
  %  combine to single vector
  obj = horzcat( obj{ : } );
else
  %  get input parameters
  [ p, inout ] = deal( varargin{ : } );

  %  allocate output
  n = size( p.faces, 1 );
  obj = repmat( BoundaryElement, 1, n );
  %  set material properties and material index
  [ obj.mat   ] = deal( mat );
  [ obj.inout ] = deal( inout );
  
  %  set centroid positions, normal vectors and areas
   [ pos, area, nvec ] = norm( p );
  
  for i = 1 : n
    %  set centroid positions, normal vectors and areas
    obj( i ).pos  = pos(  i, : );
    obj( i ).nvec = nvec( i, : );
    obj( i ).area = area( i );
    %  vertices and number of edges
    obj( i ).verts = p.verts( p.faces( i, : ), : );
    obj( i ).nedges = size( obj( i ).verts, 1 );
  end
end
