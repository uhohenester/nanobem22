classdef smooth < galerkinstat.pot1.base
  %  Refined integration of quasistatic BEM potentials using analytic
  %  expression.
  
  properties
    pt1         %  quadrature points for first boundary
    pt2         %  quadrature points for second boundary   
    rules1      %  quadrature rules 
    relcutoff   %  relative cutoff for refined integration
  end
    
  properties (Dependent, Hidden)
    npts      %  number of integration points for initialization 
    tau1      %  first set of boundary elements
    tau2      %  second set of boundary elements     
  end 
  
  methods 
    function obj = smooth( varargin )
      %  Initialize refined evaluation of BEM potentials.
      %
      %  Usage :
      %    obj = galerkinstat.pot1.smooth( PropertyPairs )
      %  PropertyName
      %    'rules1'     :  quadrature rules for singular term
      %    'relcutoff'  :  relative cutoff for refined integration
      obj = init( obj, varargin{ : } );
    end
    
    function n = get.npts( obj )
      %  Number of integration points for initialization.
      n = numel( obj.pt1.tau ) * numel( obj.pt1.quad.w );
    end
    %  boundary elements
    function tau = get.tau1( obj ),  tau = obj.pt1.tau;  end
    function tau = get.tau2( obj ),  tau = obj.pt2.tau;  end       
  end
end
