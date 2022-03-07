function obj = init( tau1, tau2, varargin )
  %  INIT - Initialize quadrature rules for Duffy transformation.
  %
  %  Usage for obj = quadduffy :
  %    obj = quadduffy( tau1, tau2, n, PropertyPairs )
  %  Input
  %    tau1     :  first  set of boundary elements
  %    tau2     :  second set of boundary elements
  %    n        :  number of Legendre-Gauss points for integration
  %  PropertyName
  %    'rows'   :  same size of TAU1 and TAU2

  %  set up parser
  p = inputParser;
  p.KeepUnmatched = true;
  addOptional( p, 'n', 3 );
  addParameter( p, 'rows', 0 );
  %  parse input
  parse( p, varargin{ : } );

  %  touching elements with common face, edge or vertex
  if p.Results.rows
    n = touching( tau1, tau2, 'rows' );
    idx = 1 : numel( n );
  else
    n = touching( tau1, tau2 );
    [ i1, i2 ] = find( n );
    if ~isempty( i1 )
      [ idx, n ] = deal( sub2ind( size( n ), i1, i2 ), n( n ~= 0 ) );
      [ tau1, tau2 ] = deal( tau1( i1 ), tau2( i2 ) );
    else
      obj = quadduffy;
      return
    end
  end 
  %  vertices of boundary elements
  verts1 = reshape( round( vertices( tau1( : ) ), 6 ), [], 3 );
  verts2 = reshape( round( vertices( tau2( : ) ), 6 ), [], 3 );
  %  unique vertices and index array
  verts = unique( [ verts1; verts2 ], 'rows' );
  [ ~, i1 ] = ismember( verts1, verts, 'rows' );  i1 = reshape( i1, [], 3 );
  [ ~, i2 ] = ismember( verts2, verts, 'rows' );  i2 = reshape( i2, [], 3 );

  %  initialize output
  obj = repelem( quadduffy, 1, 3 );
  %  loop over common vertex, edge and face
  for i = 1 : 3
    %  index to elements
    it = find( n( : ) == i );
    obj( i ).it = idx( it );
    if isempty( it ),  continue;  end
    %  save boundary elements
    obj( i ).tau1 = tau1( it );
    obj( i ).tau2 = tau2( it );
  
    %  quadrature points using Duffy transformation
    switch i
      case 1
        %  common vertex
        obj( i ).mode = 'vert';
        obj( i ).quad = quadvert( p.Results.n );
        obj( i ).shift = shiftvert( i1( it, : ), i2( it, :  ) );
      case 2
        %  common edge
        obj( i ).mode = 'edge';
        obj( i ).quad = quadedge( p.Results.n );
        obj( i ).shift = shiftedge( i1( it, : ), i2( it, : ) );
      case 3
        %  common face
        obj( i ).mode = 'face';
        obj( i ).quad = quadface( p.Results.n );
    end
  end

  %  set return value
  i1 = arrayfun( @( x ) ~isempty( x.it ), obj, 'uniform', 1 );
  obj = obj( i1 );
end


function shift = shiftvert( faces1, faces2 )
  %  SHIFTVERT - Shift values for integration points of common vertex.

  %  allocate shifting
  [ shift1, shift2 ] = deal( zeros( size( faces1, 1 ), 1 ) );

  %  loop over triangle vertices
  for a1 = 1 : 3
  for a2 = 1 : 3
    ind = faces1( :, a1 ) == faces2( :, a2 );
    %  set shift indices
    [ shift1( ind ), shift2( ind ) ] = deal( a1, a2 );
  end
  end
  %  set output
  shift = { shift1, shift2 };
end

function shift = shiftedge( faces1, faces2 )
  %  SHIFTEDGE - Shift value for integration points of common edge.

  faces1 = faces1( :, [ 1, 2, 3, 1 ] );
  faces2 = faces2( :, [ 1, 3, 2, 1 ] );
  %  allocate shifting
  [ shift1, shift2 ] = deal( zeros( size( faces1, 1 ), 1 ) );
  
  fun1 = @( i1 ) faces1( :, [ i1, i1 + 1 ] );
  fun2 = @( i2 ) faces2( :, [ i2, i2 + 1 ] );
  %  loop over triangle edges
  for a1 = 1 : 3
  for a2 = 1 : 3
    ind = all( fun1( a1 ) == fun2( a2 ), 2 );  
    [ shift1( ind ), shift2( ind ) ] = deal( a1, -a2 );
  end
  end
  %  set output
  shift = { shift1, shift2 };
end

function obj = slice( obj, memax )
  %  SLICE - Slice integration points into bunches of size MEMAX

  if isscalar( obj ) && npts( obj ) > memax
    %  slice integration points
    n = size( obj.tau1 );
    i1 = 1 : fix( n / 2 );
    i2 = fix( n / 2 ) + 1 : n;
    
    [ obj1, obj2 ] = deal( obj );
    %  slice boundary elements
    [ obj1.tau1, obj1.tau2 ] = deal( obj.tau1( i1 ), obj.tau2( i1 ) );
    [ obj2.tau1, obj2.tau2 ] = deal( obj.tau1( i2 ), obj.tau2( i2 ) );
    %  slice indices
    [ obj1.it, obj2.it ] = deal( obj.it( i1 ), obj.it( i2 ) );
    
    %  slice shift values
    if ~isempty( obj.shift )
      obj1.shift{ 1 } = obj.shift{ 1 }( i1 );
      obj1.shift{ 2 } = obj.shift{ 2 }( i1 );
      obj2.shift{ 1 } = obj.shift{ 1 }( i2 );
      obj2.shift{ 2 } = obj.shift{ 2 }( i2 );
    end
    %  continue with slicing
    obj = slice( [ obj1, obj2 ], memax );
    
  elseif ~isscalar( obj )
    obj = arrayfun( @( x ) slice( x, memax ), obj, 'uniform', 0 );
    obj = horzcat( obj{ : } );
  end  
end
