function obj = init( obj, varargin )
%  INIT - Initialization of BEMPLOT object.
%
%  Usage for obj = bemplot :
%    obj = init( obj, PropertyPairs )
%  PropertyValue
%    'fun'    :  plot function
%    'scale'  :  scale factor for vector array
%    'sfun'   :  scale function for vector array

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'val', [] );
addParameter( p, 'fun', @( x ) real( x ) );
addParameter( p, 'scale', 1 );
addParameter( p, 'sfun', @( x ) x );
%  parse input
parse( p, varargin{ : } );

%  new figure ?
if isempty( get( 0, 'CurrentFigure' ) ) || isempty( get( gcf, 'CurrentAxes' ) )
  axis off;  axis equal;  axis fill;
  view( 1, 40 );
  %  set context menu
  contextmenu;
end

%  set default values
if isempty( obj.opt )
  obj.opt = struct( 'ind', [],  ...
    'fun', p.Results.fun, 'scale', p.Results.scale, 'sfun', p.Results.sfun );
end

%  set figure name
figname( obj );
