function cabs = absorption( obj, sol )
%  ABSORPTION - Absorption cross section.
%
%  Usage for obj = galerkin.planewave :
%    cabs = absorption( obj, sol )
%  Input
%    sol    :  solution of BEM equations
%  Output
%    cabs   :  absorption cross section

%  allocate output
cabs = 0;
%  dummy indices for internal vector class
[ i, q, k, ipol ] = deal( 1, 2, 3, 4 );

%  loop over boundary elements
for pt = quadboundary( sol.tau, obj.rules )
  
  if any( pt.tau( 1 ).inout == obj.imat )
    %  quadrature weights
    [ ~, w ] = eval( pt );
    w = tensor( w, [ i, q ] );
    %  normal vector
    nvec = tensor( vertcat( pt.tau.nvec ), [ i, k ] );
    %  interpolate electromagnetic fields
    [ e, h ] = interp( sol, pt );
    e = tensor( e, [ i, q, k, ipol ] );
    h = tensor( h, [ i, q, k, ipol ] );
    %  Poynting vector in normal direction
    s = 0.5 * sum( nvec * sum( w * cross( e, conj( h ), k ), q ), i, k );
    cabs = cabs - real( double( s( ipol ) ) );    
  end
end

%  normalize absorption cross section
mat = sol.tau( 1 ).mat( obj.imat );
cabs = cabs / ( 0.5 / mat.Z( sol.k0 ) );
