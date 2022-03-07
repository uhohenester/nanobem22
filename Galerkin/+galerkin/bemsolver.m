classdef bemsolver
  %  BEM solver for full Maxwell equations.
  
  properties
    tau     %  boundary elements
    pot     %  potential integrator
  end
  
  properties (Hidden = true)
    ical = []   %  inverse of Calderon matrix, for storage mode only
    k0          %  wavenumber for which Calderon matrix has been computed
  end
  
  methods 
    function obj = bemsolver( varargin )
      %  Initialize BEM solver for full Maxwell equations.
      %
      %  Usage :
      %    obj = galerkin.bemsolver( tau, PropertyPairs )
      %  Input
      %    tau        :  boundary elements
      %  PropertyName
      %    'engine'   :  potential integrator
      obj = init( obj, varargin{ : } );
    end
    
    function [ sol, obj ] = solve( obj, q )
      %  SOLVE - Solve BEM equations.
      %
      %  Usage for obj = galerkin.bemsolver :
      %    sol = solve( obj, q )
      %  Input
      %    q      :  structure with inhomogeneities and wavenumber
      %  Output
      %    sol    :  solution with tangential electromagnetic fields

      %  inhomogeneity vector
      n = ndof( obj.tau );
      vec = reshape( cat( 1, q.e, q.h ), 2 * n, [] );
      %  solve BEM equations once or store results from previous call
      switch nargout
        case 1
          u = calderon( obj.pot, q.k0 ) \ vec;
        case 2
          if isempty( obj.ical ) || obj.k0 ~= q.k0
            [ obj.ical, obj.k0 ] = deal( inv( calderon( obj.pot, q.k0 ) ), q.k0 );
          end
          u = obj.ical * vec;
      end
      %  tangential electric and magnetic field
      ue = reshape( u(     1 : n,   : ), size( q.e ) );
      uh = reshape( u( n + 1 : end, : ), size( q.h ) );
      %  set output
      sol = galerkin.solution( obj.tau, q.k0, ue, uh );
    end
    
    function sol = mldivide( obj, q )
      %  MLDIVIDE - Solve BEM equations.
      sol = solve( obj, q );
    end 
    
    function cal = calderon( obj, k0 )
      %  CALDERON - Calderon matrix.
      cal = calderon( obj.pot, k0 );
    end
  end
   
  methods (Access = private)
    function obj = init( obj, tau, varargin )
      %  INIT - Initialize BEM solver for full Maxwell equations.
      %
      %  Usage for obj = galerkin.bemsolver :
      %    obj = init( obj, tau, PropertyPairs )
      %  Input
      %    tau        :  boundary elements
      %  PropertyName
      %    'engine'   :  engine for potential integration

      %  set up parser
      p = inputParser;
      p.KeepUnmatched = true;
      addParameter( p, 'engine', galerkin.pot1.engine( varargin{ : } ) );
      %  parse input
      parse( p, varargin{ : } );

      %  initialize potential integrator
      obj.pot = set( p.Results.engine, tau, tau, varargin{ : } );
      obj.tau = tau;
    end
  end
  
end  
