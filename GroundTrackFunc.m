function [ longLand, latLand ] = GroundTrackFunc( iDeg, orbitalAlt  )
%GroundTrackFunc Summary of this function goes here
%   Detailed explanation goes here
re = 6378;  %[km] radius of Earth
u = 3.986E5;  %km^3/s^2

iRad = iDeg*2*pi/360;
orbitalRadius = orbitalAlt + re;



end

