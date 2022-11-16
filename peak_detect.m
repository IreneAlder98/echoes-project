function i=peak_detect(x);
% detect the location of peaks in the signal
N=length(x);
abs_dx=diff(x)>0; % determine if the gradient is positive
d_adx=diff(abs_dx); % determine if the gradient has changed, indicating a peak
i=find(d_adx<0); 
i=i+1; % shift by one, as differences are always calculated with respect to the following sample

