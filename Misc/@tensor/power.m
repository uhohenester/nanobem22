function a = power( a, b )
%  POWER - Element-wise power.

switch class( a )
  case 'tensor'
    a.val = a.val .^ b;
  otherwise
    [ a, b ] = deal( b, a );
    a.val = b .^ a.val;
end
