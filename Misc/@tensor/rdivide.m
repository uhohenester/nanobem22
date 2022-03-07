function obj = rdivide( obj1, obj2 )
%  RDIVIDE - Tensor division.

obj2.val = 1 ./ obj2.val;
obj = obj1 * obj2;
