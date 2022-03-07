classdef std < galerkinstat.pot2.base
  %  Default evaluation of quasistatic potentials.
  
  properties
    pt1       %  evaluation points
    pt2       %  quadrature points for boundary
    rules     %  quadrature rules 
    initialize = false
  end
  
  properties (Dependent, Hidden)
    npts      %  number of integration points for initialization
    tau1      %  evaluation points
    tau2      %  boundary elements    
  end 
  
  methods 
    function obj = std( varargin )
      %  Initialize default evaluation of BEM potentials.
      %
      %  Usage :
      %    obj = galerkinstat.pot2.std( PropertyPairs )
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
