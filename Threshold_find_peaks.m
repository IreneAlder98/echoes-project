function [pks,locs,threshold,time,exponentialMA] = Threshold_find_peaks(exponentialMA,heartRate,fs)
n_normal=1.9;
n_high=1.3;
if heartRate < 80
  n = n_normal;
else 
    n = n_high;
end

threshold=n*mean(exponentialMA,"all");
l=length(exponentialMA);

%% find peaks
[pks,locs] = findpeaks(exponentialMA, fs,'MinPeakHeight',threshold,'MinPeakDistance',0.15);
% new time values
time = (1:length(exponentialMA))./fs;
% normalising the hilbert data
exponentialMA= exponentialMA./max(exponentialMA);
