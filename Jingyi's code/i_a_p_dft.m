function [x,t]=i_a_p_dft(a,phi,f,fs);

% From the amplitude and phase spectra, a and phi respectively, referring to the frequencies f, reconstruct the signal by 
% inverse dft, at a sampling rate of fs. Note that fs must be higher than twice the maximum frequency in the signal (i.e. > 2*max(f)),
% to avoid aliasing. The routine therefore does not allow reconstruction at fs<2*max(f).

if fs<2*max(f)
    disp('ERROR: The inverse DFT must be performed with a sampling rate greater than twice the maximum frequency present');
    x=nan;
    t=nan;
else
T=1/f(2); % the period is equal to 1/fundamental frequency
N=round(T*fs);
t=[0:N-1]/fs;
X=zeros(1,N);
X(1:length(a))=a.*exp(j*phi);
X(2:length(a))=0.5*X(2:length(a));
X(N:-1:N-length(a)+2)=X(N:-1:N-length(a)+2)+conj(X(2:length(a)));
X=X*N;
x=ifft(X,N);
x=real(x);
end