function obj = init( obj, tau, varargin )
%  INIT - Initialize contour integral method solver.
%
%  Usage for obj = cimbase :
%    obj = init( obj, tau, PropertyPairs )
%  Input
%    tau      :  boundary elements
%  PropertyName
%    contour  :  energies and weights for contour integration
%    nr       :  number of columns for random matrix
%    nz       :  maximal power for z^n
%    seed     :  seed for random number generator

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'contour', [] );
addParameter( p, 'nr', 50 );
addParameter( p, 'nz', 1 );
addParameter( p, 'seed', 'default' );
%  parse input
parse( p, varargin{ : } );

%  save boundary elements
obj.tau = tau;
%  save parameters for CIM solver
obj.contour = p.Results.contour;
obj.nr = p.Results.nr;
obj.nz = p.Results.nz;
obj.seed = p.Results.seed;
