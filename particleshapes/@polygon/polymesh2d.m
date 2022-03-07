function [ verts, faces ] = polymesh2d( obj, varargin )
%  Call mesh2d functions with polygons.
%
%  Usage for obj = polygon :
%    [ verts, faces ] = polymesh2d( obj, 'Propertypairs )
%  PropertyName
%    hdata  :  pass hdata to mesh2d
%    op     :  pass options structure to mesh2d
%  Output
%    verts  :  vertices of 2D traingulation of mesh2d
%    faces  :  faces of 2D triangulation of mesh2d

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'hdata', [] );
addParameter( p, 'op', struct( 'output', false ) );
%  parse input
parse( p, varargin{ : } );

%  put all polygons together and make triangulation
[ pos, cnet ] = union( obj );

warning off MATLAB:delaunayn:DuplicateDataPoints
warning off MATLAB:tsearch:DeprecatedFunction
[ verts, faces ] = mesh2d( pos, cnet, p.Results.hdata, p.Results.op );
