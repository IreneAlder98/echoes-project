function [SYS,SYS_min,SYS_max,DIA,DIA_min,DIA_max] = Systolic_and_distolic_index(heartRate)
%% Find the systolic time interval;
% SYS is average length of the systole in ms
if heartRate > 80
    SYS = -1.14*heartRate + 371.55;
else
    SYS = -6.58*heartRate + 766.44;

end

% Calculate the maximum systolic length and minium systolic length
SYS_min = SYS - 175;
SYS_max = SYS + 175;

%% Find the average diastole length (DIA)
DIA = 60*1000/heartRate - SYS;
% Calculate the minmum and maximum diastole length

DIA_max =60*1000/heartRate -SYS_min;
DIA_min =60*1000/heartRate -SYS_max;