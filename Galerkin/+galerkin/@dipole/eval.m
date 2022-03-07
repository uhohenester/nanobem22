function q = eval( obj, tau, k0, varargin )
%  EVAL - Inhomogeneities for dipole excitation.
%
%  Usage for obj = galerkin.dipole :
%    q = eval( obj, tau, k0 )
%  Input
%    tau    :  boundary elements
%    k0     :  wavelength of light in vacuum
%  Output
%    q      :  structure containing inhomogeneities for BEM

%  initialize potential integrator and split at PARENT positions
pot = set( obj.pot, obj.pt, tau, varargin{ : } );
pot = mat2cell( pot );
%  number of points and degrees of freedom 
n1 = numel( obj.pt );
n2 = ndof( tau );
%  allocate output
e = zeros( n2, n1, 3 );
h = zeros( n2, n1, 3 );

for it = 1 : numel( pot )
  %  evaluate SL and DL potential
  data = potential( pot{ it }, k0 );
  %  dipole positions and boundary elements  
  [ pt1, pt2 ] = deal( pot{ it }( 1 ).pt1, pot{ it }( 1 ).pt2 );
  mat = pt1.mat( pt1.imat );
  %  particle inside or outside
  sig = [ 1, -1 ];
  sig = sig( pt2.inout == pt1.imat );
    
  %  indices for evaluation points and edges
  [ nu1, nu2 ] = ndgrid( pt1.nu, vertcat( pt2.tau.nu ) );
  subs = { nu1( : ), nu2( : ) }; 
  %  accumulate single and double layer potential
  SL = cat( 3,  ...
    accumarray( subs, reshape( data.SL( :, :, 1 ), [], 1 ), [ n1, n2 ] ),  ...
    accumarray( subs, reshape( data.SL( :, :, 2 ), [], 1 ), [ n1, n2 ] ),  ...
    accumarray( subs, reshape( data.SL( :, :, 3 ), [], 1 ), [ n1, n2 ] ) );
  DL = cat( 3,  ...
    accumarray( subs, reshape( data.DL( :, :, 1 ), [], 1 ), [ n1, n2 ] ),  ...
    accumarray( subs, reshape( data.DL( :, :, 2 ), [], 1 ), [ n1, n2 ] ),  ...
    accumarray( subs, reshape( data.DL( :, :, 3 ), [], 1 ), [ n1, n2 ] ) );      
 
  %  inhomogeneities
  e = e - sig * k0 ^ 2 * mat.mu( k0 ) * permute( SL, [ 2, 1, 3 ] );
  h = h - 1i * sig * k0 * permute( DL, [ 2, 1, 3 ] );
end  

%  set output
q = struct( 'e', e, 'h', h, 'tau', tau, 'k0', k0 );
