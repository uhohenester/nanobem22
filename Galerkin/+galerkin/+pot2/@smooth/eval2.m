function data = eval2( obj, k1, varargin )
%  EVAL2 - Evaluate single and doble layer potential.
%
%  Usage for obj = galerkin.pot2.smooth :
%    data = eval2( obj, k1 )
%    data = eval2( obj, k1, data )
%  Input
%    k1     :  wavenumber of light in medium
%    data   :  previously computed SL and DL terms
%  Output
%    data   :  single and double layer potential

%  evaluate precomputed single layer potential elements
data.SL = obj.data.SL{ 2, 1 } - 0.5 * k1 ^ 2 * obj.data.SL{ 2, 2 } +  ...
        ( obj.data.SL{ 1, 1 } - 0.5 * k1 ^ 2 * obj.data.SL{ 1, 2 } ) / k1 ^ 2;
%  evaluate precomputed double layer potential elements
data.DL = obj.data.DL{ 1, 1 } + 0.5 * k1 ^ 2 * obj.data.DL{ 1, 2 }; 

[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
%  evaluation and integration points 
pos1 = vertcat( pt1.pos );
[ pos2, w2, f2, fp2 ] = eval( pt2 );
%  multiply shape functions with integration weights
f2  = reshape( bsxfun( @times, reshape( f2,  numel( w2 ), [] ), w2( : ) ), size( f2  ) );
fp2 = reshape( bsxfun( @times, reshape( fp2, numel( w2 ), [] ), w2( : ) ), size( fp2 ) );
 
%  dummy indices for internal tensor class
[ i, a2, q2, k ] = deal( 1, 2, 3, 4 );
%  convert positions and shape functions to tensors
pos1 = tensor( pos1, [ i, k ] );
pos2 = tensor( pos2, [ i, q2, k ] );
f2  = tensor( f2,  [ i, q2, a2, k ] );
fp2 = tensor( fp2, [ i, q2, a2    ] );

%  Green function and derivative
d = sqrt( dot( pos1 - pos2, pos1 - pos2, k ) );
g0 = exp( 1i * k1 * d ) ./ d;
G = g0 - ( 1 ./ d - 0.5 * k1 ^ 2 * d );
F = ( 1i * k1 - 1 ./ d ) * g0 ./ d - ( - 1 ./ d .^ 2 - 0.5 * k1 ^ 2 ) ./ d;
%  multiply with prefactor
G = G / ( 4 * pi );
F = F / ( 4 * pi );

%  single and double layer potentials, Hohenester Eq. (5.34-35)
SL = sum( G * f2 + ( pos1 - pos2 ) * F * fp2 / k1 ^ 2, q2 );
DL = sum( - cross( pos1 - pos2, F * f2, k ), q2 );
%  add to precomputed values
data.SL = data.SL + double( SL, [ i, a2, k ] );
data.DL = data.DL + double( DL, [ i, a2, k ] );

%  deal with previously computed SL and DL data
if ~isempty( varargin )
  [ SL, DL, data ] = deal( data.SL, data.DL, varargin{ : } );
  %  loop over refinement elements
  for it = 1 : numel( obj.i1 )
    [ i1, i2 ] = deal( obj.i1( it ), obj.i2( it ) );
    data.SL( i1, i2, :, : ) = SL( it, :, : );
    data.DL( i1, i2, :, : ) = DL( it, :, : );
  end
end
