clc;
clear all;
close all;
%%%%Parameters Setting%%%%%
d0=1;%1 meter
d=1;%meter
LightSpeedC=3e8;
WCDMACellular=2100*1000000;%hz
% LTECellular=2000*1000000;%hz
Freq=WCDMACellular
TXAntennaGain=1; %db
RXAntennaGain=1; %db
PTx=1e-03; % i.e. .001 watt assumptation
PathLossExponent=2; %Line Of sight
PTxdBm=10*log10(PTx*1000);
e=input ('Enter type of Environment (1 - Free Space, 2 - Urban area cellular radio, 3 - Shadowed urban cellular radio, 4 - In building line-of-sight, 5 - Obstructed in factories, 6 - Obstructed in building)--:');
% u=input ('Enter type of city (1 - urban , 2 - suburban, 3-rural)--:');
ht=input('Enter height of transmitting antenna(30 to 200m)--:');
hr=input('Enter height of receiving antenna(1 to 10m)--:');
d=input('Enter Distance in meter from 100 to 200--:');
display('The Received Power for your given data is Pr0 in dB is');
if e==1
PathLossExponent=2;
elseif e==2
PathLossExponent=3.1;
elseif e==3
PathLossExponent=4;
elseif e==4
PathLossExponent=1.7;
elseif e==5
PathLossExponent=2.5;
else
PathLossExponent=5;
end
Wavelength=LightSpeedC/Freq;
Pr0=PTxdBm + TXAntennaGain + RXAntennaGain- (10*PathLossExponent*log10(4*pi/Wavelength))
display(Pr0);
figure
d=1;
% plot for entire range of frequencies
display('The plot for entire range of Distance from 100 to 2000 is shown in the plot');
h = waitbar(0,'plotting the Received Power for the entire range of Distance please wait......');
% log normal Shadowing Radio Propagation model:
% Pr0 = friss(d0)
% Pr(db) = Pr0(db) - 10*PathLossExponent*log(d/d0) + n
% where n is a Gaussian random variable with zero mean and a variance in db
% Pt * Gt * Gr * (Wavelength^PathLossExponent) d0^PathLossExponent (n/10)
% Pr = ---------------------------------------------*-----------------------*10
% 4 *pi * d0^PathLossExponent d^PathLossExponent
% get power loss by adding a log-normal random variable (shadowing)
% the power loss is relative to that at reference distance d0
% reset rand does influcence random
rstate = randn('state');
randn('state', d);
%GaussRandom=normrnd(0,6)%mean+randn*sigma; %Help on randn
GaussRandom= (randn*0.1+0);
%disp(GaussRandom);
for d=100:2:2000
Pr1=Pr0-(10*2* log10(d/d0))+GaussRandom;
randn('state', rstate);
subplot(1,1,1);
plot(d,Pr1,'g','DisplayName','Free Space ');hold on;
Pr2=Pr0-(10*3.1* log10(d/d0))+GaussRandom;
plot(d,Pr2,'k','DisplayName','Urban area ');
Pr3=Pr0-(10*4* log10(d/d0))+GaussRandom;
plot(d,Pr3,'r','DisplayName','Shadowed urban ');
Pr4=Pr0-(10*1.7* log10(d/d0))+GaussRandom;
plot(d,Pr4,'b','DisplayName','In building LOS ');
Pr5=Pr0-(10*2.5* log10(d/d0))+GaussRandom;
plot(d,Pr5,'c','DisplayName','In factory ');
title('The plot for entire range of Distance from 100 meters to 2000 meters');
legend('show','Location','southwest')
xlabel('Distance (in meters)');ylabel('Received Power (in dB)');
waitbar(d / 2000)
end
close(h);