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
inclination = acosd(sind(B).*cosd(Lat));
for q = 1:length(iEff)
    for j = 1:length(B)
        
        [SRSmProp, SRSmInert] = SRSf(abs(iEff(q)-inclination(j)));
        SRSmTot(j,q) = (SRSmProp+SRSmInert+SRSmPay);
        [inc, delV1_optPercent(j,q), m_inert_0(j,q), m_prop_0(j,q), m_inert_2(j,q), m_prop_2(j,q) ] = Rocketf(B(j), SRSmTot(j,q));
        SRScost(j,q) = CostCalc(SRSmInert, SRSmProp);
        launchCost(j,q) = CostCalc(m_inert_0(j,q)+m_inert_2(j,q), m_prop_0(j,q)+m_prop_2(j,q));
        if SRScost(j,q) > 3E7 || launchCost(j,q) > 3E7
            SRScost(j,q) = NaN;
            launchCost(j,q) = NaN;
        end
        totalCost(j,q) = SRScost(j,q) + launchCost(j,q);
    end
end

[idealCost idealInd] = min(transpose(totalCost));
idealAzimuth = B(idealInd); 
%idealInclination = 



figure;

%surf(iEff, B, totalCost)
%zlim([0 4E7]);

subplot(2,2,1)
plot(B, inclination)
title('Resultant Inclination Based on Azimuth');
subplot(2,2,2)
plot(B, totalCost)
title('Total Cost on Azimuth')
subplot(2,2,3)
plot(B, launchCost, B, SRScost,B,totalCost)
ylim([0 8E7])
legend('Launch', 'SRS')
title('Cost of Launch and SRS')
subplot(2,2,4)
plot(B, delV1_optPercent)
title('Stage Split')
%subplot(2,2,2)
figure;
surfc(B, iEff, totalCost);%, 'FaceAlpha', 1, 'LineStyle', :)
ylabel('Inclination of Satellite');
xlabel('Launch Azimuth')
zlabel('Total Cost')
figure;
contour(B, iEff, totalCost,20)
hold on
plot(idealAzimuth, iEff)
ylabel('Inclination of Satellite');
xlabel('Launch Azimuth')
zlabel('Total Cost')
hold off
figure;
mesh(B, iEff, totalCost)
ylabel('Inclination of Satellite');
xlabel('Launch Azimuth')
zlabel('Total Cost')
