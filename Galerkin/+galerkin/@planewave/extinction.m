function cext = extinction( obj, sol )
%  EXTINCTION - Extinction cross section.
%
%  Usage for obj = galerkin.planewave :
%    cext = extinction( obj, sol )
%  Input
%    sol    :  solution of BEM equation
%  Output
%    cext   :  extinction cross section

%  material properties and material index of embedding medium
mat = sol.tau( 1 ).mat;
imat = obj.imat;

%  electromagnetic far fields in light propagation directions
dir = Point( mat, imat, obj.dir );
efar = squeeze( farfields( sol, dir ) );
if ~ismatrix( efar )
  efar = arrayfun(  ...
    @( k ) squeeze( efar( k, :, k ) ), 1 : numel( dir ), 'uniform', 0 );
  efar = vertcat( efar{ : } );
end
%  extinction cross section, Hohenster Eq. (4.27)
mat = mat( imat );
efar = reshape( efar, [], 3 );
cext = 4 * pi / mat.k( sol.k0 ) * imag( dot( obj.pol, efar, 2 ) );
