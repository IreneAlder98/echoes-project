%% Script to detect Aortic Stenosis from .wav filestotal_path
% Get a list of all files in the folder with the desired file type
% filePattern = fullfile('C:\Users\10930\Desktop\Final\All data of heartsound\ECHOES DATA FOR SEGMENTATION\', '*.wav');
% Files = dir(filePattern);
% for f = 1:length(Files)
%     baseFileName = Files(f).name;
%     fullFileName = fullfile(Files(f).folder, baseFileName);
fileFolder = fullfile('C:\Users\10930\Desktop\Final\EKO data for segmentation\EKO patient data for segmentation'); % Search the folder
diroutput = dir(fullfile(fileFolder,'*.wav')); % Search all the "wav" file information.
filename = {diroutput.name};% Put audio file name and put it in the fileName.
path = {diroutput.folder};
% %Enter filename and entire filepath here
numfiles = length (path); % Count of heartsounds in the directory
audiofiles = cell(numfiles,1); % Creating a variable to hold martix of audio files.
for k = 1 : numfiles
audiofiles{k}= strcat(path{k},'\',filename{k});
end
%% Heart sound Normalization and pre-process low-pass filter
S=8;% Change the value of S and M to run one single recording in the whole folder.
M =1;
[y,fs] = audioread(audiofiles{S});
% y = downsample(y,5); % Just use for Echoes recordings. 5 can be adjusted.
% fs =fs/5; % Just use for Echoes recordings. 5 can be adjusted.
y = y(:,1);
dt = 1/fs;
total_t = length(y)*dt;
t = (0:dt:(total_t)-dt)';
%% Pre-process of the signal
fc=40; % the cut-off frequency for low-pass filter
filter_parameters.N=2; % order of the filter
filter_parameters.type='butter';% apply type
% of filter ('Butterworth')
filter_parameters.lphp='low'; % Set the filter to low-pass
[b,a]=make_digital_filter(fc,fs,filter_parameters);% make filter parameters
D1=filter(b,a,y);% apply the low-pass filter
N_IR=fs; % set length, in samples, of impulse
         % rewponse to calculate
[h,th,H,fH]=i_f_response(b,a,fs,N_IR);%calculate the impulse and frequency response

% Apply the high-pass filter
filter_parameters.lphp='high'; % Set the filter to high-pass
fc=190; % the cut-off frequency for high-pass filter
filter_parameters.N=2; % order of the filter
[b,a]=make_digital_filter(fc,fs,filter_parameters);% make new filter parameters
D2=filter(b,a,D1);
D2=D2*1000;
figure
plot (t,y,'r',t,D2,'c');
D2 = D2./max(abs(D2));

%% hilbert transform to get the envelope curve
exponentialMA = Homomorphic_Envelope_with_Hilbert(D2, fs,12.5,1);
%%  Heart rate detection
[heartRate,period_index] = heartRate_detection(exponentialMA,fs);
%% Making an adaptive threshold of finding Peaks
[pks,locs,threshold,time,exponentialMA] = Threshold_find_peaks(exponentialMA,heartRate,fs);
%% Refind the peak locations using heartRate
[pks,locs] = Refind_energy_threshold(locs,period_index,threshold,exponentialMA,fs,time);
%% Find the systolic and diastolic time interval;
[SYS,SYS_min,SYS_max,DIA,DIA_min,DIA_max] = Systolic_and_distolic_index(heartRate);
%% Peak Classification (detect peaks are S1 or S2)
% Calculate spaces_between matrix giving time differences between each peak
for c = 1:length(locs)-1
    space_b(c,1) = locs(c+1,1) - locs(c,1);
    spaces_between(c,1) = 1000*space_b(c,1);
end

% Remove the wrong peak
[locs] = Wrong_peak_detection (heartRate,locs,spaces_between,SYS_min,SYS_max,DIA_min,DIA_max);
%% classify which peak is S1 and which is S2
[boundary_index,locs_new,spaces_between_new,locs_index] = classifyPeaks(locs,SYS,SYS_min,SYS_max,DIA,DIA_min,DIA_max);   
%% Output Boundary Detection
% boundary_index = boundary_index.';
% locs_new =locs_new.';
[heart_sounds] = Boundary_detection(exponentialMA,t,locs_new,boundary_index);
%% Murmur detection by calculate the amplitude ratio
[ampt_12,ampt_21,S12_t,S21_t,ratio]=CalculateAmplitude(heart_sounds,fs,exponentialMA);
[SD_ratio] = AmplitudeMetrics(ampt_12,ampt_21,ratio);
%% calculate the decected peaks compared with the mannual label
% S1_correct=0;
% S2_correct=0;
%     for n =1:40
%         for k = 1: length(S1_boundary_begin_new)
%         if  S1_boundary_begin_new(k,1) - S1_bound_on_EKO(n,M) <= 0.025 && S1_bound_off_EKO(n,M) - S1_boundary_end_new(k,1)<= 0.025
%              S1_correct = S1_correct+1; % 0.025 is the accept window of the peak detected locations.
%         end
%         end
%     end
% 
%    for n =1:38 
%         for l =1: length(S2_boundary_begin_new)
%             if S2_boundary_begin_new(l,1) - S2_bound_on_EKO(n,M) <= 0.035 && S2_bound_off_EKO(n,M) - S2_boundary_end_new(l,1)<= 0.55
%                      S2_correct = S2_correct+1;
%             end
%         end
%     end
% a = [S1_correct,S2_correct,SD_ratio,length(S1_boundary_end_new),length(S2_boundary_begin_new)];
