function in = inner( obj, k0 )
%  INIT - Initialize quasistatic BEM solver.
%
%  Usage for obj = galerkinstat.bemsolver :
%    in = inner( obj, k0 )
%  PropertyName
%    k0     :  wavelength of light in vacuum
%    in     :  inner product for Lambda term

%  integration points, low accuracy
pts = quadboundary( obj.tau, quadboundary.rules );
%  permittivities
epsz = arrayfun( @( x ) x.eps( k0 ), obj.tau( 1 ).mat, 'uniform', 1 );

%  dummy indices for internal tensor class
[ i, w, a1, a2 ] = deal( 1, 2, 3, 4 );
%  inner product
in = zeros( ndof( obj.tau ) );

for pt = pts
  %  integration weights and shape functions
  [ ~, wt, f ] = eval( pt );
  %  permittivities at inside and outside of boundary element
  inout = vertcat( pt.tau.inout );
  [ eps1, eps2 ] = deal( epsz( inout( :, 1 ) ), epsz( inout( :, 2 ) ) );
  %  Lambda function
  Lambda = 0.5 * ( eps1 + eps2 ) ./ ( eps1 - eps2 );

  %  convert to tensors
  [ wt, f, Lambda ] = tensor.set( wt, f, Lambda );
  %  perform integration
  f( i, a1, a2 ) =  ...
    sum( wt( i, w ) * f( i, w, a1 ) * Lambda( i ) * f( i, w, a2 ), w );
  
  %  boundary element indices
  nu = vertcat( pt.tau.nu );
  %  accumulate arrays
  [ i1, i2 ] = ndgrid( 1 : pt.npoly );
  nu1 = reshape( nu( :, i1 ), [], 1 );
  nu2 = reshape( nu( :, i2 ), [], 1 );
  in = in + accumarray( { nu1, nu2 }, reshape( double( f ), [], 1 ), size( in ) );
end
