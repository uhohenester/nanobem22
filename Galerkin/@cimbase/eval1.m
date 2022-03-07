function data = eval1( obj, varargin )
%  EVAL1 - Evaluate contour integrals.
%
%  Usage for obj = cimbase :
%    data = eval1( obj,      PropertyPairs )
%    data = eval1( obj, bem, PropertyPairs )
%  Input
%    bem    :  boundary element method solver

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'bem', [] );
addParameter( p, 'waitbar', 0 );
%  parse input
parse( p, varargin{ : } );

%  BEM solver
if ~isempty( p.Results.bem )
  bem = p.Results.bem;
else
  bem = galerkin.bemsolver( obj.tau, varargin{ : } );
end

%  degrees of freedom
n = ndof( obj.tau );
%  random matrix
rng( obj.seed );
Vr = rand( n * 2, obj.nr ) + 1i * rand( n * 2, obj.nr );
%  allocate integrands
nz = obj.nz;
A = num2cell( repelem( 0, 2 * nz ) );
%  initialize waitbar
nt = numel( obj.contour );
if p.Results.waitbar,  multiWaitbar( 'CIM solver', 0, 'Color', 'g' );  end
%  contour integral
for it = 1 : nt
  %  integration points and weights
  z = obj.contour( it ).z;
  w = obj.contour( it ).w;
  %  convert energy to wavenumber
  eV2nm = 1 / 8.0655477e-4;
  k0 = 2 * pi * z / eV2nm;
  %  solve BEM equation
  cal = calderon( bem, k0 );
  u = cal \ Vr;
  %  add to integrands
  for iz = 1 : 2 * obj.nz
    A{ iz } = A{ iz } + z ^ ( iz - 1 ) * w * u / ( 2i * pi );
  end
  
  %  update waitbar
  if p.Results.waitbar,  multiWaitbar( 'CIM solver', it / nt );  end
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( 'CloseAll' );  end

%  deal with CIM(nz)
ind = arrayfun( @( k ) k : k + nz - 1, 0 : nz - 1, 'uniform', 0 );
ind = vertcat( ind{ : } );
[ A{ 1 }, A{ 2 } ] =  ...
    deal( cell2mat( A( ind + 1 ) ), cell2mat( A( ind + 2 ) ) );

%  singular value decomposition
[ data.v, s, data.w ] = svd( A{ 1 }, 'econ' );
data.s = diag( s );
%  set additional output
data.bem = bem;
data.A1 = A{ 2 };
data.waitbar = p.Results.waitbar;
