function data = eval2( obj, varargin )
%  EVAL2 - Analytic evaluation for selected points and boundary elements.
%
%  Usage for obj = galerkinstat.pot2.smooth :
%    data = eval2( obj )
%    data = eval2( obj, data )
%  Input
%    data   :  previously computed Green function data
%  Output
%    data     :  Green function data

%  initialize object?
if isempty( obj.data );  obj = eval1( obj );  end

if isempty( varargin )
  %  use previously computed Green function elements
  data = obj.data;
else
  %  deal with previously computed BEM potentials
  data = deal( varargin{ : } );
  %  loop over refinement elements
  for it = 1 : numel( obj.i1 )
    [ i1, i2 ] = deal( obj.i1( it ), obj.i2( it ) );
    data.G( i1, i2, : ) = obj.data.G( it, : );
    data.G1( i1, :, i2, : ) = obj.data.G1( it, :, : );
    data.F1( i1, :, i2, : ) = obj.data.F1( it, :, : );
  end
end
