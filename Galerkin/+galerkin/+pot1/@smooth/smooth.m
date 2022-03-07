classdef smooth < galerkin.pot1.base
  %  Refined integration of BEM potentials using analytic expression.
  
  properties
    pt1         %  quadrature points for first boundary
    pt2         %  quadrature points for second boundary   
    rules       %  quadrature rules for singular term
    rules2      %  quadrature rules for smooth term
    relcutoff   %  relative cutoff for refined integration
    initialize = true
  end
  
  properties (Hidden)
    data        %  precomputed data for series expansion
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
      %    obj = galerkin.pot1.smooth( PropertyPairs )
      %  PropertyName
      %    'rules'      :  quadrature rules for singular term
      %    'rules2'     :  quadrature rules for smooth term
      %    'order'      :  orders for series expansion
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
