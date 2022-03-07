classdef duffy2 < galerkin.pot1.base
  %  Duffy integration of BEM potentials with series expansion.
  
  properties
    nduffy    %  number of Legendre-Gauss points for integration
    pts       %  quadrature points and rules for Duffy integration
    order     %  order for series expansion
    rules2    %  quadrature rules for remaining integration
    initialize = true
  end 
  
  properties (Hidden)
    data        %  precomputed data for series expansion
    pt1         %  quadrature points for remaining integration 
    pt2         %  quadrature points for remaining integration
  end  
  
  properties (Dependent, Hidden)
    npts      %  number of integration points for initialization
    tau1      %  first set of boundary elements
    tau2      %  second set of boundary elements
  end 
  
  methods 
    function obj = duffy2( varargin )
      %  Initialize Duffy integration for evaluation of BEM potentials.
      %
      %  Usage :
      %    obj = galerkin.pot1.duffy2( PropertyPairs )
      %  PropertyName
      %    'nduffy'   :  number of Legendre-Gauss points for integration
      %    'rules2'   :  quadrature rules for remaining integration      
      %    'order'    :  order for series expansion
      obj = init( obj, varargin{ : } );
    end
    
    function n = get.npts( obj )
      %  Number of integration points for initialization.
      n = feval( 'npts', obj.pts );
    end  
    %  boundary elements
    function tau = get.tau1( obj ),  tau = obj.pts.tau1;  end
    function tau = get.tau2( obj ),  tau = obj.pts.tau2;  end    
  end
end
