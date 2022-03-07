function qinc = qbasis( obj, fun, varargin )
%  QBASIS - Inhomogeneity for Galerkin scheme.
%
%  Usage for obj = BoundaryVert :
%    qinc = qbasis( obj, fun )
%  Input
%    fun    :  function for computation of electric fields
%  Output
%    qinc   :  inhomogeneity for normal derivative of potential

%  number of degrees of freedom
n = ndof( obj );
%  dummy indices for internal tensor class
[ i, j, q, a, k ] = deal( 1, 2, 3, 4, 5 );

%  loop over boundary elements
for pt = quadboundary( obj, varargin{ : } )
  %  integration weights and shape functions
  [ ~, w, f ] = eval( pt );
  w = tensor( w, [ i, q ] );
  f = tensor( f, [ i, q, a ] );
  
  %  evaluate electric field
  e = fun( pt );  
  %  convert electric field to tensor class
  siz = size( e );
  m = numel( e ) / prod( siz( 1 : 3 ) );
  e = tensor( reshape( e, siz( 1 ), siz( 2 ), 3, [] ), [ i, q, k, j ] );
  
  %  allocate output ?
  if ~exist( 'qinc', 'var' ), qinc = deal( zeros( n, m ) );  end  
 
  %  normal vector
  nvec = tensor( vertcat( pt.tau.nvec ), [ i, k ] );
  %  normal derivative of potential
  vn = - sum( ( w * f * nvec ) * e, k, q );
  nu = vertcat( pt.tau.nu );
  vn = reshape( double( vn( i, a, j ) ), [], m );
  
  %  loop over global degrees of freedom  
  for it = 1 : numel( nu )
    qinc( nu( it ), : ) = qinc( nu( it ), : ) +  vn( it, : );
  end
end

%  reshape output
if numel( siz ) > 4
  qinc = reshape( qinc, [ size( qinc, 1 ), siz( 4 : end ) ] );
end
