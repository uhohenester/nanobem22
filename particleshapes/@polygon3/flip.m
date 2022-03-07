function obj = flip( obj, dir )
%  FLIP - Flip polygon along given axis.
%
%  Usage for obj = polygon3 :
%    obj = flip( obj, dir )
%  Input
%    dir    :  direction along which polygon is flipped

obj.poly = flip( obj.poly, dir );
