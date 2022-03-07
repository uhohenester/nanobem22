function obj = mat2cell( obj )
%  MAT2CELL - Split array at PARENT positions into cell array.

%  split array at parent positions
ind = cumsum( horzcat( obj.parent ) );
obj = arrayfun( @( i ) obj( ind == i ), unique( ind ), 'uniform', 0 );
