function obj = init( obj, varargin )
%  INIT - Initialize BEM solution.
%
%  Usage for obj = galerkin.solution :
%    obj = init( obj, tau, k0, e, h )
%  Input
%    tau    :  vector of boundary elements
%    k0     :  wavelength of light in vacuum
%    e      :  electric field coefficients
%    h      :  magnetic field coefficients

[ obj.tau, obj.k0, obj.e, obj.h ] = deal( varargin{ : } );
