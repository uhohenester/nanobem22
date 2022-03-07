function [ obj, i1, i2 ] = slice( obj )
%  SLICE - Slice integration points.

%  slice integration points
n = numel( obj.tau1 );
i1 = 1 : fix( n / 2 );
i2 = fix( n / 2 ) + 1 : n;
    
[ obj1, obj2 ] = deal( obj );
%  slice boundary elements
[ obj1.tau1, obj1.tau2 ] = deal( obj.tau1( i1 ), obj.tau2( i1 ) );
[ obj2.tau1, obj2.tau2 ] = deal( obj.tau1( i2 ), obj.tau2( i2 ) );
%  slice indices
[ obj1.it, obj2.it ] = deal( obj.it( i1 ), obj.it( i2 ) );
    
%  slice shift values
if ~isempty( obj.shift )
  obj1.shift{ 1 } = obj.shift{ 1 }( i1 );
  obj1.shift{ 2 } = obj.shift{ 2 }( i1 );
  obj2.shift{ 1 } = obj.shift{ 1 }( i2 );
  obj2.shift{ 2 } = obj.shift{ 2 }( i2 );
end
%  continue with slicing
obj = [ obj1, obj2 ];
