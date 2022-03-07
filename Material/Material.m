classdef Material
  %  Material properties of linear materials.
  
  properties
    epsfun    %  function for permittivity
    mufun     %  function for permeability
              %    functions return eps, mu in units of free-space values
  end
  
  properties  %  complex square root function for resonance modes
    zsqrt = @zsqrt     
  end
  
  methods
    function obj = Material( varargin )
      %  Set material properties.
      %
      %  Usage :
      %    obj = Material( epsfun, mufun )
      %  Input
      %    epsfun   :  constant value or function handle for permittivity
      %    mufun    :  constant value or function handle for permeability
      %                  val = fun( ene ) internally uses energies in eV
      obj = init( obj, varargin{ : } );
    end
    
    function varargout = subsref( obj, s )
      %  Evaluate material properties.
      %
      %  Usage for obj = Material :
      %    eps = obj.eps( k0 )
      %    mu  = obj.mu(  k0 )
      %    n   = obj.n(   k0 )
      %    Z   = obj.Z(   k0 )
      %    k   = obj.k(   k0 )
      %  Input
      %    k0     :  wavenumber of light in vacuum (1/nm)
      %  Output
      %    eps    :  permittivity
      %    mu     :  permeability
      %    n      :  refractive index
      %    Z      :  impedance
      %    k      :  wavenumber in medium
      switch s( 1 ).type
        case '.'
          switch s( 1 ).subs           
            case 'eps'
              k0 = s( 2 ).subs{ 1 };
              varargout{ 1 } = obj.epsfun( k0 );
            case 'mu'
              k0 = s( 2 ).subs{ 1 };
              varargout{ 1 } = obj.mufun( k0 );
            case 'n'
              k0 = s( 2 ).subs{ 1 };
              varargout{ 1 } = obj.zsqrt( obj.mufun( k0 ) ) .* obj.zsqrt( obj.epsfun( k0 ) );
            case 'Z'
              k0 = s( 2 ).subs{ 1 };
              varargout{ 1 } = obj.zsqrt( obj.mufun( k0 ) ) ./ obj.zsqrt( obj.epsfun( k0 ) );
            case 'k'
              k0 = s( 2 ).subs{ 1 };
              varargout{ 1 } =  ...
                         k0 .* obj.zsqrt( obj.mufun( k0 ) ) .* obj.zsqrt( obj.epsfun( k0 ) );
            otherwise
              [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
          end
        otherwise
          [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
      end
    end
  end  %  end methods
  
  
  methods (Access = private)
    function obj = init( obj, eps, mu )
      %  INIT - Initialize material properties.
      
      %  material functions use eV, internal functions use k0 (1/nm)
      eV2nm = 1 / 8.0655477e-4;
      
      %  permittivity
      if isa( eps, 'numeric' )
        obj.epsfun = @( k0 ) eps;
      else
        obj.epsfun = @( k0 ) eps( eV2nm / ( 2 * pi ) * k0 );
      end      
     %  permeability
      if isa( mu, 'numeric' )
        obj.mufun = @( k0 ) mu;
      else
        obj.mufun = @( k0 ) mu( eV2nm / ( 2 * pi ) * k0 ); 
      end
    end       
  end  %  end private methods
  
end  %  end classdef
