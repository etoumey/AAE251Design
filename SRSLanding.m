%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            AAE 251 Design Project               %
%                                                 % 
%    Team: 6                     Author: Eliot    %
%                                                 %
%                  SRS Orbit info                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%

mPay = 12000;  %kg of SRS
re = 6378;  %km radius of Earth
u = 3.986E5;  %km^3/s^2
Isp = 316;  %Isp of OMS system on Shuttle
ic = 30;  %inclination at checkout

%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%

ro = 200 + re;  %initial checkout orbit
vo = sqrt(u/ro);  %initial orbital velocity
raTrans = 1000 + re;
rpTrans = ro;

a = .5*(raTrans+rpTrans);

deltaV1 = sqrt(2*((u/ro)-(u/(2*a)))) - vo;

deltaV2 = sqrt(u/raTrans) - sqrt(2*((u/raTrans)-(u/(2*a))));









%%%%%%%%%%%%%%%%%%% Deorbit %%%%%%%%%%%%%%%%%%%%%%
ro = 1000+re;
ra = 1000+re;
rp = re;
vo = sqrt(u/ro);

a = .5*(ra+rp);

deltaV3 = abs(sqrt(2*((u/ro)-(u/(2*a)))) - vo);

deltaV = deltaV1 + deltaV2 + deltaV3;