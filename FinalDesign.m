%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       AAE 251 Final Design                              %
%                                                                         %
%                             Group 6                                     %
%                                                                         %
% Inputs:                                                                 %
%  1.  m_pay - payload mass [kg]                                          %
%  2.  delV1 - delta V that the first stage needs to achieve [m/s]        %
%  3.  delV2 - delta V that the second stage needs to achieve [m/s]       %
%  4.  delV3 - delta V that the capture stage must achieve [m/s]          %
%  5.  delV4 - delta V of deorbit [m/s]                                   %
%  6.  ISP1 - Specific impulse that first stage rocket engine gives [s]   %
%  7.  ISP2 - Specific impulse that second stage rocket engine gives [s]  %
%  8.  ISP3 - Specific impulse that the capture stage engine give [s]     %
%  9.  Fin1 - Finert for first stage                                      %
%  10. Fin2 - Finert for second stage                                     %
%  11. Fin3 - Finert for capture stage                                    %
%                                                                         %
%  Outputs:                                                               %
%  1. m0 - Initial mass of two stage rocket                               %
%                                                                         % 
%  Script Description: This script is to optimize launch profile          %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc

clear all

%--Constants---
Lat = 28.4556;  %[degrees] N launch latitude 
SRSmPay = 500;  %[kg] SRS payload: capture arm
B = linspace(35,120,1000);
iEff = linspace(0,90,1000);
for q = 1:length(iEff)
    for j = 1:length(B)
        inclination(q,j) = acosd(sind(B(j))*cosd(Lat));
        [SRSmProp, SRSmInert] = SRSf(abs(iEff(q)-inclination(q,j)));
        SRSmTot = (SRSmProp+SRSmInert+SRSmPay);
        [launchCost(q,j), inc, delV1_optPercent] = Rocketf(B(j), SRSmTot);
        SRScost(q,j) = CostCalc(SRSmInert, SRSmProp);
        totalCost(q,j) = SRScost(q,j) + launchCost(q,j);
    end
    fprintf('%.f\n', q)
end
figure;
%subplot(2,2,1)
surf(iEff, B, totalCost)
zlim([0 4E7]);
%subplot(2,2,2)
%contour

