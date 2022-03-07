classdef bemsolver
  %  BEM solver for quasistatic approximation.
  
  properties
    tau         %  boundary elements
    G           %  quasistatic Green function
    F           %  normal derivative of quasistatic Green function
  end
  
  methods 
    function obj = bemsolver( varargin )
      %  Initialize quasistatic BEM solver.
      %
      %  Usage :
      %    obj = galerkinstat.bemsolver( tau, PropertyPairs )
      %  Input
      %    tau      :  boundary elements
      %  PropertyName
      %    nduffy     :  number of Legendre-Gauss points for Duffy integration
      %    rules      :  default integration rules
      %    rules1     :  integration rules for refinement
      %    relcutoff  :  relative cutoff for refined integration
      %    memax      :  restrict computation to MEMAX boundary elements
      %    waitbar    :  show waitbar during initialization
      obj = init( obj, varargin{ : } );
    end
  end
 
end  
