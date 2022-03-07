function data = potential( obj, k0 )
%  POTENTIAL - Evaluate single and double layer potential.
%
%  Usage for obj = galerkin.pot2.base :
%    data = potential( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    data   :  single and double layer potential

%  wavenumber of light in medium
mat = obj( 1 ).pt1.mat( obj( 1 ).pt1.imat );
k1 = mat.k( k0 );

%  default evaluation
data = eval2( obj( 1 ), k1 );
%  refinement loop
for it = 2 : numel( obj )
  if obj( it ).initialize && isempty( obj( it ).data )
    obj( it ) = eval1( obj( it ) );
  end
  data = eval2( obj( it ), k1, data );
end

%  reshape potentials
data.SL = reshape( data.SL, size( data.SL, 1 ), [], 3 );
data.DL = reshape( data.DL, size( data.DL, 1 ), [], 3 ); 