function obj = init( obj, pt, varargin )
%  INIT - Initialize dipole object.
%
%  Usage for obj = galerkin.dipole :
%    obj = init( pt, varargin )
%  Input
%    pt     :  dipole positions

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'engine', galerkin.pot2.engine( varargin{ : } ) );
%  parse input
parse( p, varargin{ : } );

obj.pt = pt;
obj.pot = p.Results.engine;
