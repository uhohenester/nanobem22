function data = eval( obj, k0, inout )
%  EVAL - Evaluate single and double layer potentials.
%
%  Usage for obj = galerkin.pot1.base :
%    data = eval( obj, k0, inout )
%  Input
%    k0         :  wavenumber of light in vacuum
%    inout      :  layers at inside or outside
%  Output
%    data.SL1   :  single layer potential times permeability
%    data.SL2   :  single layer potential times permittivity
%    data.DL    :  double layer potential

%  split array at PARENT positions into cell array
obj = mat2cell( obj );
%  number of degrees of freedom
n1 = max( cellfun( @( x ) ndof( x( 1 ).tau1 ), obj, 'uniform', 1 ) );
n2 = max( cellfun( @( x ) ndof( x( 1 ).tau2 ), obj, 'uniform', 1 ) );

%  allocate output
[ data.SL1, data.SL2, data.DL ] = deal( zeros( n1, n2 ) );
%  loop over integrators
for i1 = 1 : numel( obj )
  %  boundary elements and global degrees of freedom
  tau1 = obj{ i1 }( 1 ).tau1;  nu1 = vertcat( tau1.nu );
  tau2 = obj{ i1 }( 1 ).tau2;  nu2 = vertcat( tau2.nu );
  %  material properties
  mat1 = tau1( 1 ).mat( tau1( 1 ).inout( inout ) );
  [ k1, mu1, eps1 ] = deal( mat1.k( k0 ), mat1.mu( k0 ), mat1.eps( k0 ) );
    
  %  evaluate SL and DL potential
  data1 = [];
  for pt = obj{ i1 }
    data1 = eval2( pt, k1, data1 );
  end
    
  %  accumulate matrix
  [ nu1, nu2 ] = ndgrid( nu1( : ), nu2( : ) );
  fun1 = @( x ) accumarray( { nu1( : ), nu2( : ) }, x( : ), [ n1, n2 ] );
  %  assemble SL and DL potential
  data.SL1 = data.SL1 + fun1( data1.SL * mu1  );
  data.SL2 = data.SL2 + fun1( data1.SL * eps1 );
  data.DL  = data.DL  + fun1( data1.DL );  
end
