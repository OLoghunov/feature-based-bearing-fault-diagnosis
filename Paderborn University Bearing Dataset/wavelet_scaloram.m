% clear all
% % 
% % % [~,wavefunc,x] = wavefun('db4', 5);
% % % 
% % % figure
% % % plot(x, wavefunc)
% % % 
% % % t = 0:1/1e3:10;
% % % fo = 10;
% % % f1 = 400;
% % % y = chirp(t,fo,10,f1,'logarithmic');
% % % 
% % % figure
% % % plot(y)
% % 
% % % create Morlet wavelet
% % % 
% % freq = 5;
% % x = -5:1/16:5;
% % morlet = cos(freq.*x) .* exp(-(x.^2)./2);
% % 
% % figure
% % plot(x, morlet)
% % 
% % % create signal
% % % 
% % t = 0:1/1e3:10;
% % fo = 10;
% % f1 = 400;
% % y = chirp(t,fo,10,f1,'logarithmic');
% % 
% % figure
% % plot(t, y)
% 
% wavelets = ["db2", "db3", "db4", "sym3", "sym4"];
% load('signal_vibration_ordamage.mat')
% 
% % create signal
% % 
% t = 0:1/1e3:10;
% f0 = 10;
% f1 = 400;
% sig = chirp(t,f0,10,f1,'logarithmic');
% 
% sig=sig(1:2000); 
% 
% for i = 1:length(wavelets)
%     figure()
%     wavelet = wavelets(i);   
% %     len = length(sig);
% % 
% %     title('Continuous Transform, absolute coefficients.') 
% %     ylabel('Scale')
% %     [cw1,sc] = cwt(sig,1:32,wavelet,'scal');
% %     title(strcat("Scalogram for Wavelet " + wavelet))
% %     ylabel('Scale')
% 
%     cwt(sig)
% end


% Fs = 1e3;
% t = 0:1/Fs:1;
% x = cos(2*pi*32*t).*(t>=0.1 & t<0.3)+sin(2*pi*64*t).*(t>0.7);
% wgnNoise = 0.05*randn(size(t));
% x = x+wgnNoise;


Fs = 1e3;
t = 0:1/Fs:1;
x = cos(2*pi*32*t).*(t>=0.1 & t<0.3)+sin(2*pi*64*t).*(t>0.7);
wgnNoise = 0.05*randn(size(t));
x = x+wgnNoise;
t = t+4;
% Here make the timetable
tt = timetable(x(:),'RowTimes',seconds(t'));
cwt(tt)