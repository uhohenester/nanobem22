function eps = epsdrude( key )
%  EPSDRUDE - Drude dielectric function, table 7.1.
%
%  Usage :
%    eps = epsdrude( key )
%  Init
%    key    :  'Ag', 'Au', 'Al'
%  Output
%    eps    :  function handle for evaluation of Drude dielectric function

switch key
  case 'Ag'
    [ epsb, wp, tau ] = deal( 3.3, 9, 30 );
  case 'Au'
    [ epsb, wp, tau ] = deal( 10,  9, 10 ); 
  case 'Al'
    [ epsb, wp, tau ] = deal(  1,  15,  1 );
end

%  damping constant, 1 fs -> 0.66 eV
gamma = 0.66 / tau;
%  dielectric function
eps = @( w ) epsb - wp ^ 2 ./ ( w .* ( w + 1i * gamma ) );
