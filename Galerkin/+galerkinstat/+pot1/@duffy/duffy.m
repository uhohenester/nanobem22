classdef duffy < galerkinstat.pot1.base
  %  Duffy integration of quasistatic BEM potentials.
  
  properties
    nduffy    %  number of Legendre-Gauss points for integration
    pts       %  quadrature points and rules for Duffy integration
  end 
  
  properties (Dependent, Hidden)
    npts      %  number of integration points for initialization
    tau1      %  first set of boundary elements
    tau2      %  second set of boundary elements
  end 
  
  methods 
    function obj = duffy( varargin )
      %  Initialize Duffy integration for evaluation of BEM potentials.
      %
      %  Usage :
      %    obj = galerkinstat.pot1.duffy( PropertyPairs )
      %  PropertyName
      %    'nduffy'   :  number of Legendre-Gauss points for integration
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
