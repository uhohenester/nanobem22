function val = double( obj, varargin )
%  DOUBLE - Return value array.

if ~isempty( varargin ),  obj = at( obj, varargin{ : } );  end

if isscalar( obj.siz )
  val = obj.val;
else
  val = reshape( obj.val, obj.siz );
end
