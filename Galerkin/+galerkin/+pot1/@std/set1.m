function obj = set1( obj, tau1, tau2 )
%  SET1 - Set boundary elements for BEM potential evaluation.
%
%  Usage for obj = galerkin.pot1.std :
%    pts = set1( obj, tau1, tau2 )
%  Input
%    tau1     :  first set of boundary elements
%    tau2     :  second set of boundary elements

%  initialize potential integrator
obj.pt1 = quadboundary( tau1, obj.rules );
obj.pt2 = quadboundary( tau2, obj.rules );
