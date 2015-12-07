function [ mProp, mInert ] = SRSf( inclinationChange )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%

mPay = 500;  %kg of SRS
re = 6378;  %km radius of Earth
u_earth = 3.986E5;  %km^3/s^2
ISP3 = 316;  %Isp of OMS system on Shuttle
mSat = 5715.26386;  %[kg] mass of sat
Fin3 = .1;

%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%

ro = 200 + re;  %initial checkout orbit
vo = sqrt(u_earth/ro);  %initial orbital velocity
raTrans = 1000 + re;
rpTrans = ro;

a = .5*(raTrans+rpTrans);

deltaV1 = sqrt(2*((u_earth/ro)-(u_earth/(2*a)))) - vo;
deltaV2 = sqrt(u_earth/raTrans) - sqrt(2*((u_earth/raTrans)-(u_earth/(2*a))));
deltaV3 = 2*(sqrt(2*((u_earth/raTrans)-(u_earth/(2*a)))))*sind(inclinationChange/2);

mProp = (mPay*exp((deltaV1+deltaV3)/(.0098*316))*(1-Fin3))/(1-(Fin3*exp((deltaV1+deltaV3)/(.0098*ISP3)))) + (((mPay+mSat)*exp(deltaV2/(.0098*ISP3))*(1-Fin3))/(1-(Fin3*exp(deltaV2/(.0098*ISP3)))));
mInert = (mPay*Fin3*exp((deltaV1+deltaV3)/(.0098*316)))/(1-(Fin3*exp((deltaV1+deltaV3)/(.0098*ISP3)))) + (((mPay+mSat)*Fin3*exp(deltaV2/(.0098*ISP3)))/(1-(Fin3*exp(deltaV2/(.0098*ISP3)))));

if mProp < 0 || mInert < 0
    mProp = NaN;
    mInert = NaN;
end

end

