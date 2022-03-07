function obj = set( obj, varargin )
%  SET - Set properties of POLYGON3 objects.
%
%  Usage for obj = polygon3 :
%    obj = set( obj, PropertyPair )
%  PropertyName
%    'z'      :  z-value 
%    'dir'    :  direction for extrusion
%    'edge'   :  edge profile

for it = 1 : numel( obj )
  for i = 1 : 2 : numel( varargin )
    try
      obj( it ).( varargin{ i } ) = varargin{ i + 1 };
    catch
      %  set values of POLYGON
      obj( it ).poly.( varargin{ i } ) = varargin{ i + 1 };
    end
  end
end
