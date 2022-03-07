function [ obj, i1, i2 ] = slice( obj )
%  SLICE - Slice integration points.
%
%  Usage for obj = quadboundary :
%    obj = slice( obj )

n = numel( obj.tau );
i1 = 1 : fix( n / 2 );
i2 = fix( n / 2 ) + 1 : n;
%  slice integration points
obj = [ obj, obj ];
obj( 1 ).tau = obj( 1 ).tau( i1 );
obj( 2 ).tau = obj( 2 ).tau( i2 );
