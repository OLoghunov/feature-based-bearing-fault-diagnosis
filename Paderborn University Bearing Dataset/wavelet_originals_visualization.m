[psi,xval] = wavefun('morl',10);
subplot(1,2,1)
plot(xval,psi);
title('Real-valued Morlet Wavelet');

[psi,xval] = wavefun('mexh',10);
subplot(1,2,2)
plot(xval,psi);
title('Mexican Hat Wavelet');