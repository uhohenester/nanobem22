function [ e, h ] = farfields( obj, pt1, varargin )
%  FIELDS - Electromagnetic far-fields along requested directions.
%
%  Usage for obj = galerkin.solution :
%    [ e, h ] = farfields( obj, pt1, PropertyPairs )
%  Input
%    pt1        :  far-field positions on unit sphere
%  Output
%    e          :  electric far-field at requested directions
%    h          :  magnetic far-field at requested directions

%  material properties of embedding medium
imat1 = pt1( 1 ).imat;
mat = pt1( 1 ).mat( imat1 );
%  permittivity and permeability
k0 = obj.k0;
[ eps1, mu1 ] = deal( mat.eps( k0 ), mat.mu( k0 ) );

%  single and double layer potentials for far fields
[ SL, DL ] = potfar( obj, pt1, varargin{ : } );
%  number of positions and degrees of freedom
[ n1, n2 ] = deal( size( SL, 1 ), size( SL, 3 ) );

%  multiplication function for layer and tangential fields
siz = size( obj.e );
fun = @( x, u ) reshape( x, [], n2 ) * reshape( u, n2, [] );
%  electromagnetic far fields, Hohenester Eq. (5.37)
e =   1i * k0 *  mu1 * fun( SL, obj.h ) - fun( DL, obj.e );
h = - 1i * k0 * eps1 * fun( SL, obj.e ) - fun( DL, obj.h );

%  reshape output
if numel( obj.e ) ~= n2
  e = reshape( e, [ n1, 3, siz( 2 : end ) ] );
  h = reshape( h, [ n1, 3, siz( 2 : end ) ] );
end
