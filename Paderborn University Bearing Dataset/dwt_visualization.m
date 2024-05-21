clear all

% load freqbrk; 
% signal = freqbrk;
% 
% load('signal_vibration_ordamage.mat')
% signal = sig;

t = 0:1/1e3:2;
fo = 150;
f1 = 400;
signal = chirp(t,fo,1,f1,'quadratic',[],'convex');

lev = 5;
wname = 'db1'; 
nbcol = 64; 
[c,l] = wavedec(signal,lev,wname);

len = length(signal);
cfd = zeros(lev,len);
for k = 1:lev
    d = detcoef(c,l,k);
    d = d(:)';
    d = d(ones(1,2^k),:);
    cfd(k,:) = wkeep(d(:)',len);
end
cfd = cfd(:);
I = find(abs(cfd)<sqrt(eps));
cfd(I) = zeros(size(I));
cfd = reshape(cfd,lev,len);
cfd = wcodemat(cfd,nbcol,'row');

h211 = subplot(3,1,1);
h211.XTick = [];
plot(signal);
title('Analyzed signal');
ylabel('Magnitude');
ax = gca;
ax.XLim = [1 length(signal)];
subplot(3,1,2);
colormap("turbo");

cfd = medfilt2(cfd);
imagesc(cfd, [0 75]);
tics = 1:lev;
labs = int2str(tics');
ax = gca;
ax.YTickLabelMode = 'manual';
ax.YDir = 'normal';
ax.Box = 'On';
ax.YTick = tics;
ax.YTickLabel = labs;
title('Discrete Transform, absolute coefficients');
ylabel('Level');
set(gca, 'YDir','reverse')

subplot(3,1,3);
[cfs,f] = cwt(signal,1,'waveletparameters',[3 3.1]);
hp = pcolor(1:length(signal),f,abs(cfs)); hp.EdgeColor = 'none'; 
set(gca,'YScale','log');
title('Continuous Transform, absolute coefficients');
xlabel('Sample number'); ylabel('log10(f)');