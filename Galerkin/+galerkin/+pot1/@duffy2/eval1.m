function obj = eval1( obj )
%  EVAL1 - Precomute elements for single and double layer potential.

%  precompute series expansion
obj.data = galerkin.pot1.layer.series1( obj.order, obj.pts );
%  change quadrature points for boundaries
if ~isempty( obj.rules2 )
  obj.pt1 = quadboundary( obj.tau1, obj.rules2 );
  obj.pt2 = quadboundary( obj.tau2, obj.rules2 );
end
