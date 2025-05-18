function fittedmdl = fitGGD(x)
    [y,x] = histcounts(x,'Normalization','probability');
    x(end) = [];

    normFactor = 1/(x(2) - x(1));

    x = x*normFactor;

    a = (x(end) - x(1))/5; % bell curve width
    b = 2; % bell curve form
    m = (x(end) - x(1))/2 + x(1); % math expectation
    
    mdl = fittype('b/(2*a*gamma(1/b)) * (exp(-(abs(x-m)/a).^b))','indep','x');
    
    fittedmdl = fit(x',y',mdl,'start',[a b m],'lower',[0 0 0]);

    % Here warnings occur     
    fittedmdl.a = fittedmdl.a/normFactor;
    fittedmdl.m = fittedmdl.m/normFactor;
end

