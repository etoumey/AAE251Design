function [ cost ] = CostCalc( Minert_tot, Mprop_tot )
%CostCalc Calculates cost of rocket for given inert and propellant mass
%   Detailed explanation goes here
cost = Minert_tot.*1000 + Mprop_tot.*20;

end

