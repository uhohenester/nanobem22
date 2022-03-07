function varargout = subsref( obj, s )
%  Evaluate planewave object.

switch s( 1 ).type
  case  '.'
    switch s( 1 ).subs
      case 'abs'
        varargout{ 1 } = absorption( obj, s( 2 ).subs{ : } );      
      case 'ext'
        varargout{ 1 } = extinction( obj, s( 2 ).subs{ : } );
      case 'sca'
        varargout{ 1 } = scattering( obj, s( 2 ).subs{ : } );        
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end
  case '()'
    varargout{ 1 } = eval( obj, s( 1 ).subs{ : } );
  otherwise
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
end
