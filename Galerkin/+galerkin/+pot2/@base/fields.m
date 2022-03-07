function [ e, h ] = fields( obj, sol, varargin )
%  FIELDS - Electromagnetic fields at point positions.
%
%  Usage for obj = galerkin.pot2.base :
%    [ e, h ] = fields( obj, sol, PropertyPairs )
%  Input
%    sol        :  solution of BEM equation
%  PropertyName
%    waitbar    :  show waitbar during evaluation
%  Output
%    e          :  electric field at requested points
%    h          :  magnetic field at requested points

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'waitbar', 0 );
addParameter( p, 'name', 'galerkin.pot2.base.fields' );
%  parse input
parse( p, varargin{ : } );

%  tangential fields at boundary
ue = reshape( sol.e, size( sol.e, 1 ), [] );
uh = reshape( sol.h, size( sol.h, 1 ), [] );
%  wavenumber of light in vacuum
k0 = sol.k0;
%  dummy indices for internal tensor class
[ nu1, nu2, j, k ] = deal( 1, 2, 3, 4 );

%  split potential integrators at PARENT positions into cell array
obj = mat2cell( obj );
%  allocate output
n = max( cellfun( @( x ) max( x( 1 ).pt1.nu( : ) ), obj, 'uniform', 1 ) );
[ e, h ] = deal( zeros( n, 3, size( ue, 2 ) ) );

%  initialize waitbar
if p.Results.waitbar
  n1 = cellfun( @( x ) x( 1 ).npts, obj, 'uniform', 1 );
  multiWaitbar( p.Results.name, 0, 'Color', 'r', 'CanCancel', 'on' );
end

for it = 1 : numel( obj )
  %  evaluate SL and DL potential
  data = potential( obj{ it }, k0 );
  %  evaluation points and boundary elements 
  [ pt1, pt2 ] = deal( obj{ it }( 1 ).pt1, obj{ it }( 1 ).pt2 );
  mat = pt1.mat( pt1.imat );
  %  particle inside or outside
  sig = [ 1, -1 ];
  sig = sig( pt1.imat == pt2.inout );
    
  %  single and double layer potential
  SL = tensor( data.SL, [ nu1, nu2, k ] );
  DL = tensor( data.DL, [ nu1, nu2, k ] );
  %  electric and magnetic fields
  e1 = sum( SL * tensor( ue( vertcat( pt2.tau.nu ), : ), [ nu2, j ] ), nu2 );
  e2 = sum( DL * tensor( ue( vertcat( pt2.tau.nu ), : ), [ nu2, j ] ), nu2 );
  h1 = sum( SL * tensor( uh( vertcat( pt2.tau.nu ), : ), [ nu2, j ] ), nu2 );
  h2 = sum( DL * tensor( uh( vertcat( pt2.tau.nu ), : ), [ nu2, j ] ), nu2 );
  %  convert to numeric
  [ e1, h1 ] = deal( double( e1, [ nu1, k, j ] ), double( h1, [ nu1, k, j ] ) );
  [ e2, h2 ] = deal( double( e2, [ nu1, k, j ] ), double( h2, [ nu1, k, j ] ) );          
         
  e( pt1.nu, :, : ) =  ...
  e( pt1.nu, :, : ) - sig * (   1i * k0 * mat.mu(  k0 ) * h1 - e2 );
  h( pt1.nu, :, : ) =  ...
  h( pt1.nu, :, : ) - sig * ( - 1i * k0 * mat.eps( k0 ) * e1 - h2 );  
  
  if p.Results.waitbar
    multiWaitbar( p.Results.name, sum( n1( 1 : it ) ) / sum( n1 ) );
  end
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( p.Results.name, 'Close' );  end

%  reshape output
siz = size( sol.e );
e = reshape( e, [ n, 3, siz( 2 : end ) ] );
h = reshape( h, [ n, 3, siz( 2 : end ) ] );
