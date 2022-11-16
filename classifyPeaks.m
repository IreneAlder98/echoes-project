function [boundary_index,locs_new,spaces_between_new,locs_index] = classifyPeaks(locs,SYS,SYS_min,SYS_max,DIA,DIA_min,DIA_max)

ind_S1 = zeros(round(length(locs)),1);
ind_S2 = zeros(round(length(locs)),1);
locs_new = locs(locs~=0);
locs_index = zeros(round(length(locs_new)),1);
prev_peak = [0];
% % Calculate new space_between matrix after remove the incorrect peaks
for c = 1:length(locs_new)-1
    space_b_n(c,1) = locs_new(c+1,1) - locs_new(c,1);
    spaces_between_new(c,1) = 1000*space_b_n(c,1);
end
missingPeakIntv_idx = find(spaces_between_new >DIA_max);
if ~isempty(missingPeakIntv_idx)
    for i=1:length(missingPeakIntv_idx)-1
        missingPeakIntv(i,:) = [locs_new(missingPeakIntv_idx(i)),locs_new(missingPeakIntv_idx(i)+1)];
    end

end
c =1;
for c =1:size(spaces_between_new,1)-1
    if spaces_between_new (c,1) < spaces_between_new (c+1,1) 
        %&& SYS*0.5 < spaces_between_new (c,1) && spaces_between_new (c,1)<SYS_max
        if prev_peak(end) == false
            ind_S1(c,1) = c; ind_S1(c,2) = 1; prev_peak(end+1) = 1;
        if prev_peak(end) == true
            ind_S2(c+1,1) = c+1; ind_S2(c+1,2) = 2;prev_peak(end+1) = false;
        end
        end 
    end
end
for k =1: length(locs_new)
    if ind_S1(k,1)~=0
    locs_index(k,1) = ind_S1(k,2);
    else 
        if ind_S2(k,1)~=0
        locs_index(k,1) = ind_S2(k,2);
    end
    end
end
locs_index =  horzcat(locs_new,locs_index);
%% Checking any peaks except first and last peaks that havn't been classified
for k =length(spaces_between_new):-1:1
    if locs_index(k,2) == 0 && spaces_between_new (k,1)>DIA_max
        if locs_index(k+1,2) == 1
        locs_index(k,2) = 1;
        else
            locs_index(k,2) =2;
        end
    end
end
for k = 2:length(spaces_between_new)-2
    if spaces_between_new (k,1) > SYS_max && spaces_between_new (k+1,1)>SYS_max
        locs_index(k-1,2) = 1;
        locs_index(k,2) =1;
        locs_index(k+1,2) =2;
    end
end
%% Check if the first peak has been classified
if locs_index(1,2) == 0 && DIA*0.5 < spaces_between_new(1,1)&& spaces_between_new(1,1)<DIA_max

locs_index(1,2) = 2;
end
%% Classify the last two peaks
if locs_index(end-1,2)~=0
if spaces_between_new(end,1)>DIA*0.5 &&spaces_between_new(end,1)<DIA_max
    if  locs_index(end-1,2) == 2
        locs_index(end,2) = 1;
    end
end
end
if locs_index(end-1,2)==0
    if spaces_between_new(end,1)>0.5*SYS &&spaces_between_new(end,1)<SYS_max
        locs_index(end-1,2) =1;
        locs_index(end,2) =2;
    end
else 
    if spaces_between_new(end,1)>DIA_max
       if locs_index(end-1,2) ==2
        locs_index(end,2) =2;
       else 
           locs_index(end,2) =1;
       end
    end
end
boundary_index = locs_index(:,2);  