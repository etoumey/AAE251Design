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
close all
clear all

%--Constants---
Lat = 13.5761;  %[degrees] N launch latitude 
SRSmPay = 500;  %[kg] SRS payload: capture arm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       CHANGE LAST ARGUMENT OF LINSPACE TO ALTER RESOLUTION              %
B = linspace(90,270,100);                                               %
iEff = linspace(0,180,100);                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inclination = acosd(sind(B).*cosd(Lat));

for q = 1:length(iEff)
    q
    for j = 1:length(B)
        inclinationChange(j,q) = abs((iEff(q)-inclination(j)));
        [SRSmProp(j,q), SRSmInert] = SRSf(inclinationChange(j,q));
        SRSmTot(j,q) = (SRSmProp(j,q)+SRSmInert+SRSmPay);
        [m_inert_0(j,q), m_prop_0(j,q), m_inert_2(j,q), m_prop_2(j,q) ] = Rocketf(B(j), SRSmTot(j,q));
        launchmTot(j,q) = m_inert_0(j,q)+ m_prop_0(j,q)+ m_inert_2(j,q)+ m_prop_2(j,q);
        SRScost(j,q) = CostCalc(SRSmInert, SRSmProp(j,q));
        launchCost(j,q) = CostCalc((m_inert_0(j,q)+m_inert_2(j,q)), (m_prop_0(j,q)+m_prop_2(j,q)));
        if SRScost(j,q) > 3E7 || launchCost(j,q) > 3E7
            SRScost(j,q) = NaN;
            launchCost(j,q) = NaN;
        end
        totalCost(j,q) = SRScost(j,q) + launchCost(j,q);
    end
end

[idealCost, idealInd1] = min(transpose(totalCost));
idealAzimuth = B(idealInd1); 
for ii = 1:length(idealAzimuth)
    [idealSRSmProp(ii), idealSRSmInert(ii)] = SRSf(abs(acosd(sind(idealAzimuth(ii)).*cosd(Lat))-iEff(ii)));
end

[SRSmProp_final, idealInd2] = max(idealSRSmProp);
SRSmInert_final = idealSRSmInert(idealInd2);
SRSmTot_final = SRSmProp_final + SRSmInert_final + SRSmPay;
SRScost_final = CostCalc(SRSmInert_final, SRSmProp_final);

figure(1)
plot(iEff, idealAzimuth)
title('Ideal Azimuth for Inclination of Capture');
xlabel('Inclination of Capture')
ylabel('Launch Azimuth')

figure(2);
plot(iEff, idealCost)
title('Ideal Total Cost for Inclination of Capture')
xlabel('Inclination of Capture')
ylabel('Ideal Total Cost')

figure(3)
surfc(B, iEff, totalCost,  'LineStyle', 'none')
%hold on
%scatter3(idealAzimuth, iEff, idealCost,'r', 'Filled')
%title('Total Cost of Launch and Capture')
ylabel('Inclination of Satellite (deg)');
xlabel('Launch Azimuth (deg)')
zlabel('Total Cost (USD)')
figure(4)
contour(B, iEff, totalCost,24)
hold on
plot(idealAzimuth, iEff, 'r', 'LineWidth', 4)
legend('Total Cost of Launch and Capture', 'Lowest Cost Profile', 'Location', 'southoutside')
ylabel('Inclination of Satellite (deg)');
xlabel('Launch Azimuth (deg)')
%zlabel('Total Cost (USD)')
hold off
