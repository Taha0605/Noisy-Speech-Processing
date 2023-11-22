clear x fs
filePath = 'C:\Users\Taha\OneDrive\Desktop\Semesters\7thSem\DSP\Assignment\Assaudio.wav';
[x, fs] = audioread(filePath);
% x is the audio data, fs is the sampling rate

% Now, x_n is defined as x
x_n = downsample(x, 10);
Fs = fs/10;
t=0:1/Fs:2.52;
t=t(1:12096);
f=linspace(0,Fs,length(x_n));
y_n = zeros(size(x_n));
for i=1:length(x_n)
y_n(i) = i*x_n(i);
end


X_k= (fft(x_n));
Y_k = (fft(y_n));

tau_X_k = (real(X_k).*real(Y_k) + imag(X_k).*imag(Y_k))./(real(X_k).*real(X_k) + imag(X_k).*imag(X_k));

% Compute the cepstrum
cepstrum = ifft(log(abs(X_k).^2));

% Perform smoothing in the cepstral domain
window_size = 10; % Adjust the window size as needed
smoothed_cepstrum = smoothdata(cepstrum, 'movmean', window_size);
% Inverse cepstrum to get the smoothed signal
%smoothed_signal = real(ifft(exp(fft(smoothed_cepstrum))));
subplot(6,1,1);
plot(t,x_n);
title('Original Speech Signal');
xlabel('Time (s)')
grid on;

S_k = (fft(smoothed_cepstrum));

zero_spectrum = (abs(X_k).^2)./(S_k);

%plot(abs(zero_spectrum).^2);

% Calculate the modified group delay function
modtau_X_k = tau_X_k .* abs(zero_spectrum);

cepstralvocal=dct(modtau_X_k);


subplot(6,1,2);
plot(f,tau_X_k);
title('Original Group Delay Function')
xlabel('Frequency (Hz)');
grid on;

subplot(6, 1, 3);
plot(f,modtau_X_k);
title('Modified Group Delay Function');
xlabel('Frequency (Hz)');
grid on;

% Compute the Hilbert transform
analytical_signal = hilbert(cepstralvocal);

% Extract the envelope (magnitude of the analytical signal)
envelope = abs(cepstralvocal);


subplot(6,1,4);
plot(f,cepstralvocal);
xlabel('Frequency (Hz)');
title('Extracted Cepstral Coefficiencts');
grid on;

subplot(6,1,5);
plot(f,envelope);
xlabel('Frequency (Hz)');
title('Vocal Tract Spectrum');
grid on;

% Apply a moving average to smoothen the envelope curve
smoothed_envelope = movmean(envelope, window_size);

% Plot the original envelope and the smoothed envelope
subplot(6,1,6)
plot(f,smoothed_envelope);
title('Smoothened Vocal Tract Spectrum');
xlabel('Frequency (Hz)');
