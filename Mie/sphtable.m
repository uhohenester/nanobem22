function  [ ltab, mtab ] = sphtable( lmax, key )
%  SPHTABLE - Table of spherical harmonic degrees and orders.
%
%  Usage :
%    [ ltab, mtab ] = sphtable( lmax, key )
%  Input :
%    lmax       :  maximum of spherical harmonic degrees
%    key        :  keep only  mtab = [ - 1, 0, 1 ]  if set to 'z' 
%  Output
%    ltab       :  table of spherical harmonic degrees
%    mtab       :  table of spherical harmonic orders

if ~exist( 'key', 'var' ),  key = '';  end
%  table of spherical degrees and orders
[ ltab, mtab ] = deal( [] );
%  loop over spherical degrees
for l = 1 : lmax
  switch key
    case 'z'
      m = reshape( - 1 : 1, [], 1 );
    otherwise
      m = reshape( - l : l, [], 1 );
  end
  ltab = [ ltab; l * ones( size( m ) ) ];
  mtab = [ mtab; m ];
end
