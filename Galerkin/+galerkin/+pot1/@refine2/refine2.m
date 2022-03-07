classdef refine2 < galerkin.pot1.base
  %  Refined integration of BEM potentials with series expansion.
  
  properties
    pt1         %  quadrature points for first boundary
    pt2         %  quadrature points for second boundary   
    rules1      %  quadrature rules for series integration
    rules2      %  quadrature rules for remaining integration
    relcutoff   %  relative cutoff for refined integration
    order       %  order for series expansion
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
    function obj = refine2( varargin )
      %  Initialize refined evaluation of BEM potentials.
      %
      %  Usage :
      %    obj = galerkin.pot1.refine2( PropertyPairs )
      %  PropertyName
      %    'rules1'     :  quadrature rules for refined integration
      %    'rules2'     :  quadrature rules for remaining integration
      %    'order'      :  orders for series expansion
      %    'relcutoff'  :  relative cutoff for refined integration
      obj = init( obj, varargin{ : } );
    end
    
    function n = get.npts( obj )
      %  Number of integration points for initialization.
      n = numel( obj.pt1.tau ) *  ...
          numel( obj.pt1.quad.w ) * numel( obj.pt2.quad.w );
    end
    %  boundary elements
    function tau = get.tau1( obj ),  tau = obj.pt1.tau;  end
    function tau = get.tau2( obj ),  tau = obj.pt2.tau;  end       
  end
end
