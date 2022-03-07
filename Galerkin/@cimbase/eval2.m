function obj = eval2( obj, data, varargin )
%  EVAL2 - Evaluate eigenvalues.
%
%  Usage for obj = cimbase :
%    cim = eval2( obj, data, PropertyPairs )
%  Input
%    data   :  results from previous call to EVAL1
%  PropertyName
%    tol    :  tolerance for SVD
%    nev    :  number of eigenvalues to be kept

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'tol', 1e-4 );
addParameter( p, 'nev', [] );
%  parse input
parse( p, varargin{ : } );

if isempty( p.Results.nev )
  ind = data.s > p.Results.tol * max( data.s );  
else
  ind = 1 : p.Results.nev;
end

%  convert to linear eigenvalue problem
[ s, v, w ] = deal( data.s( ind ), data.v( :, ind ), data.w( :, ind ) );
B = v' * data.A1 * w * diag( 1 ./ s );
%  solve eigenvalue problem
[ vec, obj.ene ] = eig( B, 'vector' );
u = v * vec;
%  set solution vector
n = ndof( obj.tau );
obj.sol = galerkin.solution( obj.tau, [], u( 1 : n, : ), u( n + 1 : 2 * n, : ) );
                