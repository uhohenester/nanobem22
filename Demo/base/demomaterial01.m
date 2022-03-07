%  DEMOMATERIAL01 - Materials within nanobem toolobox.

%  silver dielectric function and Drude approximation
mat1 = Material( epstable( 'silver.dat' ), 1 );
mat2 = Material( epsdrude( 'Ag' ), 1 );
%  gold dielectric function and Drude approximation
mat3 = Material( epstable( 'gold.dat' ), 1 );
mat4 = Material( epsdrude( 'Au' ), 1 );

%  photon energies in eV
ene = linspace( 0.75, 3, 51 );
%  convert to wavenumber
units;
lambda = eV2nm ./ ene;
k0 = 2 * pi ./ lambda;

%  dielectric functions
eps1 = mat1.eps( k0 );
eps2 = mat2.eps( k0 );
eps3 = mat3.eps( k0 );
eps4 = mat4.eps( k0 );

%  plot real part of dielctric function
figure
plot( ene, real( eps1 ), '+-', ene, real( eps3 ), '+-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( ene, real( eps2 ), 'o--', ene, real( eps4 ), 'o--' );
    
legend( 'Ag', 'Ag Drude', 'Au', 'Au Drude' );
xlim( [ min( ene ), max( ene ) ] );

xlabel( 'Photon energy (eV)' );
ylabel( 'Dielectric function (real part)' );

%  plot imaginary part of dielctric function
figure
plot( ene, imag( eps1 ), '+-', ene, imag( eps3 ), '+-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( ene, imag( eps2 ), 'o--', ene, imag( eps4 ), 'o--' );
    
legend( 'Ag', 'Ag Drude', 'Au', 'Au Drude' );
xlim( [ min( ene ), max( ene ) ] );

xlabel( 'Photon energy (eV)' );
ylabel( 'Dielectric function (imaginary part)' );

