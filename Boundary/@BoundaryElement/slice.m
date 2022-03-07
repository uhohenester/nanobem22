function tau = slice( obj )
%  SLICE - Slice into bunches of equal shape and material parameters.
%
%  Usage for obj = BoundaryElement :
%    tau = slice( obj )
%  Output
%    tau  :  cell array of unique boundary elements

%  number of edges
nedges = horzcat( obj.nedges );
%  allocate output
tau = {};

%  loop over unique boundary elements
for n = unique( nedges )
  %  boundary elements with N edges
  tau1 = obj( n == nedges );
  %  unique material compositions
  inout = vertcat( tau1.inout );
  [ ~, i1, i2 ] = unique( inout, 'rows' );
  %  loop over unique material compositions
  for it = 1 : numel( i1 )
    tau{ end + 1 } = tau1( i2 == it );
  end
end
