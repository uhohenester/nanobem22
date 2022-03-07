function vol = triple( a, b, c )
%  TRIPLE - Triple product.
  
%  reshape input
siz = size( a );
a = reshape( a, [], 3 );
b = reshape( b, [], 3 );
c = reshape( c, [], 3 );
  
%  triple product
vol = a( :, 1 ) .* ( b( :, 2 ) .* c( :, 3 ) - b( :, 3 ) .* c( :, 2 ) ) +  ...
      a( :, 2 ) .* ( b( :, 3 ) .* c( :, 1 ) - b( :, 1 ) .* c( :, 3 ) ) +  ...
      a( :, 3 ) .* ( b( :, 1 ) .* c( :, 2 ) - b( :, 2 ) .* c( :, 1 ) );
%  reshape output
vol = reshape( vol, siz( 1 : end - 1 ) );
