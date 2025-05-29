load('.\healthy-unhealthy\mat files\signal_sizes.mat')
load(".\healthy-unhealthy\mat files\mcs_accuracy.mat")
plot(signal_sizes, accuracy, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w');
hold on
load(".\healthy-unhealthy\mat files\vibration_accuracy.mat")
plot(signal_sizes, accuracy, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w');
hold off
xlabel('Signal length (samples)', 'FontSize', 12);
ylabel('Accuracy', 'FontSize', 12);
grid on;
ylim([0, 1]);

legend('MCS','Vibration')
title('Two classes: Healthy/Unhealthy')

figure;

load('.\healthy-ir-or\mat files\signal_sizes.mat')
load(".\healthy-ir-or\mat files\mcs_accuracy.mat")
plot(signal_sizes, accuracy, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w');
hold on
load(".\healthy-ir-or\mat files\vibration_accuracy.mat")
plot(signal_sizes, accuracy, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w');
hold off
xlabel('Signal length (samples)', 'FontSize', 12);
ylabel('Accuracy', 'FontSize', 12);
grid on;
ylim([0, 1]);

legend('MCS','Vibration')
title('Three classes: Healthy/IR Damage/OR Damage')


% text_offset = (max(accuracy) - min(accuracy)) * 0.05;
% 
% for i = 1:length(signal_sizes)
%     text(signal_sizes(i), accuracy(i) + text_offset, ...
%         sprintf('%.1f%%', accuracy(i)*100), ...
%         'FontSize', 10, ...
%         'HorizontalAlignment', 'center');
% end