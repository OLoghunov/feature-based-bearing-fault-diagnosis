function fittedmdl = fit_GGD(x)
    [y,x] = histcounts(x,'Normalization','probability');
    x(end) = [];

    norm_factor = 1/(x(2) - x(1));

    x = x*norm_factor;

    a = (x(end) - x(1))/5; % bell curve width
    b = 2; % bell curve form
    m = (x(end) - x(1))/2 + x(1); % math expectation
    
    mdl = fittype('b/(2*a*gamma(1/b)) * (exp(-(abs(x-m)/a).^b))','indep','x');
    
    fittedmdl = fit(x',y',mdl,'start',[a b m],'lower',[0 0 0]);

    % Here warnings occur     
    fittedmdl.a = fittedmdl.a/norm_factor;
    fittedmdl.m = fittedmdl.m/norm_factor;
end

