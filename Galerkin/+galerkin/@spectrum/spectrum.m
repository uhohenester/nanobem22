classdef spectrum
  %  Detector for spectrum of electromagnetic far-fields.
  
  properties
    pinfty  %  discretized unit sphere at infinty
    imat    %  index for embedding medium
    pt      %  propagation directions for far-field evaluation 
  end
  
  properties (Hidden)
    w       %  integration weights
  end
  
  methods 
    function obj = spectrum( varargin )
      %  Initialize far-field detector.
      %
      %  Usage :
      %    obj = galerkin.spectrum( mat, pinfty, imat )
      %  Input
      %    mat      :  material properties
      %    pinfty   :  discretized unit sphere
      %    imat     :  index for background material
      obj = init( obj, varargin{ : } );
    end
  end

end 
