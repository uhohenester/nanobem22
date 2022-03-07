function obj = cross( obj1, obj2, idx )
%  CROSS - Cross product along indexed dimension.

%  bring index to front
obj1 = idxfront( obj1, idx );
obj2 = idxfront( obj2, idx );

%  shift array circularly
obj1.val = circshift( obj1.val, 2 );
obj2.val = circshift( obj2.val, 1 );
%  obj1.val( [ 2, 3, 1 ], : ) * obj2.val( [ 3, 1, 2 ] )
obj = obj1 * obj2;

%  shift array circularly
obj1.val = circshift( obj1.val, 2 );
obj2.val = circshift( obj2.val, 1 );
%  obj1.val( [ 3, 1, 2 ], : ) * obj2.val( [ 2, 3, 1 ] )
obj = obj - obj1 * obj2;
