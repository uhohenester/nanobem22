function [ SL, DL ] = potfar( obj, pt1, varargin )
%  POTFAR - Single and double layer potential for far fields.
%
%  Usage for obj = galerkin.solution :
%    [ SL, DL ] = potfar( obj, pt1 )
%  Input
%    pt1    :  points at infinity
%  Output
%    SL     :  single layer potential, Hohenester Eq. (5.24)
%    DL     :  double layer potential, Hohenester Eq. (5.23)

%  materials index and properties of embedding medium
imat1 = pt1( 1 ).imat;
mat1 = pt1( 1 ).mat( imat1 );
%  wavenumber of embedding medium
k1 = mat1.k( obj.k0 );

%  positions on unit sphere at infinity, i.e. light propagation directions
pos1 = vertcat( pt1.pos );
n1 = size( pos1, 1 );
%  particle and number of degrees of freedom
tau = obj.tau;
n2 = ndof( tau );
%  allocate output
[ SL, DL ] = deal( zeros( n1, 3, n2 ) );

%  indices for internal tensor class
[ i1, i2, q2, a2, k ] = deal( 1, 2, 3, 4, 5 );
%  convert light propagation directions to tensor
pos1 = tensor( pos1, [ i1, k ] );

%  loop over particle boundary
for pt2 = quadboundary( obj.tau, varargin{ : } )
  
  if any( imat1 == pt2.inout )
    %  integration positions and weights, shape functions
    [ pos2, w2, f2 ] = eval( pt2 );
    %  convert to tensor class
    pos2 = tensor( pos2, [ i2, q2, k ] );
    f2 = tensor( f2, [ i2, q2, a2, k ] ) * tensor( w2, [ i2, q2 ] );
    %  single and double layer potential, Hohenester Eq. (5.23-24)
    fac = exp( - 1i * k1 * dot( pos1, pos2, k ) ) / ( 4 * pi );
    SL1 = sum( fac * ( f2 - pos1 * dot( pos1, f2, k ) ), q2 );
    DL1 = - 1i * k1 * sum( fac * cross( pos1, f2, k ), q2 );
    
    %  convert to numeric
    SL1 = reshape( double( SL1, [ i1, k, i2, a2 ] ), n1, 3, [] );
    DL1 = reshape( double( DL1, [ i1, k, i2, a2 ] ), n1, 3, [] );
    %  global degrees of freedom
    nu = reshape( vertcat( pt2.tau.nu ), 1, [] );
    %  accumulate output arrays
    for i = 1 : numel( nu )
      SL( :, :, nu( i ) ) = SL( :, :, nu( i ) ) + SL1( :, :, i );
      DL( :, :, nu( i ) ) = DL( :, :, nu( i ) ) + DL1( :, :, i );
    end
  end
end
