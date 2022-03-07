function obj = plottrue( obj, p1, val, varargin )
%  PLOTTRUE - Plot value array with true colors on surface.
%
%  Usage for obj = bemplot :
%    obj = plottrue( obj, p1,      PropertyPairs )
%    obj = plottrue( obj, p1, val, PropertyPairs )
%  Input
%    p1      :  particle boundary
%    val     :  value array

%  initialization functions
inifun  = @( p1 ) valarray( p1, val, 'truecolor', 1 );
inifun2 = @( var )  init2( var, val, 'truecolor', 1 );
%  call plot function
obj = plot( obj, p1, inifun, inifun2, varargin{ : } );
