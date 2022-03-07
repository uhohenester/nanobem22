function obj = set1( obj, tau1, tau2 )
%  SET1 - Set evaluation points and boundary elements for BEM potential.
%
%  Usage for obj = galerkin.pot2.std :
%    pts = set1( obj, tau1, tau2 )
%  Input
%    tau1     :  evaluation points
%    tau2     :  boundary elements

%  initialize potential integrator
if any( tau1( 1 ).imat == tau2( 1 ).inout )
  obj.pt1 = tau1;
  obj.pt2 = quadboundary( tau2, obj.rules );
else
  obj = [];
end
