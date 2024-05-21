distType = 'lognormal';

subplot(5,2,1)
histfit(DistNormalize(detail1OR), [], distType)
title("OR Damage")
xlabel("1 Level")

subplot(5,2,2)
histfit(DistNormalize(detail1IR), [], distType)
title("IR Damage")
xlabel("1 Level")

subplot(5,2,3)
histfit(DistNormalize(detail2OR), [], distType)
xlabel("2 Level")

subplot(5,2,4)
histfit(DistNormalize(detail2IR), [], distType)
xlabel("2 Level")

subplot(5,2,5)
histfit(DistNormalize(detail3OR), [], distType)
xlabel("3 Level")

subplot(5,2,6)
histfit(DistNormalize(detail3IR), [], distType)
xlabel("3 Level")

subplot(5,2,7)
histfit(DistNormalize(detail4OR), [], distType)
xlabel("4 Level")

subplot(5,2,8)
histfit(DistNormalize(detail4IR), [], distType)
xlabel("4 Level")

subplot(5,2,9)
histfit(DistNormalize(detail5OR), [], distType)
xlabel("5 Level")

subplot(5,2,10)
histfit(DistNormalize(detail5IR), [], distType)
xlabel("5 Level")