classdef potbase3
  %  Basic integrals for BEM single and double layer potentials.
  %  See Hänninen et al., PIERS 63, 243 (2006).

  properties
    tau     %  vector of boundary elements
    val     %  prefactors for shape elements
    order   %  number of odd orders for singularity extraction
  end
  
  properties (Hidden = true)
    verts   %  vertices
    nvec    %  normal vector
    mvec    %  edge normal
  end
  
  methods
    function obj = potbase3( varargin )
      %  Initialize basic integrals for BEM potentials.
      %
      %  Usage :
      %    obj = potbase3( tau, PropertyPair )
      %  Input
      %    tau    :  vector of triangle boundary elements
      %  PropertyName
      %    order  :  number of odd orders for singularity extraction
      obj = init( obj, varargin{ : } );
    end
  end
end
