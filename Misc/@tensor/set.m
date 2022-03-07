function varargout = set( varargin )
%  SET - Initialize tensor objects.
%
%  Usage for obj = tensor :
%    [ obj1, obj2, ... ] = tensor.set( val1, val2, ... )
%  Input
%    val    :  multidimensional array

%  initialize tensor objects
obj = cellfun( @( x ) tensor( x ), varargin, 'uniform', 0 );
%  set output
[ varargout{ 1 : nargout } ] = deal( obj{ : } );
