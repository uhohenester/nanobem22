function is = connected( obj, tau )
%  CONNECTED - Determine whether points are connected to TAU.
%
%  Usage for obj = Point :
%    is = connected( obj, tau )
%  Input
%    tau  :  Points or boundary elements
%  Output
%    is   :  points connected ?

%  material indices of points
imat = vertcat( obj.imat );
%  material properties of TAU
switch class ( tau )
  case 'Point'
    is = bsxfun( @eq, imat, horzcat( tau.imat ) );
  otherwise
    inout = vertcat( tau.inout );
    is = bsxfun( @eq, imat, reshape( inout( :, 1 ), 1, [] ) ) |  ...
         bsxfun( @eq, imat, reshape( inout( :, 2 ), 1, [] ) );
end

