function [SD_ratio] = SD_ratio_calculation(S1_boundary_end_new,S2_boundary_end_new,S1_boundary_begin_new,S2_boundary_begin_new,exponentialMA,fs)
A = [length(S1_boundary_end_new),length(S2_boundary_begin_new)];
M = min(A);
for k =1:M
    sys_duration(k,1) = abs(fs.*( S2_boundary_begin_new(k,1) - S1_boundary_end_new(k,1)));
    dia_duration(k,1) = abs(fs.*( S2_boundary_end_new(k,1) - S1_boundary_begin_new(k,1)));
end
re_location = [];
% calculate simple index
S1_begin = floor(fs.*S1_boundary_begin_new);
S1_end = floor(fs.*S1_boundary_end_new);
S2_begin = floor(fs.* S2_boundary_begin_new);
S2_end = floor(fs.*S2_boundary_end_new);

%% calculate the amplitude of all the SYS
if length (S2_begin) >= length(S1_end)
    N = length(S1_end);
else
if length(S2_begin) < length(S1_end)
    N = length(S2_begin);
end
end
for k = 1:N -1
if S2_begin(k)>S1_end(k)
      amp_SYS(k) = mean(exponentialMA((S1_end(k)):(S2_begin(k)),:));
else 
    if S2_begin(k)<S1_end(k)
        amp_SYS(k) = mean(exponentialMA((S1_end(k)):(S2_begin(k+1)),:));
    end
end
end
    
for k = 1:N -1
   if S2_end(k) < S1_begin(k)
    amp_DIA(k) = mean(exponentialMA((S2_end(k)):(S1_begin(k)),:));
   else
       if S2_end(k)>S1_begin(k)
           amp_DIA(k) = mean(exponentialMA((S2_end(k)):(S1_begin(k+1)),:));
       else
       end
   end
end
amp_SYS = amp_SYS(amp_SYS~=0);
amp_DIA = amp_DIA(amp_DIA~=0);
    for n = 1:min(length(amp_DIA),length(amp_SYS))
      ratio (n) = amp_SYS(n)./amp_DIA(n);
    end
    SD_ratio = mean(ratio);