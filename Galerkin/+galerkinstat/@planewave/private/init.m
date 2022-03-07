function obj = init( obj, pol, varargin )
%  INIT - Initialize plane wave object.
%
%  Usage for obj = galerkinstat.planewave :
%    obj = init( obj, pol, varargin )
%  Input
%    pol    :  polarizations of plane waves

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'dir', [] );
addParameter( p, 'rules', quadboundary.rules );
addParameter( p, 'imat', 1 );
%  parse input
parse( p, varargin{ : } );

%  plane wave polarization
obj.pol = pol;
%  integration rules and index for embedding medium
obj.rules = p.Results.rules;
obj.imat  = p.Results.imat;
