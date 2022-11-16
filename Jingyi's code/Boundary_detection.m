function [heart_sounds] = boundary_detection(exponentialMA,t,locs_new,boundary_index) 
%% Calculate the threshold to detect heat sound boundary
N = length(exponentialMA);
u = sum(exponentialMA)/N;
v = sum((exponentialMA - u).^2)/N;
Thre_boundary = (u+v);

for i = 1:N
     if exponentialMA(i)>Thre_boundary
         boundary_parameter(i) = t(i);
     end
end
%% select boundary time
 N = length(boundary_parameter);
for i = 1:N-1
    if boundary_parameter(i)==0 && boundary_parameter(i+1)>0
        boundary_begin(i) = boundary_parameter(i+1);
    else 
         if boundary_parameter(i)>0 && boundary_parameter(i+1)==0
             boundary_end(i) = boundary_parameter(i);
        end
   end
end
boundary_begin = boundary_begin(boundary_begin~=0);
boundary_end = boundary_end(boundary_end~=0);
boundary_begin = boundary_begin';
boundary_end = boundary_end';

%% check the correct boundary begin and end time    
N = max(length(boundary_begin),length(boundary_end));
L = length(locs_new);

for k = 1:L

   for i = 1: N-1
    if boundary_begin(i,1) < locs_new(k,1) && locs_new(k,1) <boundary_end(i,1)
        if boundary_index(k,1) == 1
       S1_boundary_end_new(i,1) = boundary_end(i,1);
       S1_boundary_begin_new(i,1) = boundary_begin(i,1);
       S1_boundary_begin_new(i,2) = k;
       S1_boundary_end_new(i,2) =k; 
        else
       if boundary_index(k,1) == 2
           S2_boundary_end_new(i,1) = boundary_end(i,1);
           S2_boundary_begin_new(i,1) = boundary_begin(i,1);
           S2_boundary_begin_new(i,2) = k;
           S2_boundary_end_new(i,2) =k; 
    end
   end
   end
   end
end

%% check the last peak location
 for p = 1: N -1
   if boundary_begin(p,1) < locs_new(end,1) && locs_new(end,1) <boundary_end(p,1)
       if  boundary_index(end,1) == 1
       S1_boundary_end_new(end+1,1) = boundary_end(p,1);
      S1_boundary_begin_new(end+1,1) = boundary_begin(p,1);
       S1_boundary_begin_new(end+1,2) = length(boundary_index);
       S1_boundary_end_new(end+1,2) = length(boundary_index); 
       else
           if boundary_index(end,1) == 2
      S2_boundary_end_new(end+1,1) = boundary_end(p,1);
      S2_boundary_begin_new(end+1,1) = boundary_begin(p,1);
       S2_boundary_begin_new(i,2) = length(boundary_index);
        S2_boundary_end_new(i,2) = length(boundary_index); 
   end
       end
   end
 end
%  %%
% index_begin = zeros(round(length(boundary_index)),1);
% index_end = zeros(round(length(boundary_index)),1);
% boundary_index_new= horzcat(index_begin,boundary_index,index_end);
% for k = 1: length(boundary_index_new)
%     if boundary_index_new(k,2) == 1
%        boundary_index_new(k,1) = S1_boundary_begin_new(k-1);
%        boundary_index_new(k,3) = S1_boundary_end_new(k-1);
%     else
%         if boundary_index_new(k,2) == 2
%             boundary_index_new(k,1) = S2_boundary_begin_new(k);
%              boundary_index_new(k,3) = S2_boundary_end_new(k);
%         end
%     end
% end
S1_boundary_begin_new(any(S1_boundary_begin_new,2)==0,:)=[];
S1_boundary_end_new(any(S1_boundary_end_new,2)==0,:)=[];
S2_boundary_begin_new(any(S2_boundary_begin_new,2)==0,:)=[];
S2_boundary_end_new(any(S2_boundary_end_new,2)==0,:)=[];
boundary_index = boundary_index(boundary_index~=0);
%% Relocation of all the boundary
All_begin =[S1_boundary_begin_new;S2_boundary_begin_new];
All_end = [S1_boundary_end_new;S2_boundary_end_new];
All_begin_new = sort(All_begin);
All_end_new = sort(All_end);
while length(All_begin_new) < length(boundary_index)
    All_begin_new(end+1,:) = 0;
     All_end_new(end+1,:) = 0;
end
while length(All_begin_new)>length(boundary_index)
       boundary_index(end+1,:)=0;
end
heart_sounds = cat(2,All_begin_new(:,1),boundary_index,All_end_new(:,1));
if heart_sounds(end,1) ==0;
   heart_sounds(end,2) =0;
   heart_sounds(any(heart_sounds,2)==0,:)=[];
end
%% print
for c = 1: length(S1_boundary_begin_new)
       xline(S1_boundary_begin_new(c,1),'r','linewidth',1.5)
       xline(S1_boundary_end_new(c,1),'r','linewidth',1.5)
end

for c = 1: length(S2_boundary_begin_new)
       xline(S2_boundary_begin_new(c,1),'g','linewidth',1.5)
       xline(S2_boundary_end_new(c,1),'g','linewidth',1.5)
end