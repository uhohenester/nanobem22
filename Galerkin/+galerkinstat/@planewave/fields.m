function e = fields( obj, pt, ~ )
%  FIELDS - Electric fields for planewave excitation.
%
%  Usage for obj = galerkinstat.planewave :
%    e = fields( obj, pt, k0 )
%  Input
%    pt     :  integration points
%    k0     :  wavelength of light in vacuum
%  Output
%    e      :  electric field

e = repmat(  ...
  reshape( obj.pol .', [ 1, size( obj.pol .' ) ] ), numel( pt ), 1, 1 );
