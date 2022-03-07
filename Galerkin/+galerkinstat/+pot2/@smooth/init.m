function obj = init( obj, varargin )
%  INIT - Initialize analytic integration for quasistatic potentials.
%
%  Usage for obj = galerkinstat.pot2.smooth :
%    obj = init( obj, PropertyPairs )
%  PropertyName
%    'relcutoff'  :  relative cutoff for refined integration

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'relcutoff', 2 );
%  parse input
parse( p, varargin{ : } );

obj.relcutoff = p.Results.relcutoff;
