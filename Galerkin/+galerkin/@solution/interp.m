function [ e, h ] = interp( obj, varargin )
%  INTERP - Interpolate BEM solution from edges to faces.
%
%  Usage for obj = galerkin.solution :
%    [ e, h ] = interp( obj, pts, PropertyPairs )
%  Input
%    pts    :  quadrature points
%  PropertyName
%    inout  :  compute fields at boundary inside or outside
%  Output
%    e      :  electric fields at requested points
%    h      :  magnetic fields at requested points

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'pts', [] );
%  parse input
parse( p, varargin{ : } );

if ~isempty( p.Results.pts )
  %  interpolate fields to quadrature points
  [ e, h ] = interp1( obj, varargin{ : } );
else
  %  interpolate fields to centroids
  [ e, h ] = interp2( obj, varargin{ : } );
end
  