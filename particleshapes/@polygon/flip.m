function obj = flip( obj, varargin )
%  FLIP - Flip polygon along given direction.
%
%  Usage for obj = polygon :
%    obj = flip( obj, dir )
%  Input
%    dir  :  direction for flipping

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'dir', 1 );
%  parse input
parse( p, varargin{ : } );

obj.pos( :, p.Results.dir ) = - obj.pos( :, p.Results.dir );
