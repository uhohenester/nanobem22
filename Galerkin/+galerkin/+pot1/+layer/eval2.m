function data = eval2( obj, k1, state, varargin )
%  EVAL2 - Evaluate refined terms of BEM potentials.
%
%  Usage :
%    data = galerkin.pot1.layer.eval2( obj, k1, state, data )
%  Input
%    obj      :  potential object 
%    k1       :  wavenumber of light in medium
%    state    :  1 - series expansion only
%                2 - series expansion and smooth Green function
%                3 - no series expansion
%    data     :  previously computed SL and DL potentials
%  Output
%    data     :  single and double layer potential

%  quadrature rules for boundary
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );

%  precomputed data
switch state
  case { 1, 2 }
    %  order for series expansion
    n = obj.data.order;
    fac = ( 1i * k1 ) .^ n ./ factorial( n );
    fac = tensor( fac, 4 ) * tensor( exp( 1i * k1 * obj.data.d0 ), 1 );
    fun = @( x )  ...
      double( sum( tensor( x, [ 1, 2, 3, 4 ] ) * fac, 4 ), [ 1, 2, 3 ] );
    %  assemble series expansion for single and double layer potentials
    data.SL =           fun( obj.data.SL1 ) - fun( obj.data.SL2 ) / k1 ^ 2;
    data.DL = 1i * k1 * fun( obj.data.DL1 ) - fun( obj.data.DL2 ); 
  otherwise
    [ data.SL, data.DL ] = deal(  ...
      zeros( numel( obj.tau1 ), pt1.tau( 1 ).nedges, pt2.tau( 1 ).nedges ) );
end

%  integration for remaining terms
if state ~= 1
 
  %  integration points and weights 
  [ pos1, w1, f1, fp1 ] = eval( pt1 );
  [ pos2, w2, f2, fp2 ] = eval( pt2 );
  %  multiply shape functions with integration weights
  f1  = reshape( bsxfun( @times, reshape( f1,  numel( w1 ), [] ), w1( : ) ), size( f1  ) );
  f2  = reshape( bsxfun( @times, reshape( f2,  numel( w2 ), [] ), w2( : ) ), size( f2  ) );
  fp1 = reshape( bsxfun( @times, reshape( fp1, numel( w1 ), [] ), w1( : ) ), size( fp1 ) );
  fp2 = reshape( bsxfun( @times, reshape( fp2, numel( w2 ), [] ), w2( : ) ), size( fp2 ) );

  %  cross product of position and shape function
  g1 = cross( tensor( f1, [ 1, 2, 3, 4 ] ), tensor( pos1, [ 1, 2, 4 ] ), 4 );
  g2 = cross( tensor( f2, [ 1, 2, 3, 4 ] ), tensor( pos2, [ 1, 2, 4 ] ), 4 );
  %  convert to numeric
  g1 = double( g1( 1, 2, 3, 4 ) );
  g2 = double( g2( 1, 2, 3, 4 ) );
  
  %  distance
  u = double( tensor( pos1, [ 1, 2, 4 ] ) - tensor( pos2, [ 1, 3, 4 ] ), [ 1, 2, 3, 4 ] );
  d = sqrt( dot( u, u, 4 ) );  
    
  %  phase factor
  switch state
    case 2
      %  expansion parameter
      x = double( tensor( d, [ 1, 2, 3, 4 ] ) - tensor( obj.data.d0, 1 ), [ 1, 2, 3, 4 ] );
      %  phase factor
      fac  = exp( 1i * k1 * d );
      fac0 = exp( 1i * k1 * obj.data.d0 );
      for n = obj.data.order
        fac = fac - fac0 .* ( 1i * k1 * x ) .^ n / factorial( n );
      end
    otherwise
      fac = exp( 1i * k1 * d );
  end
  %  Green function and derivative  
  G = fac ./ ( 4 * pi * d );
  F = ( 1i * k1 - 1 ./ d ) .* G ./ d;

  %  single layer potential
  at = @( f, k ) f( :, :, :, k );
  oint = @( H, f1, f2 ) galerkin.pot1.layer.oint( H, f1, f2 );
    
  data.SL = data.SL +  ...
    oint( G, at( f1, 1 ), at( f2, 1 ) ) +  ...
    oint( G, at( f1, 2 ), at( f2, 2 ) ) +  ...
    oint( G, at( f1, 3 ), at( f2, 3 ) ) - oint( G, fp1, fp2 ) / k1 ^ 2;
  %  double layer potential
  for k = 1 : 3
    data.DL = data.DL - oint( F, at( g1, k ), at( f2, k ) ) -  ...
                        oint( F, at( f1, k ), at( g2, k ) );
  end
end
  
%  deal with previously computed SL and DL data
if ~isempty( varargin )
  [ SL, DL, data ] = deal( data.SL, data.DL, varargin{ : } );
  %  linear index
  [ i1, i2, i3 ] =  ...
    ndgrid( 1 : size( SL, 1 ), 1 : size( SL, 2 ), 1 : size( SL, 3 ) );
  ind = sub2ind( size( data.SL ), obj.i1( i1 ), i2, obj.i2( i1 ), i3 );
  %  replace refined elements
  data.SL( ind ) = SL;
  data.DL( ind ) = DL;
end
