%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%  AAE 25100 Fall 2015
%  Programmer(s) and Purdue Email Address(es):
%  1. Stephen Shearrow, sshearro@purdue.edu
%
%  Assignment #: HW 9
%
%  Academic Integrity Statement:
%
%       I/We have not used source code obtained from
%       any other unauthorized source, either modified
%       or unmodified.  Neither have I/we provided access
%       to my/our code to another. The project I/we am/are 
%       submitting is my/our own original work.
%  
%
%  Inputs: list each input argument variable name and 
%          comment with units (as appropriate):
%  1. m_pay - payload mass [kg]
%  2. delV1 - delta V that the first stage needs to achieve [m/s]
%  3. delV2 - delta V that the second stage needs to achieve [m/s]
%  4. ISP1 - Specific impulse that the first stage rocket engine gives [sec]
%  5. ISP2 - Specific impulse that the second stage rocket engine gives [sec]
%  6. Fin1 - Finert for first stage
%  7. Fin2 - Finert for second stage
%   
%  Outputs: list each output argument variable name and 
%           comment with units (as appropriate):
%  1. m0 - Initial mass of two stage rocket
%  
%  Script Description: This script calculates the initial mass of a two
%  stage rocket
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
clear all

%---Inputs---
g0 = 9.81; %Acceleration of gravity [m/s^2]
m_pay = 16000; 
ISP1 = 311;
ISP2 = 451;
Fin1 = 0.091; %0.08;
Fin2 = 0.097; %0.13;  %(Mtot - Mpay - Mprop)/Mtot
delVtot = 9634; % Total delta V required [m/s]
x = linspace(0.1,0.6,1000);

%---Calculations---
delV1 = delVtot .* x;
delV2 = delVtot - delV1;

m0_2 = (m_pay.*(exp(delV2./(g0.*ISP2))).*(1-Fin2))./(1-Fin2.*exp(delV2./(g0.*ISP2)));
m0 = (m0_2.*(exp(delV1./(g0.*ISP1))).*(1-Fin1))./(1-Fin1.*exp(delV1./(g0.*ISP1)));

[m0_min, ind] = min(m0)
delV1_optPercent = x(ind)*100;
delV1_opt = delV1(ind)

%---Outputs---
plot(x,m0)
str = sprintf('Ratio of Delta V1 vs Initial Mass of Rocket\nOptimal Delta V1 Percentage: %3.1f %%',delV1_optPercent);
title(str)
xlabel('Ratio of Delta V1 to Total Delta V')
ylabel('Initial Mass of Rocket [kg]')
