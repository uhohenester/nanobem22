function eps = epstable( finp )
%  EPSTABLE - Evaluate tabulated dielectric function.
%
%  Usage :
%    eps = epstable( finp )
%  Init
%    FINP must be an ASCII files with "ene n k" in each line
%      ene  :   photon energy (eV)
%      n    :   refractive index (real part)
%      k    :   refractive index (imaginary part)
%  Output
%    eps    :  function handle for evaluation of tabulated dielectric function

%  lead data from input file
fid = fopen( finp );
C = textscan( fid, '%f %f %f', 'CommentStyle', '%' );
fclose( fid );

%  extract input
[ ene, n, k ] = deal( C{ : } );
%  spline interpolation
epsi = spline( ene, ( n + 1i * k ) .^ 2 );
eps = @( w ) epsinterp( w, ene, epsi );


function eps = epsinterp( w, ene, epsi )
%  EPSINTERP - Spline interpolation of dielectric function.
%
%  Usage :
%    eps = epsinterp( w, ene, epsi )
%  Input
%    w      :  energy (eV)
%    ene    :  tabulated energies (eV)
%    epsi   :  spline interpolation for dielectric function

assert( all( w >= min( ene ) ) && all( w <= max( ene ) ),  ...
                'requested photon energy out of range' );
%  spline interpolation
eps = ppval( epsi, w );
