function [ e, h ] = fields( obj, pt1, varargin )
%  FIELDS - Electromagnetic fields at point positions.
%
%  Usage for obj = galerkin.solution :
%    [ e, h ] = fields( obj, pt1, PropertyPairs )
%  Input
%    pt1        :  point positions
%  PropertyName
%    relcutoff  :  cutoff for refined integration
%    memax      :  slice integration into bunches of size MEMAX
%    waitbar    :  show waitbar during evaluation
%  Output
%    e          :  electric field at requested points
%    h          :  magnetic field at requested points

%  potential integrator
pot = galerkin.pot2.engine( varargin{ : } );
pot = set( pot, pt1, obj.tau, varargin{ : } );
%  evaluate fields
[ e, h ] = fields( pot, obj, varargin{ : } );
