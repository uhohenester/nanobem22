function obj = eval( fun, obj1, obj2 )
%  EVAL - Evaluate indexed tensor operation.

if isnumeric( obj1 )
  %  OBJ1 is numeric
  obj = obj2;
  obj.val = bsxfun( fun, obj.val, obj1 );
  
elseif isnumeric( obj2 )
  %  OBJ2 is numeric
  obj = obj1;
  obj.val = bsxfun( fun, obj.val, obj2 );
  
else
  %  OBJ1 and OBJ2 are tensors
  idx = obj1.idx( ismember( obj1.idx, obj2.idx ) );
  %  OBJ1 and OBJ2 have no common indices
  if isempty( idx )
    obj = tensor( bsxfun( fun, obj1.val( : ), reshape( obj2.val, 1, [] ) ) );
    obj.siz = [ obj1.siz, obj2.siz ];
    obj.idx = [ obj1.idx, obj2.idx ];
  else
    %  bring common indices to front
    idx = num2cell( idx );
    [ obj1, idx1 ] = idxfront( obj1, idx{ : } );
    [ obj2, idx2 ] = idxfront( obj2, idx{ : } );
    %  value arrays 
    val1 = obj1.val;  
    val2 = obj2.val;  
    %  size of unmatched dimensions
    siz1 = obj1.siz( ismember( obj1.idx, idx1 ) );  n1 = prod( siz1 );
    siz2 = obj2.siz( ismember( obj2.idx, idx2 ) );  n2 = prod( siz2 );   
    %  increase size of first array 
    val1 = repmat( reshape( val1, [], 1, n1 ), 1, n2, 1 );
    %  multiply arrays
    val = bsxfun( fun, reshape( val1, [], n1 ), val2( : ) );
    siz = [ obj1.siz( ~ismember( obj1.idx, idx1 ) ), siz2, siz1 ];
    idx = [ obj1.idx( ~ismember( obj1.idx, idx1 ) ), idx2, idx1 ];
    %  set output
    obj = tensor( val );
    [ obj.siz, obj.idx ] = deal( siz, idx );
  end
end
