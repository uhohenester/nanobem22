function data = eval2( obj, k1, varargin )
  %  EVAL2 - Evaluate single and doble layer potential.
  %
  %  Usage for obj = galerkin.pot1.smooth :
  %    data = eval2( obj, k1 )
  %    data = eval2( obj, k1, data )
  %  Input
  %    k1     :  wavenumber of light in medium
  %    data   :  previously computed SL and DL terms
  %  Output
  %    data   :  single and double layer potential

  %  evaluate precomputed single layer potential elements
  SL = obj.data.SL{ 2, 1 } - 0.5 * k1 ^ 2 * obj.data.SL{ 2, 2 } -  ...
     ( obj.data.SL{ 1, 1 } - 0.5 * k1 ^ 2 * obj.data.SL{ 1, 2 } ) / k1 ^ 2;
  %  evaluate precomputed double layer potential elements
  DL = obj.data.DL{ 1, 1 } + 0.5 * k1 ^ 2 * obj.data.DL{ 1, 2 };

  %  integration points 
  [ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
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

  %  smooth Green function and derivative
  [ G, F ] = green( pos1, pos2, k1 );

  %  evaluation functions
  at = @( f, k ) f( :, :, :, k );
  oint = @( H, f1, f2 ) galerkin.pot1.layer.oint( H, f1, f2 );
  %  single layer potential
  SL = SL +  ...
    oint( G, at( f1, 1 ), at( f2, 1 ) ) +  ...
    oint( G, at( f1, 2 ), at( f2, 2 ) ) +  ...
    oint( G, at( f1, 3 ), at( f2, 3 ) ) - oint( G, fp1, fp2 ) / k1 ^ 2;
  %  double layer potential
  for k = 1 : 3
    DL = DL - oint( F, at( g1, k ), at( f2, k ) ) -  ...
              oint( F, at( f1, k ), at( g2, k ) );
  end
  
  %  deal with previously computed SL and DL data
  if ~isempty( varargin )
    data = deal( varargin{ : } );
    %  loop over refinement elements
    for it = 1 : numel( obj.i1 )
      [ i1, i2 ] = deal( obj.i1( it ), obj.i2( it ) );
      data.SL( i1, :, i2, : ) = SL( it, :, : );
      data.DL( i1, :, i2, : ) = DL( it, :, : );
    end  
  else
    %  save SL and DL potential
    data.SL = SL;
    data.DL = DL;
  end
end


function [ G, F ] = green( pos1, pos2, k1 )
  %  GREEN - Smooth Green function and derivative.

  %  positions
  pos1 = tensor( pos1, [ 1, 2, 4 ] );
  pos2 = tensor( pos2, [ 1, 3, 4 ] );
  %  distance
  d = sqrt( dot( pos1 - pos2, pos1 - pos2, 4 ) );
  d = double( d( 1, 2, 3 ) );
  %  Green function and derivative
  g0 = exp( 1i * k1 * d ) ./ d;
  G = g0 - ( 1 ./ d - 0.5 * k1 ^ 2 * d );
  F = ( 1i * k1 - 1 ./ d ) .* g0 ./ d - ( - 1 ./ d .^ 2 - 0.5 * k1 ^ 2 ) ./ d;

  %  multiply with prefactor
  G = G / ( 4 * pi );
  F = F / ( 4 * pi );
end
