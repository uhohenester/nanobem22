function obj = init( obj, pol, dir, varargin )
%  INIT - Initialize plane wave object.
%
%  Usage for obj = galerkin.planewave :
%    obj = init( obj, pol, varargin )
%  Input
%    pol    :  polarizations of plane waves

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules', quadboundary.rules );
addParameter( p, 'imat', 1 );
%  parse input
parse( p, varargin{ : } );

%  plane wave polarization and light propagation direction
obj.pol = pol;
obj.dir = dir;
%  integration rules and index for embedding medium
obj.rules = p.Results.rules;
obj.imat  = p.Results.imat;
 
