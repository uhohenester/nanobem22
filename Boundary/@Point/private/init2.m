function obj = init2( obj, tau, pos, varargin )
%  INIT2 - Initialize point embedded in dielectric environment.
%
%  Usage for obj = Point :
%    obj = init( obj, tau, pos )
%  Input
%    tau    :  boundary elements
%    pos    :  point position

%  place positions in dielectric environment
[ ~, imat ] = nearest( tau, pos, varargin{ : } );
%  initialize points
obj = init1( obj, tau( 1 ).mat, imat, pos );
