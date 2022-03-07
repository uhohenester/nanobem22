function obj = init( ~, tau, varargin )
%  INIT - Initialize point iterator.
%
%  Usage :
%    obj = init( ~, tau, ind, PropertyPairs )
%  Input
%    tau        :  points
%    nu         :  point indices (optional)
%  PropertyName
%    'memax'    :  slice points into bunches of size MEMAX

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'nu', 1 : numel( tau ) );
addParameter(  p, 'memax', 1e6 );
%  parse input
parse( p, varargin{ : } );

%  unique indices
imat = horzcat( tau.imat );
ind = unique( imat );
%  allocate output
obj = cell( 1, numel( ind ) );
%   group together points in different materials
for i = 1 : numel( ind )
  %  iterator
  it = iterpoints;
  i1 = imat == ind( i );
  it.nu = p.Results.nu( i1 );
  it.tau = tau( i1 );
  %  set output
  obj{ i } = it;
end

%  slice iterator into sufficiently small groups
obj = slice( horzcat( obj{ : } ), p.Results );
