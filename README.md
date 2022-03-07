# nanobem

nanobem is a Matlab toolbox for the solution of Maxwell's equations for metallic and dielectric nanoparticles using a Galerkin boundary element method (BEM) approach. Details of the computational approach are described in 

* Hohenester, Nano and Quantum Optics (Springer 2020)
* Hohenester, Reichelt, Unger, Nanophotonic resonance modes with the nanobem toolbox, to appear in CPC (2022)

When you publish results with the nanobem toolbox, please cite the forthcoming CPC paper.

## Author

Ulrich Hohenester, https://orcid.org/0000-0001-8929-2086 


## Usage and installation

To use the nanobem toolbox, you must add at the beginning of each Matlab 
session the main directory and all subdirectories to the Matlab path, 
e.g. by calling

    %  nanobemdir is the full directory name of the toolbox
    addpath(genpath(nanobemdir));

To set up the nanobem help pages, you must install them once.  To this end, you must change in Matlab to the main directory of the toolbox, and run the file 

    makehelp
  
A detailed help of the Toolbox and a number of demo files are then available in the Matlab help pages which can be found on the start page of the help browser under Supplemental Software.
