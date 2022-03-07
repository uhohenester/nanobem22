function obj = set1( obj, tau1, tau2 )
  %  SET1 - Set boundary elements for quasistatic BEM potential evaluation.
  %
  %  Usage for obj = galerkinstat.pot1.duffy :
  %    pts = set1( obj, tau1, tau2 )
  %  Input
  %    tau1     :  first set of boundary elements
  %    tau2     :  second set of boundary elements
  
  %  initialize potential integrator
  quad = quadduffy( tau1, tau2, obj.nduffy );
  if ~isempty( quad( 1 ).tau1 )
    obj = arrayfun( @( pts ) fun( obj, pts ), quad, 'uniform', 0 );
    obj = horzcat( obj{ : } );
  else
    obj = [];
  end
  %  set indices
  for it = 1 : numel( obj )
    obj( it ).i1 = indexin( obj( it ).tau1, tau1 );
    obj( it ).i2 = indexin( obj( it ).tau2, tau2 );
  end
end

function obj = fun( obj, pts )
  % FUN - Set quadrature points.
  obj.pts = pts;
end

function ind = indexin( tau1, tau2 )
  %  INDEXIN - Find TAU1 in TAU2.
  [ ~, ind ] = ismember( vertcat( tau1.pos ), vertcat( tau2.pos ), 'rows' );
end
