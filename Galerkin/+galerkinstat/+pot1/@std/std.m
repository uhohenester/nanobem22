classdef std < galerkinstat.pot1.base
  %  Default evaluation of quasistatic BEM potentials.
  
  properties
    pt1       %  quadrature points for first boundary
    pt2       %  quadrature points for second boundary
    rules     %  quadrature rules 
  end
  
  properties (Dependent, Hidden)
    npts      %  number of integration points for initialization
    tau1      %  first set of boundary elements
    tau2      %  second set of boundary elements    
  end 
  
  methods 
    function obj = std( varargin )
      %  Initialize default evaluation of BEM potentials.
      %
      %  Usage :
      %    obj = galerkinstat.pot1.std( PropertyPairs )
      %  PropertyName
      %    'rules'      :  quadrature rules
      obj = init( obj, varargin{ : } );
    end
    
    function n = get.npts( obj )
      %  Number of integration points for initialization.
      n = feval( 'npts', obj.pt1 ) * feval( 'npts', obj.pt2 ); 
    end
    %  boundary elements
    function tau = get.tau1( obj ),  tau = obj.pt1.tau;  end
    function tau = get.tau2( obj ),  tau = obj.pt2.tau;  end    
  end
end
