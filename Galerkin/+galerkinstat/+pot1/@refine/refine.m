classdef refine < galerkinstat.pot1.base
  %  Refined integration of quasistatic BEM potentials.
  
  properties
    pt1         %  quadrature points for first boundary
    pt2         %  quadrature points for second boundary   
    rules1      %  quadrature rules
    relcutoff   %  relative cutoff for refined integration
  end
    
  properties (Dependent, Hidden)
    npts      %  number of integration points 
    tau1      %  first set of boundary elements
    tau2      %  second set of boundary elements     
  end 
  
  methods 
    function obj = refine( varargin )
      %  Initialize refined evaluation of quasistatic BEM potentials.
      %
      %  Usage :
      %    obj = galerkinstat.pot1.refine1( PropertyPairs )
      %  PropertyName
      %    'rules1'     :  quadrature rules for refined integration
      %    'relcutoff'  :  relative cutoff for refined integration
      obj = init( obj, varargin{ : } );
    end
    
    function n = get.npts( obj )
      %  Number of integration points.
      n = numel( obj.pt1.tau ) *  ...
          numel( obj.pt1.quad.w ) * numel( obj.pt2.quad.w );
    end
    %  boundary elements
    function tau = get.tau1( obj ),  tau = obj.pt1.tau;  end
    function tau = get.tau2( obj ),  tau = obj.pt2.tau;  end       
  end
end
