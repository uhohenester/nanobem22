function [ ene, u ] = eig( tau, varargin )
  %  EIG - Quasistatic eigenmode solver.
  %
  %  Usage :
  %    [ ene, u ] = galerkinstat.eig( tau, nev, PropertyPairs )
  %  Input
  %    tau        :  boundary elements
  %    nev        :  number of eigenvalues
  %  PropertyName
  %    rules      :  default integration rules
  %    rules1     :  integration rules for refinement
  %    relcutoff  :  relative cutoff for refined integration
  %    memax      :  restrict computation to MEMAX boundary elements
  %    waitbar    :  show waitbar during evaluation
  %  Output
  %    ene        :  eigenvalues
  %    u          :  eigenmodes

  %  set up parser
  p = inputParser;
  p.KeepUnmatched = true;
  addOptional( p, 'nev', 20 );
  %  parse input
  parse( p, varargin{ : } );

  %  Green function and K=F*G matrix for eigenmodes of Ouyang and Isaacson
  [ G, K ] = pot( tau, varargin{ : } );
  %  we have done our best to make the matrices symmetric
  %    we now symmetrize them and hope that everything works properly
  G = 0.5 * ( G + transpose( G ) );
  K = 0.5 * ( K + transpose( K ) );
  
  %  decompose Green function, Hohenester Eq. (9.62)
  [ Q, d ] = eig( G );
  U = sqrt( d ) * transpose( Q );  
  U1 = inv( U );
  %  eigenmodes, Hohenester Eq. (9.63)
  D = transpose( U1 ) * K * U1; 
  [ x, ene ] = eig( 0.5 * ( D + transpose( D ) ), 'vector' );
  u = U1 * x;
  
  %  return NEV eigenmodes
  if ~isempty( p.Results.nev )
    [ ene, u ] = deal( ene( 1 : p.Results.nev ), u( :, 1 : p.Results.nev ) );
  end
end


function [ G, K ] = pot( tau, varargin )
  %  POT1 - Potentials for quasistatic eigenmode solver.
  %
  %  Usage :
  %    [ G, K ] = pot( tau, nev, PropertyPairs )
  %  Input
  %    tau        :  boundary elements
  %    nev        :  number of eigenvalues
  %  PropertyName
  %    rules      :  default integration rules
  %    rules1     :  integration rules for refinement
  %    relcutoff  :  relative cutoff for refined integration
  %    memax      :  restrict computation to MEMAX boundary elements
  %    waitbar    :  show waitbar during initialization

  %  set up parser
  p = inputParser;
  p.KeepUnmatched = true;
  addOptional( p, 'nev', 20 );
  addParameter( p, 'rules',  quadboundary.rules( 'quad3', triquad(  3 ) ) );
  addParameter( p, 'rules1', quadboundary.rules( 'quad3', triquad( 11 ) ) );
  addParameter( p, 'memax', 1e7 );
  addParameter( p, 'waitbar', 0 );
  %  parse input
  parse( p, varargin{ : } );

  %  allocate output
  n = ndof( tau );
  [ G, K ] = deal( zeros( n ) );
  %  boundary integrators
  pt1 = quadboundary( tau, p.Results.rules );
  pt2 = quadboundary( tau, p.Results.rules1, 'memax', fix( p.Results.memax / numel( tau ) ) );

  if p.Results.waitbar,  multiWaitbar( 'galerkinstat.eig', 0, 'Color', 'r' );  end
  %  loop over quadrature points of second boundary
  for i2 = 1 : numel( pt2 )
  
    %  integration weights, and linear shape functions
    [ ~, w2, f2 ] = eval( pt2( i2 ) );
    %  compute submatrices
    [ G1, F1 ] = fun( pt1, pt2( i2 ), n, varargin{ : } );
  
    %  accumulate G*F matrix
    K = K + reshape( F1, n, [] ) *  ...
      bsxfun( @times, reshape( G1, n, [] ), reshape( w2, 1, [] ) ) .';
  
    %  multiply Green function with linear shape function
    G1 = tensor( G1, [ 1, 2, 3 ] ) * tensor( f2, [ 2, 3, 4 ] ); 
    G1 = double( sum( G1 * tensor( w2, [ 2, 3 ] ), 3 ), [ 1, 2, 4 ] );
    %  accumulate Green function
    [ nu1, nu2 ] = ndgrid( 1 : n, reshape( vertcat( pt2( i2 ).tau.nu ), [], 1 ) );
    G = G + accumarray( { nu1( : ), nu2( : ) }, G1( : ), size( G ) );
  
    if p.Results.waitbar,  multiWaitbar( 'galerkinstat.eig', i2 / numel( pt2 ) );  end 
  end
  %  close waitbar
  if p.Results.waitbar,  multiWaitbar( 'galerkinstat.eig', 'Close' );  end
  
end


function [ G, F ] = fun( pts1, pt2, n, varargin )
  %  FUN - Compute submatrices.
  
  %  set up parser
  p = inputParser;
  p.KeepUnmatched = true;
  addOptional( p, 'nev', 20 );
  addParameter( p, 'relcutoff', 2 );
  %  parse input
  parse( p, varargin{ : } ); 
  
  %  positions
  [ pos2, w2 ] = eval( pt2 );
  %  dummy indices for internal tensor class
  [ i1, q1, i2, q2, a1, k ] = deal( 1, 2, 3, 4, 5, 6 );  
  
  %  allocate auxiliary matrices
  [ G, F ] = deal( zeros( [ n, size( w2 ) ] ) );
  
  %  loop over quadrature points of second boundary
  for pt1 = pts1
  
    %  positions, integration weights, and linear shape functions
    [ pos1, w1, f1 ] = eval( pt1 );
    %  convert to tensor
    f1 = tensor( f1, [ i1, q1, a1 ]  ) * tensor( w1, [ i1, q1 ] );
     
    %  distance
    d = pdist2( reshape( pos1, [], 3 ), reshape( pos2, [], 3 ) );
    d = tensor( reshape( d, [ size( w1 ), size( w2 ) ] ), [ i1, q1, i2, q2 ] );    
    %  normal vector and difference vector
    nvec = tensor( vertcat( pt1.tau.nvec ), [ i1, k ] );
    u = tensor( pos1, [ i1, q1, k ] ) - tensor( pos2, [ i2, q2, k ] ); 
   
    %  Green function and normal derivative
    G1 = sum( f1 ./ d, q1 );
    F1 = - sum( dot( nvec, u, k ) * f1 ./ d .^ 3, q1 );
    %  convert to numeric
    G1 = double( G1 / ( 4 * pi ), [ i1, a1, i2, q2 ] );
    F1 = double( F1 / ( 4 * pi ), [ i1, a1, i2, q2 ] );
    
    %  select boundary elements for refined integration
    [ ind1, ind2 ] = find( bdist2( pt1.tau, pt2.tau ) <= p.Results.relcutoff );
    
    if ~isempty( ind1 )    
      %  boundary element integration using analytic integration
      %  see Hänninen et al., PIERS 63, 243 (2006).
      switch pt1.npoly
        case 3
          pot3 = potbase3( pt1.tau );
          %  integration over boundary elements
          [ G2, F2 ] = stat2( pot3, pos2( ind2, :, : ), ind1 );
      end    
      
      for it = 1 : numel( ind1 )
        G1( ind1( it ), :, ind2( it ), : ) = G2( it, :, : ) / ( 4 * pi );
        F1( ind1( it ), :, ind2( it ), : ) = F2( it, :, : ) / ( 4 * pi );
      end
    end
  
    %  reshape Green function and normal derivative
    G1 = reshape( G1, [], size( w2, 1 ), size( w2, 2 ) );
    F1 = reshape( F1, [], size( w2, 1 ), size( w2, 2 ) );
    %  global degrees of freedom
    nu = vertcat( pt1.tau.nu );
    for it = 1 : numel( nu )
      G( nu( it ), :, : ) = G( nu( it ), :, : ) + G1( it, :, : );
      F( nu( it ), :, : ) = F( nu( it ), :, : ) + F1( it, :, : );
    end

  end
end
