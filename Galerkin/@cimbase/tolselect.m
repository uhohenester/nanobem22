function tol = tolselect( obj, data, varargin )
%  TOLSELECT - Select CIM tolerance interactively from figure.
%
%  Usage for obj = cimbase :
%    tol = tolselect( obj, data )
%  Input
%    data   :  auxiliary information from previous call to EVAL1.

  %  set up parser
  p = inputParser;
  p.KeepUnmatched = true;
  addParameter( p, 'tol', 1e-2 );
  %  parse input
  parse( p, varargin{ : } );

  nev = nnz( data.s >= p.Results.tol * max( data.s ) );
  %  plot sinular values
  figure
  semilogy( data.s, '.', 'Color', 0.7 * [ 1, 1, 1 ] );  hold on
  h.pts1 = semilogy( data.s( 1 : nev ), 'r.' ); 
  %  annotate plot
  xlabel( 'Eigenmode' );
  ylabel( 'Singular value' );

  %  set figure name
  fig = gcf;
  fig.Name = sprintf( '(nev=%i)', nev ); 

  %  red line
  h.line1 = plot( get( gca, 'XLim' ), data.s( nev ) * [ 1, 1 ], 'r-' );
  %  add input data to user space
  fig.UserData =  ...
    struct( 'cim', obj, 'data', data, 'tol', p.Results.tol, 'h', h );
  %  track mouse position and change TOL when mouse button is pressed
  fig.WindowButtonMotionFcn = @MotionFcn;
  fig.WindowButtonDownFcn = @ClickFcn;
  fig.DeleteFcn = @DeleteFcn;

  %  add icons to toolbar
  icon1 = geticon( '/toolbox/matlab/icons/tool_ellipse.gif', '' );
  icon2 = geticon( '/toolbox/matlab/icons/greenarrowicon.gif', '' );
  icon3 = geticon( '/toolbox/matlab/icons/greencircleicon.gif', 'r' );

  %  get toolbar icons
  tbh = findall( fig, 'Type', 'uitoolbar' );
  %  add icons for contour plotting, continue and discard
  uipushtool( tbh, 'CData', icon1,  ...
          'HandleVisibility','off', 'TooltipString', 'Plot contour',  ...
          'ClickedCallback', @( ~, ~ ) PlotContour( fig ) );
  uipushtool( tbh, 'CData', icon2,  ...
          'HandleVisibility','off', 'TooltipString', 'Accept and continue',  ...
          'ClickedCallback', @( ~, ~ ) ContinueFcn( fig ) );  
  uipushtool( tbh, 'CData', icon3,  ...
          'HandleVisibility','off', 'TooltipString', 'Dismiss',  ...
          'ClickedCallback', @( ~, ~ ) uiresume );    
    
  %  wait until TOL is accepted or discarded
  uiwait;
  if isvalid( fig ) && isfield( fig.UserData, 'continue' )
    tol = fig.UserData.tol;
  else
    tol = [];
  end
  if isvalid( fig ),  close( fig );  end
end      
      
function icon = geticon( finp, color )
  %  GETICON - Get icons.
  
  icon = fullfile( matlabroot, finp );
  [ cdata, map ] = imread( icon );
  % convert white pixels into a transparent background
  map( sum( map, 2 ) == 3 ) = NaN;
  
  switch color
    case 'r'
      map( 4 : 6, : ) = [ 1, 0, 0; 1, 0, 0; 1, 0, 0 ];
  end
  % Convert to RGB space
  icon = ind2rgb( cdata, map );
end

function MotionFcn( fig, ~ )
  %  MotionFcn - Track position of mouse and draw red line.
  
  % get mouse position
  y = fig.CurrentAxes.CurrentPoint( 1, 2 );
  %  update mouse cursor 
  udata = fig.UserData;
  if y < udata.data.s( 1 ) && y > udata.data.s( end )
    udata.h.line1.YData = [ y, y ]; 
    drawnow;
  end
end

function ClickFcn( fig, ~ )
  %  ClickFcn - Set new value for TOL.
  
  % get mouse position
  y = fig.CurrentAxes.CurrentPoint( 1, 2 );
  %  new tolerance
  udata = fig.UserData;
  udata.tol = min( 1, y / udata.data.s( 1 ) );
  
  %  update figure
  nev = nnz( udata.data.s >= udata.tol * udata.data.s( 1 ) );
  s = udata.data.s( 1 : nev );
  set( udata.h.pts1, 'XData', 1 : numel( s ), 'YData', s );
  %  update user data and title
  fig.UserData = udata;
  fig.Name = sprintf( '(nev=%i)', nev );
end

function ContinueFcn( fig )
  %  ContinueFcn - Accept selection and continue.
  fig.UserData.continue = 1;
  uiresume;
end

function DeleteFcn( fig, ~ )
  %  DeleteFcn - Function to be called when figure is deleted.
  
  %  close contour plot ?
  udata = fig.UserData;
  if isfield( udata, 'fig2' ) && isvalid( udata.fig2 )
    close( udata.fig2 );
  end
end
  
function PlotContour( fig )
  %  PlotContour - Plot contour in new figure.
  
  %  get user data and contour
  udata = fig.UserData;
  cont = udata.cim.contour;
  z = horzcat( cont.z );
  %  plot contour
  figure;
  plot( [ z, z( 1 ) ], '.-' );  hold on
  %  annotate plot
  xlabel( 'x (eV)' );
  ylabel( 'y (eV)' );
  
  %  compute and plot energies
  udata.cim = eval2( udata.cim, udata.data, 'tol', udata.tol, 'norm', 0 );
  plot( udata.cim.ene, 'r+' );
  %  set plot range
  x = [ min( real( z ) ), max( real( z ) ) ];  hx = x( 2 ) - x( 1 );
  y = [ min( imag( z ) ), max( imag( z ) ) ];  hy = y( 2 ) - y( 1 );
  xlim( [ x( 1 ) - 0.1 * hx, x( 2 ) + 0.1 * hx ] );
  ylim( [ y( 1 ) - 0.1 * hy, y( 2 ) + 0.1 * hy ] );
end
