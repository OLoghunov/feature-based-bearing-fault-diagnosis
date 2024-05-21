x = 0:1/2048:1;
y = sin(250 * pi * x.^2);
wavelet = "sym5";

[c,l] = wavedec(y,1,wavelet);
approx1 = appcoef(c,l,wavelet);
[c,l] = wavedec(y,2,wavelet);
approx2 = appcoef(c,l,wavelet);
[c,l] = wavedec(y,3,wavelet);
approx3 = appcoef(c,l,wavelet);
[c,l] = wavedec(y,4,wavelet);
approx4 = appcoef(c,l,wavelet);
[c,l] = wavedec(y,5,wavelet);
approx5 = appcoef(c,l,wavelet);
[cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);

subplot(6,2,[1 2])
plot(x,y)
title("Chirp Signal")
subplot(6,2,3)
plot(approx1)
title("Level 1 Approximation Coefficients")
subplot(6,2,4)
plot(cd1)
title("Level 1 Detail Coefficients")
subplot(6,2,5)
plot(approx2)
title("Level 2 Approximation Coefficients")
subplot(6,2,6)
plot(cd2)
title("Level 2 Detail Coefficients")
subplot(6,2,7)
plot(approx3)
title("Level 3 Approximation Coefficients")
subplot(6,2,8)
plot(cd3)
title("Level 3 Detail Coefficients")
subplot(6,2,9)
plot(approx4)
title("Level 4 Approximation Coefficients")
subplot(6,2,10)
plot(cd4)
title("Level 4 Detail Coefficients")
subplot(6,2,11)
plot(approx5)
title("Level 5 Approximation Coefficients")
subplot(6,2,12)
plot(cd5)
title("Level 5 Detail Coefficients")

