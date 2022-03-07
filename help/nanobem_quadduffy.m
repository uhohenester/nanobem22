%% quadduffy
%
% Duffy integration is used in the Galerkin scheme for common triangles or
% triangles sharing a vertex or an edge. We use the integration rules of
%
% * D'Elia et al., Int. J. Num. Methods in Biomed. Eng. 27, 314 (2011)
% * Sarraf et al., Comp. Appl. Math. 33, 63 (2014)
%
%% Initialization

%  initialization for product-type boundary elements TAU1, TAU2
obj = quadduffy( tau1, tau2, n );
%  initialization for boundary elements TAU1, TAU2 of same size
obj = quadduffy( tau1, tau2, n, 'rows', 1 );

%%
% * *|tau1|* first set of boundary elements
% * *|tau2|* second set of boundary elements
% * *|n|* number of integration Legendre-Gauss points (default value 3)
% * *|obj|* array of Duffy integrators

%% Methods
%
% The |quadduffy| object can be evaluated for boundary elements using
% linear or Raviart-Thomas shape elements. For the linear shape elements
% |tau| is a <nanobem_stat_boundaryvert.html BoundaryVert> object.

%  evaluate integrator
%    pos1   -  quadrature points for first boundary [ntau,nw,3]
%    pos2   -  quadrature points for second boundary [ntau,nw,3]
%    f1,f2  -  linear shape functions [ntau,nw,npoly]
[ pos1, f1 ] = eval( obj, 1 );
[ pos1, f1 ] = eval( obj, 1 );
%  quadrature weights [ntau,nw]
w = obj.w;

%%
% For the Raviart-Thomas shape elements |tau| is a
% <nanobem_ret_boundaryedge.html BoundaryEdge> object.

%  evaluate integrator
%    pos1     -  quadrature points for first boundary [ntau,nw,3]
%    pos2     -  quadrature points for second boundary [ntau,nw,3]
%    f1,f2    -  Raviart-Thomas shape functions [ntau,nw,npoly,3]
%    f1p,f2p  -  derivatives of F1,F2
[ pos1, f1, f1p ] = eval( obj, 1 );
[ pos2, f2, f2p ] = eval( obj, 2 );
%  quadrature weights [ntau,nw]
w = obj.w;

%% Examples
%
% * <matlab:edit('demoquadduffy01') demoquadduffy01.m> |-| Plot quadrature
% points for identical and touching triangles.
% * <matlab:edit('demoquadduffy02') demoquadduffy02.m> |-| Apply quadrature
% rules for Duffy integration.
%
% Copyright 2022 Ulrich Hohenester
