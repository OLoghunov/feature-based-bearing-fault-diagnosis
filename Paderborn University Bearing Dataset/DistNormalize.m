function wave_norm = DistNormalize(approx)
    wave_norm = (approx - min(approx)) / ( max(approx) - min(approx));
    wave_norm = wave_norm + 0.00001;
    wave_norm = rmoutliers(wave_norm, 'median');
    wave_norm = wave_norm';