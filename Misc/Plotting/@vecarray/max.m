function c = max( obj, opt )
%  MAX - Maximum of VECARRAY.
%
%  Usage for obj = vecarray :
%    c = max( obj, opt )
%  Input
%    opt    :  plot options
%  Output
%    c      :  maximum of vector array or [] for truecolor array

c = max( vecnorm2( subsref( obj, substruct( '()', { opt } ) ) ) );
