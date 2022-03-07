function [ qe, qh ] = qbasis( obj, fun, varargin )
%  QBASIS - Inhomogeneity for Galerkin scheme.
%
%  Usage for obj = BoundaryEdge :
%    [ qe, qh ] = qbasis( obj, fun )
%  Input
%    fun    :  function for computation of electromagnetic fields
%  Output
%    qe     :  inhomogeneity for electric field
%    qh     :  inhomogeneity for magnetic field

%  number of degrees of freedom
n = ndof( obj );
%  dummy indices for internal tensor class
[ i, q, a, k, j ] = deal( 1, 2, 3, 4, 5 ); 

%  loop over boundary elements
for pt = quadboundary( obj, varargin{ : } )
 
  %  integration weights and shape functions
  [ ~, w, f ] = eval( pt );
  f = tensor( f, [ i, q, a, k ] ) * tensor( w, [ i, q ] );
  %  evaluate electromagnetic fields
  [ e, h ] = fun( pt );
  
  %  convert electromagnetic fields to tensors
  siz = size( e );  
  m = numel( e ) / prod( siz( 1 : 3 ) );
  e = tensor( reshape( e, siz( 1 ), siz( 2 ), 3, m ), [ i, q, k, j ] );  
  h = tensor( reshape( h, siz( 1 ), siz( 2 ), 3, m ), [ i, q, k, j ] );  
  %  inhomogeneities for electromagnetic fields
  e = sum( f * e, q, k );  
  h = sum( f * h, q, k );  
  %  convert to numeric
  e = reshape( double( e( i, a, j ) ), [], m );
  h = reshape( double( h( i, a, j ) ), [], m );
  
  %  allocate output ?
  if ~exist( 'qe', 'var' ), [ qe, qh ] = deal( zeros( n, m ) );  end
  
  nu = vertcat( pt.tau.nu );
  %  loop over global degrees of freedom  
  for it = 1 : numel( nu )
    qe( nu( it ), : ) = qe( nu( it ), : ) + e( it, : );
    qh( nu( it ), : ) = qh( nu( it ), : ) + h( it, : );
  end  
end

%  reshape output
if numel( siz ) > 4
  qe = reshape( qe, [ size( qe, 1 ), siz( 4 : end ) ] );
  qh = reshape( qh, [ size( qh, 1 ), siz( 4 : end ) ] );
end
