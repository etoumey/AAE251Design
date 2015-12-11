function [delV1_optPercent, m_inert_0, m_prop_0, m_inert_2, m_prop_2 ] = Rocketf( azimuth, m_pay )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%




%--Constants---
u_earth = 3.986E14; %[m^3/s^2]
r_earth = 6378*1000; %[m]
w_e = 2*pi/(24*60*60); %[rad/s]
g0 = 9.81; % [m/s^2]
delV_grav = 1500;  % [m/s]
delV_drag = 150; % [m/s]
delV_steer = 200; % [m/s]
%f_inert = 26400/228400;
%Singe Stage
f_inert = 26400/228400;
ISP = 414; %[s]  + LOX
%Two Stage
ISP1 = 400; %[s] Kerosine + LOX
ISP2 = 451; %[s] H + LOX
Fin1 = 0.091; %0.08;
Fin2 = 0.097; %

%---Inputs---
%m_pay = 15000; % [kg] payload mass
alt = 200*1000; % [m] circular orbit altitude
latitude = 13.5761*(pi/180); %[rad] location of cape canaveral
azimuth = azimuth*(pi/180); %[rad] conversion
inc = acos(sin(azimuth)*cos(latitude));
%inc = 45 .*(pi/180); %[rad] desired inclination
%azimuth = asin(cos(inc)./cos(latitude)); %[rad] 

%---Calculations---
delv_initial = w_e .* r_earth .* cos(latitude) .* sin(azimuth); %free DeltaV from earths rotation
delv_ideal = sqrt(u_earth/(r_earth+alt)) - delv_initial; %Ideal DeltaV for orbit with free DeltaV from earth
delv_tot =  delv_ideal + delV_grav + delV_drag + delV_steer; % [m/s] Delta V required for circular flight at this altitude

%---Inert---
%m_inert = m_0 - m_prop - m_pay;
%f_inert = m_inert/(m_inert + m_0);

%--Propellant Mass and Initial Mass---
% m_prop = (m_pay.*(exp(delV_tot./(g0.*ISP)) - 1).*(1-f_inert))./(1-f_inert.*exp(delV_tot./(g0.*ISP)));
% m_inert = (m_pay.*f_inert.*(exp(delV_tot./(g0.*ISP))-1))./(1-f_inert.*exp(delV_tot./(g0.*ISP)));
% m_0 = (m_pay.*(exp(delV_tot./(g0.*ISP))).*(1-f_inert))./(1-f_inert.*exp(delV_tot./(g0.*ISP)));

%% ---Comparing 1 and 2 stage rocket with delV range---
%delv_tot = 5:0.01:10; % [km/s]
ratio = .42;
delV1 = delv_tot.*ratio;
delV2 = delv_tot - delV1;


%---Two Stage---
m0_2 = (m_pay.*(exp(delV2./(g0.*ISP2))).*(1-Fin2))./(1-Fin2.*exp(delV2./(g0.*ISP2)));
m0 = (m0_2.*(exp(delV1./(g0.*ISP1))).*(1-Fin1))./(1-Fin1.*exp(delV1./(g0.*ISP1)));

m_prop2_0 = (m0_2.*(exp(delV1./(g0.*ISP1)) - 1).*(1-Fin1))./(1-Fin1.*exp(delV1./(g0.*ISP1))); %Stage 1
m_inert2_0 = (m0_2.*Fin1.*(exp(delV1./(g0.*ISP1))-1))./(1-Fin1.*exp(delV1./(g0.*ISP1))); %Stage 1

m_prop2_2 = (m_pay.*(exp(delV2./(g0.*ISP2)) - 1).*(1-Fin2))./(1-Fin2.*exp(delV2./(g0.*ISP2))); %Stage 2
m_inert2_2 = (m_pay.*Fin2.*(exp(delV2./(g0.*ISP2))-1))./(1-Fin2.*exp(delV2./(g0.*ISP2))); %Stage 2

m2_prop_tot = m_prop2_2 + m_prop2_0;
m2_inert_tot = m_inert2_2 + m_inert2_0;

%---Optimize Delta V split---
[m0_min, ind] = min(m0);
delV1_optPercent = ratio(ind)*100;
delV1_opt = delV1(ind);
%---Cost---
m_inert_0 = m_inert2_0(ind);
m_prop_0 = 1.05*m_prop2_0(ind);
%Cost of 2 stage [kg]*[$/kg] = [$]
m_inert_2 = m_inert2_2(ind);
m_prop_2 = 1.05*m_prop2_2(ind); %Cost of 1 stage

if m_inert_0 < 0 || m_prop_0 < 0 || m_inert_2 < 0 || m_prop_2 < 0 || delV1_optPercent == 10
     m_inert_0 = NaN;
     m_prop_0 = NaN;
     m_inert_2 = NaN;
     m_prop_2 = NaN;
     inc = NaN;
     delV1_optPercent = NaN;
end




end

