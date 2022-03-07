function [ G, F ] = green( obj, varargin )
%  Green - Compute Green function and normal derivative.
%
%  Usage for obj = galerkinstat.pot1.base :
%    [ G, F ] = green( obj, varargin )
%  PropertyName
%    waitbar  :  show waitbar during evaluation
%  Output
%   G     :  Green function
%   F     :  normal derivative of Green function

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'waitbar', 0 );
addParameter( p, 'name', 'galerkinstat.base.green' );
%  parse input
parse( p, varargin{ : } );

if p.Results.waitbar
  n = arrayfun( @( x ) x.npts, obj, 'uniform', 1 );
  it = 1;
  multiWaitbar( p.Results.name, 0, 'Color', 'r', 'CanCancel', 'on' );
end

%  split array at PARENT positions into cell array
obj = mat2cell( obj );
%  number of degrees of freedom
n1 = max( cellfun( @( x ) ndof( x( 1 ).tau1 ), obj, 'uniform', 1 ) );
n2 = max( cellfun( @( x ) ndof( x( 1 ).tau2 ), obj, 'uniform', 1 ) );

%  allocate output
[ G, F ] = deal( zeros( n1, n2 ) );

%  loop over integrators
for i1 = 1 : numel( obj )
  %  boundary elements and global degrees of freedom
  tau1 = obj{ i1 }( 1 ).tau1;  nu1 = vertcat( tau1.nu );
  tau2 = obj{ i1 }( 1 ).tau2;  nu2 = vertcat( tau2.nu );
    
  %  evaluate Green function and normal derivative
  data = [];
  for pt = obj{ i1 }
    data = eval2( pt, data );
  end
    
  %  accumulate matrix
  [ nu1, nu2 ] = ndgrid( nu1( : ), nu2( : ) );
  fun = @( x ) accumarray( { nu1( : ), nu2( : ) }, x( : ), [ n1, n2 ] );
  %  assemble Green function and normal derivative
  G = G + fun( data.G );
  F = F + fun( data.F );
  
  %  update waitbar
  if p.Results.waitbar
    multiWaitbar( p.Results.name, sum( n( 1 : it ) ) / sum( n ) );
    it = it + 1;
  end  
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( p.Results.name, 'close' );  end
