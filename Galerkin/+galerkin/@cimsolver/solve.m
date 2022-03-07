function sol = solve( obj, q, varargin )
%  SOLVE - Solve BEM equations using resonance modes.
%
%  Usage for obj = galerkin.cimsolver :
%    sol = solve( obj, q, PropertyPairs )
%  Input
%    q            :  structure with inhomogeneities and wavenumber
%  Output
%    nonresonant  :  add non-resonant contribution
%  Output
%    sol          :  solution with tangential electromagnetic fields

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'nonresonant', ~isempty( obj.nonresonant ) );
%  parse input
parse( p, varargin{ : } );

%  inhomogeneities
n = size( q.e, 1 );
qe = reshape( q.e, n, [] );
qh = reshape( q.h, n, [] );
%  solve BEM equations using resonance modes
u = icalderon( obj, q.k0 ) * [ qe; qh ];
%  add contribution for nonresonant background
if p.Results.nonresonant
  u = u + obj.nonresonant( q.k0 ) * [ q.e; q.h ];
end

%  set output
sol = galerkin.solution( q.tau, q.k0,  ...
  reshape( u( 1 : n, : ), size( q.e ) ), reshape( u( n + 1 : end ), size( q.h ) ) );
