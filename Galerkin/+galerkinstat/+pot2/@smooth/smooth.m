classdef smooth < galerkinstat.pot2.base
  %  Refined evaluation of BEM potentials using analytic expression.
  
  properties
    pt1         %  evaluation points
    pt2         %  quadrature points for boundary
    relcutoff   %  relative cutoff for refined integration
    initialize = true
  end
  
  properties (Hidden)
    data = []   %  precomputed data
  end
  
  properties (Dependent, Hidden)
    npts      %  number of integration points for initialization 
    tau2      %  boundary elements     
  end 
  
  methods 
    function obj = smooth( varargin )
      %  Initialize refined evaluation of quasistatic potentials.
      %
      %  Usage :
      %    obj = galerkinstat.pot2.smooth( PropertyPairs )
      %  PropertyName
      %    'relcutoff'  :  relative cutoff for refined integration
      obj = init( obj, varargin{ : } );
    end
    
    function n = get.npts( obj )
      %  Number of integration points for initialization.
      n = numel( obj.pt1 ) * numel( obj.pt2 );
    end
    %  boundary elements
    function tau = get.tau2( obj ),  tau = obj.pt2.tau;  end       
  end
end
