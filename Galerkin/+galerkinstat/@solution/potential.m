function pot = potential( obj, pt1, varargin )
%  POTENTIAL - Quasistatic potential at point positions.
%
%  Usage for obj = galerkinstat.solution :
%    pot = potential( obj, pt1, PropertyPairs )
%  Input
%    pt1        :  point positions
%  PropertyName
%    relcutoff  :  cutoff for refined integration
%    memax      :  slice integration into bunches of size MEMAX
%    waitbar    :  show waitbar during evaluation
%  Output
%    pot        :  quasistatic potential at requested points

%  potential integrator
pot = galerkinstat.pot2.engine( varargin{ : } );
pot = set( pot, pt1, obj.tau, varargin{ : } );
%  evaluate fields
[ pot, ~ ] = eval( pot, obj, varargin{ : } );
