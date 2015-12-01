clear
clc

B = 135;  %[degrees] N launch azimuth
Lat = 28.4556;  %[degrees] N launch latitude 
Long = 80.5278;  %[degrees] W launch longitude
LatRad = Lat*2*pi/360;
LongRad = Long*2*pi/360;
re = 6378;  %[km] radius of Earth
ra = 1000+re;  %[km] apoapsis radius
rp = 1000+re;  %[km] periapsis radius
u = 3.986E5;  %km^3/s^2



P = (2*pi*ra^(3/2))/sqrt(u);
P = P/60/60;
i = acosd(sind(B)*cosd(Lat));  %[degrees] inclination
iRad = (i/360)*2*pi;
phaseShift = asin(LatRad/iRad)-(P*LongRad);


figure;
imshow('map.png', 'XData', [0 2*pi], 'YData', [pi/2 -pi/2]);
impoint(gca, LongRad, LatRad);
set(gca,'Ydir','Normal');
hold on
for rotation = 1:10
    plot(linspace(0,2*pi,10000), (iRad*sin(linspace(0,2*pi,10000)*P+phaseShift)),'Color', rand(1,3), 'LineWidth', 2); 
    phaseShift = phaseShift + (P/(24));
    hold on
end

hold off
