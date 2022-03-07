function obj = feval1( obj, fun, varargin )
%  FEVAL1 - Update quadrature pair objects using user-defined function.
%
%  Usage for obj = quadpair :
%    obj = feval( obj, fun,      PropertyPairs )
%    obj = feval( obj, fun, ind, PropertyPairs )
%  Input
%    fun  :  user-defined update function
%    ind  :  index to selected objects
%  PropertyName
%    'waitbar'    :  display waitbar
%    'name'       :  name of waitbar

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'ind', ones( size( fun ) ) );
addParameter( p, 'waitbar', 0 );
addParameter( p, 'name', 'quadpair' );
%  parse input
parse( p, varargin{ : } );

%  index to selected elements
ind = find( p.Results.ind );
%  initialize waitbar
if p.Results.waitbar
  n = horzcat( obj( ind ).npts );
  multiWaitbar( p.Results.name, 0, 'Color', 'r', 'CanCancel', 'on' );
end

%  loop over selected elements
for i1 = 1 : numel( ind )
  %  update function
  obj( ind( i1 ) ) = feval( fun, obj( ind( i1 ) ) );
  %  update waitbar
  if p.Results.waitbar
    multiWaitbar( p.Results.name, sum( n( 1 : i1 ) ) / sum( n ) );
  end
end
%  close waitbar
if p.Results.waitbar,  multiWaitbar( p.Results.name, 'close' );  end
