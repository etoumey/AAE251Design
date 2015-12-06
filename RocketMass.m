function [m0, Mprop_tot, Minert_tot] = RocketMass(m_pay,delV1,delV2,ISP1,ISP2,Fin1,Fin2)
%RocketMass Determines the initial mass of spacecraft given deltaV, azimuth
%   Detailed explanation goes here

g0 = 9.81;

%---Calculate---
m0_2 = (m_pay.*(exp(delV2./(g0.*ISP2))).*(1-Fin2))./(1-Fin2.*exp(delV2./(g0.*ISP2)));
m0 = (m0_2.*(exp(delV1./(g0.*ISP1))).*(1-Fin1))./(1-Fin1.*exp(delV1./(g0.*ISP1)));

m_prop2_0 = (m0_2.*(exp(delV1./(g0.*ISP1)) - 1).*(1-Fin1))./(1-Fin1.*exp(delV1./(g0.*ISP1))); %Stage 1
m_inert2_0 = (m0_2.*Fin1.*(exp(delV1./(g0.*ISP1))-1))./(1-Fin1.*exp(delV1./(g0.*ISP1))); %Stage 1

m_prop2_2 = (m_pay.*(exp(delV2./(g0.*ISP2)) - 1).*(1-Fin2))./(1-Fin2.*exp(delV2./(g0.*ISP2))); %Stage 2
m_inert2_2 = (m_pay.*Fin2.*(exp(delV2./(g0.*ISP2))-1))./(1-Fin2.*exp(delV2./(g0.*ISP2))); %Stage 2

Mprop_tot = m_prop2_2 + m_prop2_0;
Minert_tot = m_inert2_2 + m_inert2_0;

end

