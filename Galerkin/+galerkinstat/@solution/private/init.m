function obj = init( obj, varargin )
%  INIT - Initialize BEM solution.
%
%  Usage for obj = galerkinstat.solution :
%    obj = init( obj, tau, k0, sig )
%  Input
%    tau    :  vector of boundary elements
%    k0     :  wavelength of light in vacuum
%    sig    :  surface charge distribution

[ obj.tau, obj.k0, obj.sig ] = deal( varargin{ : } );
