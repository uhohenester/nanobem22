function obj = eval2( obj, data, varargin )
%  EVAL2 - Evaluate eigenvalues, Unger et al., PRL 121, 246802 (2018).
%
%  Usage for obj = galerkin.cimbase :
%    cim = eval2( obj, data, PropertyPairs )
%  Input
%    data   :  results from previous call to EVAL1
%  PropertyName
%    tol    :  tolerance for SVD
%    nev    :  number of eigenvalues to be kept
%    norm   :  flag for normalization computation

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'norm', 1 );
%  parse input
parse( p, varargin{ : } );

%  evaluate eigenvalues using super class method
obj = eval2@cimbase( obj, data, varargin{ : } );
%  done ?
if ~p.Results.norm,  return;  end

%  boundary elements and BEM solver 
tau = obj.tau;
bem = data.bem;
%  solution vector and adjoint vector
sol1 = obj.sol;
u1 = vertcat( sol1.e, sol1.h ); 
u2 = vertcat( sol1.h, sol1.e );
%  unique eigenenergies 
[ ~, i1, i2 ] = unique( round( obj.ene, 2 ) );
%  allocate residuum array
obj.res = zeros( 1, numel( obj.ene ) );

nt = numel( i1 );
if data.waitbar,  multiWaitbar( 'CIM solver: norm', 0, 'Color', 'g' );  end
%  loop over unique resonance energies
for it = 1 : nt
  %  derivative of Calderon matrix using finite differences
  eta = 1e-2;
  z1 = obj.ene( i1( it ) );
  z2 = obj.ene( i1( it ) ) + eta;
  %  convert to wavenumber
  eV2nm = 1 / 8.0655477e-4;
  k1 = 2 * pi * z1 / eV2nm;
  k2 = 2 * pi * z2 / eV2nm;
  %  inner product with derivative of Calderon matrix
  ind = i2 == it;
  v1 = calderon( bem, k1 ) * u1( :, ind );
  v2 = calderon( bem, k2 ) * u1( :, ind );
  in = transpose( u2( :, ind ) ) * ( v2 - v1 ) / eta;
  %  residuum and normalization of adjoint vector
  obj.res( ind ) = abs( dot( u1( :, ind ), v1, 1 ) );
  u2( :, ind ) = u2( :, ind ) * transpose( inv( in ) );
  
  %  update waitbar
  if data.waitbar,  multiWaitbar( 'CIM solver: norm', it / nt );  end
end
%  close waitbar
if data.waitbar,  multiWaitbar( 'CloseAll' );  end

%  split adjoint vector into electric and magnetic parts
n = ndof( tau );
obj.sol2 = galerkin.solution( tau, [], u2( 1 : n, : ), u2( n + 1 : end, : ) );
