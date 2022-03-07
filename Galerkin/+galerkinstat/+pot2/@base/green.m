function data = green( obj )
%  GREEN - Evaluate Green function and derivatives.
%
%  Usage for obj = galerkinstat.pot2.base :
%    data = green( obj, k0 )
%  Output
%    data   :  Green function and derivatives

%  default evaluation
data = eval2( obj( 1 ) );
%  refinement loop
for it = 2 : numel( obj )
  if obj( it ).initialize && isempty( obj( it ).data )
    obj( it ) = eval1( obj( it ) );
  end
  data = eval2( obj( it ), data );
end
