function data = eval2( obj, k1, varargin )
%  EVAL2 - Evaluate single and doble layer potential.
%
%  Usage for obj = galerkin.pot1.refine2 :
%    data = eval2( obj, k1 )
%    data = eval2( obj, k1, data )
%  Input
%    k1     :  wavenumber of light in medium
%    data   :  previously computed SL and DL terms
%  Output
%    data   :  single and double layer potential

if isempty( obj.rules2 )
  data = galerkin.pot1.layer.eval2( obj, k1, 1, varargin{ : } ); 
else
  data = galerkin.pot1.layer.eval2( obj, k1, 2, varargin{ : } );
end
