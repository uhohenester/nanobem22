function obj = set1( obj, tau1, tau2 )
%  SET1 - Set boundary elements for BEM potential evaluation.
%
%  Usage for obj = galerkin.pot1.refine2 :
%    pts = set1( obj, tau1, tau2 )
%  Input
%    tau1   :  first set of boundary elements
%    tau2   :  second set of boundary elements

%  select boundary elements for refined integration
[ obj.i1, obj.i2 ] = find( bdist2( tau1, tau2 ) <= obj.relcutoff );
%  initialize potential integrator
if ~isempty( obj.i1 )
  obj.pt1 = quadboundary( tau1( obj.i1 ), obj.rules1 );
  obj.pt2 = quadboundary( tau2( obj.i2 ), obj.rules1 );
else
  obj = [];
end
