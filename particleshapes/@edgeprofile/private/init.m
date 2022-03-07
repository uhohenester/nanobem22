function obj = init( obj, varargin )
%  INIT - Initialize edge profile.
%
%  Usage for obj = edgeprofile :
%    obj = init( obj )
%    obj = init( edgeprofile, height,     PropertyPair )
%    obj = init( edgeprofile, height, nz, PropertyPair )
%    obj = init( edgeprofile, pos,     z, PropertyPair )
% Input
%    height   :  height of particle
%    nz       :  number of z-values
%    pos      :  (z,d) values for edge profile
%    z        :  z-values for extruding polygon
%  PropertyName
%    'e'      :  exponent of supercircle
%    'dz'     :  z in [ - height + dz, height - dz ] / 2 for d >= 0
%    'min'    :  minimal z-value of edge profile
%    'max'    :  maximal z-value of edge profile
%    'center' :  central z-value of edge profile
%    'mode'   :  '00', '10', '01', '11', '20', '02' with
%                rounded (0), no (1) and partially rounded (2) edge

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'e', 0.4 );
addParameter( p, 'dz', 0.15 );
addParameter( p, 'mode', '00' );
addParameter( p, 'min', [] );
addParameter( p, 'max', [] );
addParameter( p, 'center', [] );
    
%  explicit constructor with POS and Z
if numel( varargin{ 1 } ) ~= 1
  [ obj.pos, obj.z ] = deal( varargin{ 1 : 2 } );
  %  parse input
  parse( p, varargin{ 3 : end } );
else
  if numel( varargin ) == 1 || ~isnumeric( varargin{ 2 } )
    %  extract height
    [ height, nz ] = deal( varargin{ 1 }, 7 );
    %  parse input
    parse( p, varargin{ 2 : end } );    
  else
    %  extract height and NZ
    [ height, nz ] = deal( varargin{ 1 : 2 } );
    %  parse input
    parse( p, varargin{ 3 : end } );   
  end
  
  if strcmp( p.Results.mode, '11' )
    %  edge profile
    obj.pos = [ NaN, 0; 0, - 0.5 * height; 0, 0.5 * height; NaN, 0 ];
    %  representative z-values
    obj.z = linspace( - 0.5, 0.5, nz ) * height;
  else   
    %  supercircle
    pows =  @( z ) ( sign( z ) .* abs( z ) .^ p.Results.e );
    %  angles
    phi = reshape( pi / 2 * linspace( - 1, 1, 51 ), [], 1 );

    x = pows( cos( phi ) );
    z = pows( sin( phi ) );

    [ ~, ind ] = min( abs( z - ( 1 - p.Results.dz ) ) );

    %  make edge profile
    obj.pos = 0.5 * height * [ x - x( ind ), z ];
    %  representative values along z 
    z = linspace( - 1, 1, nz );
    obj.z = obj.pos( ind, 2 ) * abs( z ) .^ p.Results.e .* sign( z );
  
    %  indices
    ind2 = obj.pos( :, 2 ) >  0  &  obj.pos( :, 1 ) >= 0;
    ind3 = obj.pos( :, 2 ) == 0;
    ind4 = obj.pos( :, 2 ) <  0  &  obj.pos( :, 1 ) >= 0;
    ind5 = obj.pos( :, 2 ) <  0  &  obj.pos( :, 1 ) <  0;
      
    %  sharp upper edge
    if p.Results.mode( 1 ) ~= '0'
      %  shift value
      dz = 0.5 * height - max( obj.pos( ind2, 2 ) );
      %  modify d-value for upper positions
      if p.Results.mode( 1 ) == '1' 
        obj.pos( ind2, 1 ) = max( obj.pos( ind2, 1 ) );
      end
      %  modify z-value for upper positions
      obj.pos( ind2, 2 ) = obj.pos( ind2, 2 ) + dz;
      %  keep selected positions and z-values
      obj.pos = [ obj.pos( ind2 | ind3 | ind4 | ind5, : ); NaN, 0 ];
      obj.z( obj.z > 0 ) = obj.z( obj.z > 0 ) + dz;
    end
    
    %  indices
    ind1 = obj.pos( :, 2 ) >  0  &  obj.pos( :, 1 ) <  0;
    ind2 = obj.pos( :, 2 ) >  0  &  obj.pos( :, 1 ) >= 0;
    ind3 = obj.pos( :, 2 ) == 0;
    ind4 = obj.pos( :, 2 ) <  0  &  obj.pos( :, 1 ) >= 0;
    
    %  sharp lower edge      
    if p.Results.mode( 2 ) ~= '0'
      %  shift value
      dz = 0.5 * height + min( obj.pos( ind4, 2 ) );
      %  modify d-value for lower positions
      if p.Results.mode( 2 ) == '1'        
        obj.pos( ind4, 1 ) = max( obj.pos( ind4, 1 ) );
      end
      %  modify z-value for lower positions
      obj.pos( ind4, 2 ) = obj.pos( ind4, 2 ) - dz;
      %  keep selected positions and z-values
      obj.pos = [ NaN, 0; obj.pos( ind1 | ind2 | ind3 | ind4, : ) ];
      obj.z( obj.z < 0 ) = obj.z( obj.z < 0 ) - dz;        
    end
  end
end

%  handle shift arguments
if ~isempty( p.Results.max )
  dz = p.Results.max - max( obj.pos( :, 2 ) );
elseif ~isempty( p.Results.min )
  dz = p.Results.min - min( obj.pos( :, 2 ) );
elseif ~isempty( p.Results.center )
  dz = p.Results.center;
else
  dz = 0;
end
%  shift positions and z-values
[ obj.pos( :, 2 ), obj.z ] = deal( obj.pos( :, 2 ) + dz, obj.z + dz );
