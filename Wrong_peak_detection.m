function [locs] = Wrong_peak_detection (heartRate,locs,spaces_between,SYS_min,SYS_max,DIA_min,DIA_max)
%% Simple Heart Sound Classification for Increased heartRate >80 bps
std_PTI = std(spaces_between);
mean_PTI = mean(spaces_between);
for i = 2: length(spaces_between)-1
    if spaces_between(i,1)< mean_PTI - std_PTI
        if spaces_between(i-1,1)<spaces_between(i+1,1)
            locs(i,1) = 0;
        else 
            if spaces_between(i-1,1) > spaces_between(i+1,1)
                locs(i+1,1) = 0;
            end
        end
    end
end


if heartRate > 80
     for c = 2:length(locs)
         if c>2 && c<= length(locs)-3 && SYS_min < spaces_between(c-1,1) && spaces_between(c-1,1) < SYS_max && spaces_between(c,1)<DIA_min && SYS_min < spaces_between(c+2,1) && spaces_between(c+2,1)<SYS_max
              locs(c+1,1) = 0;
         end
     end
end
    
%% Remove the wrong peaks
if heartRate <80
if SYS_min<spaces_between(1,1) && spaces_between(1,1)<SYS_max && spaces_between(2,1)>spaces_between(1,1)
        k =2;
    else k = 3;
end
 for c = k:length(spaces_between)

         if c<= length(spaces_between)-2 && spaces_between(c+2,1)>SYS_max && SYS_min < spaces_between(c-1,1) && spaces_between(c-1,1) < SYS_max && spaces_between(c,1)<DIA_min && SYS_min < spaces_between(c+2,1) && spaces_between(c+2,1)<SYS_max
              locs(c+1,1) = 0;
         else

             if c > 2 && c<=length(spaces_between)-1 && DIA_min < spaces_between(c-2,1) && spaces_between(c-2,1) < DIA_max && SYS_min < spaces_between(c-1,1) && spaces_between(c-1,1) < SYS_max && spaces_between(c,1)< DIA_min
                 locs(c+1,1) = 0;

%            else

%                  if le(c,length(spaces_between)-2) && SYS_min < spaces_between(c-1,1) && spaces_between(c-1,1) < SYS_max && DIA_min < spaces_between (c,1) && spaces_between (c,1) < DIA_max && SYS_min < spaces_between (c+2,1) && spaces_between(c+2,1) <SYS_max
%                      locs(c+1,1) = 0;
%          
%                else
%                      if le(c,length(spaces_between)-3) && spaces_between(c+2,1)>SYS_max && SYS_min < spaces_between(c-1,1) && spaces_between(c-1,1)<SYS_max && DIA_min < spaces_between(c,1) && spaces_between(c,1) < DIA_max && SYS_min < spaces_between(c+3,1) && spaces_between(c+3,1) < SYS_max
%                          locs(c+1,1) = 4;

                     end
                 end
             end
         end
end

% Condition 3 and Condition 4 need optimise.






