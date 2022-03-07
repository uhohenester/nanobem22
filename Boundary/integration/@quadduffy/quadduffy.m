classdef quadduffy
  %  Quadrature rules for Duffy transformation.
  
  properties
    tau1      %  first  set of boundary elements
    tau2      %  second set of boundary elements
    quad      %  quadrature rules
    mode      %  'face', 'edge' or 'vert'
  end
  
  properties (Hidden)
    it          %  index to boundary element pair
    shift = []  %  shift values for quadrature points
  end
  
  properties (Dependent)
    w           %  integration weights
  end
  
  methods 
    function obj = quadduffy( varargin )
      %  Initialize quadrature rules for Duffy transformation.
      %
      %  Usage :
      %    obj = quadduffy( tau1, tau2, n, PropertyPairs )
      %  Input
      %    tau1     :  first  set of boundary elements
      %    tau2     :  second set of boundary elements
      %    n        :  number of integration Legendre-Gauss points
      %  PropertyName
      %    'rows'   :  same size of TAU1 and TAU2      
      if ~isempty( varargin ),  obj = init( varargin{ : } );  end
    end
    
    function w = get.w( obj )
      %  Integration weights.
      w = ( vertcat( obj.tau1.area ) .*  ...
            vertcat( obj.tau2.area ) ) * transpose( obj.quad.w );
    end
  end
  
end