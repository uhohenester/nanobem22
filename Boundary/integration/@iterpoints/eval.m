function pos = eval( obj )
%  EVAL - Evaluate point positions.
%
%  Usage for obj = iterpoints :
%    pos = eval( obj )
%  Output
%    pos    :  point positions

pos = vertcat( obj.tau.pos );
