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
%  Script Description: This script calculates the initial mass of a two   %
%  stage rocket                                                           %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clear all

%--Constants---
u_earth = 3.986E5; %[km^3/s^2]
r_earth = 6378; %[km]
g0 = .00981; % [km/s^2]
delV_grav = 1.500;  % [km/s]
delV_drag = .150; % [km/s]
delV_steer = .200; % [km/s]
%f_inert = 26400/228400;
%Singe Stage
f_inert = 26400/228400;
ISP = 414; %[s]  + LOX
%Two Stage
ISP1 = 311; %[s] Kerosine + LOX
ISP2 = 451; %[s] H + LOX
ISP3 = 316; %[s]
Fin1 = 0.091; %0.08;
Fin2 = 0.097; %0.13;
Fin3 = .1;  %Estimate
B = 60;  %[degrees] N launch azimuth
Lat = 28.4556;  %[degrees] N launch latitude 
Long = 80.5278;  %[degrees] W launch longitude
LatRad = Lat*2*pi/360;
LongRad = Long*2*pi/360;
SRSm_pay = 500; %[kg] payload SRS carries 
SRSm_sat = 5715.26386; %[kg] weight of captured satellite
launchInclination = acosd(sind(B)*cosd(Lat));
delta_i = 90-launchInclination; %[degrees] desired plane change

%--SRS Stage Calculations--
ro = 200+r_earth;
vo = sqrt(u_earth/ro);  %initial orbital velocity
raTrans = (1000) + r_earth;
rpTrans = ro;
a = .5*(raTrans+rpTrans);
SRSdeltaV1 = sqrt(2*((u_earth/ro)-(u_earth/(2*a)))) - vo;
SRSdeltaV2 = sqrt(u_earth/raTrans) - sqrt(2*((u_earth/raTrans)-(u_earth/(2*a))));
SRSdeltaV3 = 2*(sqrt(2*((u_earth/raTrans)-(u_earth/(2*a)))))*sind(delta_i/2);
SRSm_prop = (SRSm_pay*exp((SRSdeltaV1+SRSdeltaV3)/(.0098*316))*(1-Fin3))/(1-(Fin3*exp((SRSdeltaV1+SRSdeltaV3)/(.0098*ISP3)))) + (((SRSm_pay+SRSm_sat)*exp(SRSdeltaV2/(.0098*ISP3))*(1-Fin3))/(1-(Fin3*exp(SRSdeltaV2/(.0098*ISP3)))));
SRSm = (SRSm_prop+SRSm_pay)*(1+Fin3);

%--Launch Stage Split--
delV_earth = (r_earth*2*pi/(24*60*60))*cosd(LatRad); %WHAT ABOUT AZIMUTH
delv_tot = sqrt(u_earth/(r_earth+200))  + delV_grav + delV_drag + delV_steer - delV_earth; % [km/s] Delta V required for circular flight at this altitude
x = linspace(0.1,.6,1000);
delV1 = delv_tot .* x;
delV2 = delv_tot - delV1;

m0_2 = (SRSm.*(exp(delV2./(g0.*ISP2))).*(1-Fin2))./(1-Fin2.*exp(delV2./(g0.*ISP2)));
m0 = (m0_2.*(exp(delV1./(g0.*ISP1))).*(1-Fin1))./(1-Fin1.*exp(delV1./(g0.*ISP1)));

[m0_min, ind] = min(m0);
delV1_optPercent = x(ind)*100;
delV1_opt = delV1(ind);
plot(x,m0)
str = sprintf('Ratio of Delta V1 vs Initial Mass of Rocket\nOptimal Delta V1 Percentage: %3.1f %%',delV1_optPercent);
title(str);
xlabel('Ratio of Delta V1 to Total Delta V')
ylabel('Initial Mass of Rocket [kg]')

%---Single Stage---
m_prop2_0 = (m0_2(ind).*(exp(delV1(ind)./(g0.*ISP1)) - 1).*(1-Fin1))./(1-Fin1.*exp(delV1(ind)./(g0.*ISP1))); %Stage 1
m_inert2_0 = (m0_2(ind).*Fin1.*(exp(delV1(ind)./(g0.*ISP1))-1))./(1-Fin1.*exp(delV1(ind)./(g0.*ISP1))); %Stage 1

m_prop2_2 = (SRSm.*(exp(delV2(ind)./(g0.*ISP2)) - 1).*(1-Fin2))./(1-Fin2.*exp(delV2(ind)./(g0.*ISP2))); %Stage 2
m_inert2_2 = (SRSm.*Fin2.*(exp(delV2(ind)./(g0.*ISP2))-1))./(1-Fin2.*exp(delV2(ind)./(g0.*ISP2))); %Stage 2

m2_prop_tot = m_prop2_2 + m_prop2_0;
m2_inert_tot = m_inert2_2 + m_inert2_0;

%---Cost---
c_2 = m2_inert_tot.*1000 + m2_prop_tot.*30; %Cost of 2 stage [kg]*[$/kg] = [$]
%c_1 = m1_inert_tot.*1000 + m1_prop_tot.*30; %Cost of 1 stage


