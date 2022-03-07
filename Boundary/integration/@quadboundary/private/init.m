function obj = init( ~, tau, varargin )
  %  INIT - Initialize quadrature rules for boundary element integration.
  %
  %  Usage :
  %    obj = init( ~, tau, PropertyPairs )
  %  Input
  %    tau        :  vector of boundary elements
  %  PropertyName
  %    'quad3'    :  quadrature points for triangle integration
  %    'quad4'    :  quadrature points for quadrilateral integration
  %    'memax'    :  slice integration into bunches of size MEMAX

  %  set up parser
  p = inputParser;
  p.KeepUnmatched = true;
  addParameter( p, 'quad3', triquad( 3 ) );
  addParameter( p, 'quad4', [] );
  addParameter( p, 'memax', 1e7 );
  %  parse input
  parse( p, varargin{ : } );

  %  number of polygons edges for boundary elements
  npoly = vertcat( tau.nedges );
  %  unique inout values
  inout = vertcat( tau.inout );
  [ ~, i1 ] = unique( inout, 'rows' );

  %  allocate output
  obj = cell( max( npoly ), numel( i1 ) );
  %  loop over different types of boundary elements
  for i = 1 : numel( i1 )
  for ipoly = unique( npoly )
  
    %  quadrature rules
    pt = quadboundary;
    pt.npoly = ipoly;
    %  integration points
    switch ipoly
      case 3
        pt.quad = p.Results.quad3;
    end
   
    %  index to boundary elements
    ind = npoly == ipoly & all( inout == inout( i1( i ), : ), 2 );
    pt.tau = tau( ind );
    %  set output
    obj{ ipoly, i } = pt;
  end
  end

  %  slice object into sufficiently small groups
  obj = fun( horzcat( obj{ : } ), p.Results.memax );
end


function obj = fun( obj, memax )
  %  FUN - Slice integration points into sufficiently small groups.
  if isscalar( obj )
    if npts( obj ) > memax
      obj = fun( slice( obj ), memax );
    end
  else
    obj = arrayfun( @( x ) fun( x, memax ), obj, 'uniform', 0 );
    obj = horzcat( obj{ : } );
  end
end

