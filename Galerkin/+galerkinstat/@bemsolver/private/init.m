function obj = init( obj, tau, varargin )
%  INIT - Initialize quasistatic BEM solver.
%
%  Usage for obj = galerkinstat.bemsolver :
%    obj = init( obj, tau, PropertyPairs )
%  Input
%    tau        :  boundary elements
%  PropertyName      
%    nduffy     :  number of Legendre-Gauss points for Duffy integration
%    rules      :  default integration rules
%    rules1     :  integration rules for refinement
%    relcutoff  :  relative cutoff for refined integration
%    memax      :  restrict computation to MEMAX boundary elements
%    waitbar    :  show waitbar during initialization

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'engine', galerkinstat.pot1.engine( varargin{ : } ) );
%  parse input
parse( p, varargin{ : } );
      
%  save boundary elements
obj.tau = tau;
%  compute Green function and normal derivative
pot = set( p.Results.engine, tau, tau );
[ obj.G, obj.F ] = green( pot, varargin{ : } );
