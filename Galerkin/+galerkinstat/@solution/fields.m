function e = fields( obj, pt1, varargin )
%  FIELDS - Electric fields at point positions.
%
%  Usage for obj = galerkinstat.solution :
%    e = fields( obj, pt1, PropertyPairs )
%  Input
%    pt1        :  point positions
%  PropertyName
%    relcutoff  :  cutoff for refined integration
%    memax      :  slice integration into bunches of size MEMAX
%    waitbar    :  show waitbar during evaluation
%  Output
%    e          :  electric field at requested points

%  potential integrator
pot = galerkinstat.pot2.engine( varargin{ : } );
pot = set( pot, pt1, obj.tau, varargin{ : } );
%  evaluate fields
[ ~, e ] = eval( pot, obj, varargin{ : } );
