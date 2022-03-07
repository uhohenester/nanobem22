function [ f, pos ] = basis( obj, x, y, varargin )
%  BASIS - Shape elements for selected boundary elements.
%
%  Usage for obj = BoundaryVert :
%    [ f, pos ] = basis( obj, x, y, PropertyPairs )
%  Input
%    x,y    :  triangular or quadrilateral coordinates
%  PropertyName
%    same   :  same quadrature points for all boundary elements
%  Output
%    f      :  shape function f(i,w,a)
%    pos    :  positions pos(i,w,k)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'same', 0 );
%  parse input
parse( p, varargin{ : } );

m = obj( 1 ).nedges;
%  get vertices verts(i,a,k)
n = numel( obj );
verts = permute( reshape( vertcat( obj.verts ), m, n, 3 ), [ 2, 1, 3 ] );

%  dummy indices for internal tensor class
[ i, q, a, k ] = deal( 1, 2, 3, 4 );
%  transform verices to internal tensor class
verts = tensor( verts, [ i, a, k ] );

switch m
  case 3
    %  triangular coordinates 
    if p.Results.same
      xi = tensor( cat( 3, x, y, 1 - x - y ), [ i, q, a ] );
    else
      xi = tensor( [ x( : ), y( : ), 1 - x( : ) - y( : ) ], [ q, a ] );
    end
    %  positions and shape functions
    pos = sum( xi * verts, a );
    f = tensor( ones( 1, n ), i ) * xi;
    
  otherwise
    error( 'Boundary element with %i edges not implemented.', m );
end

%  convert back from tensor class
[ f, pos ] = deal( double( f, [ i, q, a ] ), double( pos, [ i, q, k ] ) );
