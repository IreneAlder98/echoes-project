function [heartRate,period_index] = heartRate_detection(exponentialMA,fs)
% Find the autocorrelation
y= exponentialMA - mean(exponentialMA);
[c] = xcorr(y, 'coeff');
singnal_autocorrelation = c(length(exponentialMA)+1:end);

min_index = 0.5*fs;
max_index = 2*fs;

[~, index] = max(singnal_autocorrelation(min_index:max_index));
true_index = index+min_index-1;
heartRate = 60/(true_index/fs);
period_index = true_index/fs*1000;