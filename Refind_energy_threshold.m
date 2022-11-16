function [pks,locs] = Refind_energy_threshold(locs, period_index,threshold,filted_signal,fs,time)
%% check if the threshold is an suitable value
if length(locs) >2
for j = 1:length(locs) -2
    spaces_duration(j,1) = locs(j+2,1) - locs(j,1);
     spaces_duration(j,1) = 1000*spaces_duration(j,1);
end
end


mean_duration_index = mean(spaces_duration); %calculate the mean duration of every two peaks

     if mean_duration_index < period_index *0.95
         threshold_new = threshold + threshold*0.05;
     else 
         if mean_duration_index > period_index *1.05
             threshold_new = threshold - threshold*0.05;  
     else
         threshold_new = threshold;
     end
     end
% Refind the peak locations
 [pks,locs] = findpeaks(filted_signal, fs,'MinPeakHeight',threshold_new,'MinPeakDistance',0.2);
%plot hilbert peaks
  figure;
  plot(time,filted_signal,locs,pks,'or');
% % plot(time,exponentialMA);
%     xlabel('Time (s)');
%     ylabel('Amplitude');
%     title('Plot hilbert transform after smooth filter');


