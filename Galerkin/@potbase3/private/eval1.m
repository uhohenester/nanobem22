function [ I1, I2 ] = eval1( obj, pos, varargin )
%  EVAL1 - Line and surface integrals PIERS 63, 243 (2006).
%
%  Product output for OBJ.TAU and POS.  
%
%  Usage for obj = potbase3 :
%    [ I1, I2 ] = eval1( obj, pos, ind )
%  Input
%    pos    :  positions
%    ind    :  index to selected boundary elements (optional)
%  Output
%    I1     :  line integrals Eq. (40), (58)
%    I2     :  surface integrals Eq. (47), (63)

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'ind', 1 : numel( obj.tau ) );
%  parse input
parse( p, varargin{ : } );

%  orders for singularity extraction
qtab = - 1 + ( 0 : obj.order - 1 ) * 2;
%  allocate output
[ I1, I2 ] = deal( cell( size( qtab ) ) );

%%  line integrals
%  allocate output
[ I1{ : } ] = deal( zeros( size( pos, 1 ), numel( p.Results.ind ), 3 ) );
%  loop over triangle edges
for a = 1 : 3
  %  edge points 
  p1 = reshape( obj.verts( p.Results.ind, mod( a - 1, 3 ) + 1, : ), [], 3 );
  p2 = reshape( obj.verts( p.Results.ind, mod( a,     3 ) + 1, : ), [], 3 );
  %  edge vector
  svec = p2 - p1;
  svec = bsxfun( @rdivide, svec, sqrt( dot( svec, svec, 2 ) ) );
  
  %  Eq. (36)
  s1 = bsxfun( @plus, - pos * transpose( svec ), dot( svec, p1, 2 )' );
  s2 = bsxfun( @plus, - pos * transpose( svec ), dot( svec, p2, 2 )' );
  %  transverse distance r0, norm of cross( svec, pos - p1 )
  r0 = sqrt(  ...
    bsxfun( @plus, dot( pos, pos, 2 ), dot( p1, p1, 2 )' ) - 2 * pos * p1' -  ...
    bsxfun( @minus, pos * svec', dot( svec, p1, 2 )' ) .^ 2 );
  %  constants Eqs. (38), (39)
  r1 = sqrt( s1 .^ 2 + r0 .^ 2 );
  r2 = sqrt( s2 .^ 2 + r0 .^ 2 );
  
  %  integral, Eq. (40)
  I1{ 1 }( :, :, a ) = log( ( r2 + s2 ) ./ ( r1 + s1 ) );
                    
  for i = 2 : numel( qtab )
    q = qtab( i );
    %  recursion formula Eq. (58)
    I1{ i }( :, :, a ) =  ...
      ( q * r0 .^ 2 .* I1{ i - 1 }( :, :, a ) + s2 .* r2 .^ q - s1 .* r1 .^ q ) / ( q + 1 );
  end
end

%%  surface integrals
%  triangle corners
p1 = reshape( obj.verts( p.Results.ind, 1, : ), [], 3 );
p2 = reshape( obj.verts( p.Results.ind, 2, : ), [], 3 );
p3 = reshape( obj.verts( p.Results.ind, 3, : ), [], 3 );
%  normal vector 
nvec = obj.nvec( p.Results.ind, : );

%  inner product of normal vector and difference vector
h = bsxfun( @minus, pos * transpose( nvec ), dot( nvec, p1, 2 )' );
%  norm of vectors, Eq. (51)
rr = dot( pos, pos, 2 );
n1 = sqrt( bsxfun( @plus, rr, dot( p1, p1, 2 )' ) - 2 * pos * p1' );
n2 = sqrt( bsxfun( @plus, rr, dot( p2, p2, 2 )' ) - 2 * pos * p2' );
n3 = sqrt( bsxfun( @plus, rr, dot( p3, p3, 2 )' ) - 2 * pos * p3' );
%  dot( pos - p1, pos - p2 )
x12 = bsxfun( @plus, rr, dot( p1, p2, 2 )' ) - pos * ( p1 + p2 )';
x13 = bsxfun( @plus, rr, dot( p1, p3, 2 )' ) - pos * ( p1 + p3 )';
x23 = bsxfun( @plus, rr, dot( p2, p3, 2 )' ) - pos * ( p2 + p3 )';
%  inner product, Eq. (50)
x = 1 + x12 ./ ( n1 .* n2 ) + x13 ./ ( n1 .* n3 ) + x23 ./ ( n2 .* n3 );

%  triple product, Eq. (50)
vol = dot( p1, cross( p2, p3, 2 ), 2 );
b = cross( p2 - p1, p3 - p1, 2 );
y = bsxfun( @minus, pos * b', vol' ) ./ ( n1 .* n2 .* n3 );

%  surface integral, Eq. (47)
I2{ 1 } = - 2 * atan2( y, x ) ./ h; 
I2{ 1 }( abs( h ) < 1e-10 ) = 0;

%  outer edge normal
m1 = reshape( obj.mvec( p.Results.ind, 1, : ), [], 3 );
m2 = reshape( obj.mvec( p.Results.ind, 2, : ), [], 3 );
m3 = reshape( obj.mvec( p.Results.ind, 3, : ), [], 3 );
%  inner product with difference vector
t = cat( 3, bsxfun( @minus, pos * m1', dot( p1, m1, 2 )' ),  ...
            bsxfun( @minus, pos * m2', dot( p2, m2, 2 )' ),  ...
            bsxfun( @minus, pos * m3', dot( p3, m3, 2 )' ) ); 

for i = 2 : numel( qtab )
  q = qtab( i - 1 );
  %  recursion formula Eq. (63)
  I2{ i } =  ...
    ( q * h .^ 2 .* I2{ i - 1 } - sum( t .* I1{ i - 1 }, 3 ) ) / ( q + 2 );
end

%  avoid difficulties with h=0
for it = 1 : numel( I1 )
  I1{ it }( isnan( I1{ it } ) | isinf( I1{ it } ) ) = 0;
  I2{ it }( isnan( I2{ it } ) | isinf( I2{ it } ) ) = 0;
end
