function [h,t,H,f]=i_f_response(b,a,fs,N);
% Calculate the impulse and frequency response of the filter specified by b and a.
% fs .. sampling rate, 
% N ..  length of the impulse response 
% h .. the impulse response
% t .. time-base for h
% H .. complex frequency response
% f .. frequency scale for H

impulse=[1,zeros(1,N-1)];

h=filter(b,a,impulse);
t=[0:N-1]/fs;
H=fft(h);
f=[0:N-1]*fs/N;
i=find(f>fs/2);
f(i)=f(i)-fs;
H=H(1:round(N/2)+1);
f=f(1:round(N/2)+1);



