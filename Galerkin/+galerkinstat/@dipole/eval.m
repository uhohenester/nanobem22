function q = eval( obj, tau, k0, varargin )
%  EVAL - Inhomogeneity for dipole excitation.
%
%  Usage for obj = galerkinstat.dipole :
%    q = eval( obj, tau, k0 )
%  Input
%    tau    :  boundary elements
%    k0     :  wavelength of light in vacuum
%  Output
%    q      :  structure containing inhomogeneity for Galerkin scheme

%  initialize potential integrator and split at PARENT positions
pot = set( obj.pot, obj.pt, tau, varargin{ : } );
pot = mat2cell( pot );
%  number of points and degrees of freedom 
n1 = numel( obj.pt );
n2 = ndof( tau );
%  allocate output
vn = zeros( n2, n1, 3 );

for it = 1 : numel( pot )
  %  evaluate Green functions
  data = green( pot{ it } );
  %  dipole positions and boundary elements  
  [ pt1, pt2 ] = deal( pot{ it }( 1 ).pt1, pot{ it }( 1 ).pt2 );
  mat = pt1.mat( pt1.imat );
    
  %  indices for evaluation points and vertices
  [ nu1, nu2 ] = ndgrid( pt1.nu, vertcat( pt2.tau.nu ) );
  subs = { nu1( : ), nu2( : ) }; 
  %  derivative of normal derivative of Green function
  F1 = cat( 3,  ...
    accumarray( subs, reshape( data.F1( :, 1, :, : ), [], 1 ), [ n1, n2 ] ),  ...
    accumarray( subs, reshape( data.F1( :, 2, :, : ), [], 1 ), [ n1, n2 ] ),  ...
    accumarray( subs, reshape( data.F1( :, 3, :, : ), [], 1 ), [ n1, n2 ] ) );
 
  %  inhomogeneity
  vn = vn + permute( F1, [ 2, 1, 3 ] ) / mat.eps( k0 );
end  

%  set output
q = struct( 'vn', vn, 'tau', tau, 'k0', k0 );
