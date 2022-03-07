function [ f, fp, pos ] = basis( obj, x, y, varargin )
%  BASIS - Shape elements for selected boundary elements.
%
%  Usage for obj = BoundaryEdge :
%    [ f, fp, pos ] = basis( obj, x, y, PropertyPairs )
%  Input
%    x,y  :  triangular or quadrilateral coordinates
%  PropertyName
%    same   :  same quadrature points for all boundary elements
%  Output
%    f    :  shape function f(i,q,a,k)
%    fp   :  divergence of shape function fp(i,q,a)
%    pos  :  positions pos(i,q,k)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'same', 0 );
%  parse input
parse( p, varargin{ : } );

m = obj( 1 ).nedges;
%  dummy indices for internal tensor class
[ i, q, a, k ] = deal( 1, 2, 3, 4 );

%  vertices
n = numel( obj );
verts = permute( reshape( vertcat( obj.verts ), m, n, 3 ), [ 2, 1, 3 ] );
%  prefactors for shape functions
val = tensor( vertcat( obj.val ), [ i, a ] );

switch m
  case 3
    %  triangular coordinates 
    if p.Results.same
      xi = tensor( cat( 3, x, y, 1 - x - y ), [ i, q, a ] );
    else
      xi = tensor( [ x( : ), y( : ), 1 - x( : ) - y( : ) ], [ q, a ] );
    end    
    %  positions
    pos = sum( xi * tensor( verts, [ i, a, k ] ), a );
    %  shape function and divergence
    f = 0.5 * val *  ...
      ( pos - tensor( verts( :, [ 3, 1, 2 ], : ), [ i, a, k ] ) );
    fp = val + 0 * xi;    
    
  otherwise
    error( 'Boundary element with %i edges not implemented.', m );
end

%  convert back from tensor class
f  = double( f,  [ i, q, a, k ] );
fp = double( fp, [ i, q, a ] );
pos = double( pos, [ i, q, k ] );
