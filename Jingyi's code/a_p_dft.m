function [A,PHI,f]=a_p_dft(x,fs,N);
% calculate the amplitude (A) and phase (PHI) of the Fourier transform of x. f is the frequency scale for the spectrum.
% fs is the sampling rate, and N is the number of samples over which the DFT is calculated. 
% If N is omitted, the default is the length of x. 
% if x is real, only the positive frequencies will be given
if nargin==2
N=length(x);
end
X=fft(x,N);
f=[0:N-1]*fs/N;
i=find(f>fs/2);
f(i)=f(i)-fs;
    [f,i]=sort(f);
    X1=X(i);
if sum(imag(x).^2)>0
    disp('WARNING: complex x')
else % for real f, give only the positive frequencies
    f0=find(f==0);
    X2=X1(f0-1:-1:1); % get the negative half of the spectrum
    X1=X1(f0:length(X1)); % get all the positive frequencies
    X1(2:length(X2)+1)=X1(2:length(X2)+1)+conj(X2); % add the negative and positive frequency components
        f=f(f0:length(f)); % get all the positive frequencies
end;
    A=abs(X1)/N;
    PHI=angle(X1);
  %  keyboard
