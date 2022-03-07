function [ pot, e ] = eval( obj, sol, varargin )
%  EVAL - Compute potential and electric field.
%
%  Usage for obj = galerkinstat.pot2.base :
%
%  Usage for obj = galerkin.pot2.base :
%    [ v, e ] = eval( obj, sol, PropertyPairs )
%  Input
%    sol        :  solution of quasistatic BEM equation
%  PropertyName
%    waitbar    :  show waitbar during evaluation
%  Output
%    pot        :  quasistatic potential at requested points
%    e          :  electric field at requested points

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'waitbar', 0 );
addParameter( p, 'name', 'galerkinstat.pot2.base.eval' );
%  parse input
parse( p, varargin{ : } );

%  surface charge at boundary
sig = reshape( sol.sig, size( sol.sig, 1 ), [] );
%  dummy indices for internal tensor class
[ nu1, nu2, j, k ] = deal( 1, 2, 3, 4 );

%  split potential integrators at PARENT positions into cell array
obj = mat2cell( obj );
%  allocate output
n = max( cellfun( @( x ) max( x( 1 ).pt1.nu( : ) ), obj, 'uniform', 1 ) );
[ pot, e ] = deal( zeros( n, size( sig, 2 ) ), zeros( n, 3, size( sig, 2 ) ) );

%  initialize waitbar
if p.Results.waitbar
  npts = cellfun( @( x ) x( 1 ).npts, obj, 'uniform', 1 );
  multiWaitbar( p.Results.name, 0, 'Color', 'r', 'CanCancel', 'on' );
end

for it = 1 : numel( obj )
  %  evaluate Green functions
  data = eval2( obj{ it }( 1 ) );
  %  refinement loop
  for i2 = 2 : numel( obj{ it } )
    data = eval2( obj{ it }( i2 ), data );
  end
  
  %  evaluation points and boundary elements 
  [ pt1, pt2 ] = deal( obj{ it }( 1 ).pt1, obj{ it }( 1 ).pt2 );
  %  Green function and derivative
  n1 = size( data.G, 1 );
  G  = tensor( reshape( data.G,  n1,    [] ), [ nu1,    nu2 ] );
  G1 = tensor( reshape( data.G1, n1, 3, [] ), [ nu1, k, nu2 ] );
  %  potential and electric field
  pot1 = sum( G  * tensor( sig( vertcat( pt2.tau.nu ), : ), [ nu2, j ] ), nu2 );
  e1 = - sum( G1 * tensor( sig( vertcat( pt2.tau.nu ), : ), [ nu2, j ] ), nu2 );
  %  convert to numeric
  pot( pt1.nu, : ) = pot( pt1.nu, : ) + double( pot1, [ nu1, j ] );
  e( pt1.nu, :, : ) = e( pt1.nu, :, : ) + double( e1, [ nu1, k, j ] );
  
  if p.Results.waitbar
    multiWaitbar( p.Results.name, sum( npts( 1 : it ) ) / sum( npts ) );
  end
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( p.Results.name, 'Close' );  end

%  reahape output
siz = size( sol.sig );
pot = reshape( pot, [ n, siz( 2 : end ) ] );
e  = reshape( e, [ n, 3, siz( 2 : end ) ] );
