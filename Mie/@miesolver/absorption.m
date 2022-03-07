function abs = absorption( obj, k0 )
%  ABSORPTION - Absorption cross section for sphere.
%
%  Usage for obj = miesolver :
%    abs = absorption( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    abs    :  absorption cross section

abs = extinction( obj, k0 ) - scattering( obj, k0 );
