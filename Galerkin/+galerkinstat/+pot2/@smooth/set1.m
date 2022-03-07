function obj = set1( obj, tau1, tau2 )
%  SET1 - Set boundary elements for BEM potential evaluation.
%
%  Usage for obj = galerkinstat.pot2.smooth :
%    pts = set1( obj, tau1, tau2 )
%  Input
%    tau1   :  evaluation points
%    tau2   :  boundary elements

%  select boundary elements for refined integration
[ obj.i1, obj.i2 ] = find( bdist2( tau1, tau2 ) <= obj.relcutoff );
%  initialize potential integrator
if ~isempty( obj.i1 )
  obj.pt1 = tau1( obj.i1 );  
  obj.pt2.tau = tau2( obj.i2 );
else
  obj = [];
end
