function obj = plot( obj, opt, varargin )
%  PLOT - Plot value array.
%
%  Usage for obj = valarray :
%    obj = plot( obj, opt, PropertyPairs )
%  Input
%    opt            :  plot options
%  PropertyName
%    'FaceAlpha'    :  alpha value of faces

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'FaceAlpha', 1 );
%  parse input
parse( p, varargin{ : } );

%  get value array
val = subsref( obj, substruct( '()', { opt } ) );

if isempty( obj.h )
  obj.h = patch(  ...
      struct( 'vertices', obj.p.verts, 'faces', obj.p.faces ),  ...
      'FaceVertexCData', val, 'FaceColor', 'interp',            ...
      'EdgeColor', 'none', 'FaceAlpha', p.Results.FaceAlpha );
else
  set( obj.h, 'FaceVertexCData', val );
  set( obj.h, 'FaceAlpha', p.Results.FaceAlpha );  
end
