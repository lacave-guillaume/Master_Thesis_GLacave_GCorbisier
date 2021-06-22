function [ Vec_Mean, Time_Mod] = mean_datalogger( Vec_Wo )
%UNTITLED2 Function that will take the mean of 10 values from the
%datalogger and put all the mean values into one single vector
% Cela permet de transformer le vecteur en secondes et ne plus l'avoir en
% 10eme de seconde et cela smooth les données

% rest = mod(length(Vec_wo),10);
% Vec_wo = Vec_wo(1:end-rest);
% Time = Time(1:end-rest);
% Vec_mean = zeros(length(Vec_wo),1);
% for i = 1:10:length(Vec_wo)
%     Vec_10 = Vec_wo(i:i+9); % vector variable dans lequel s'ecrivent 10 valeurs
%     Vec_mean(i) = mean(Vec_10);
% end
% End_Vec_mean = length(Vec_mean);
% Vec_mean = Vec_mean(1:10:End_Vec_mean);
% End_time = length(Time);
% Time = Time(1:10:End_time);

Vec_Mean = zeros(length(Vec_Wo),1);
for i = 1:10:length(Vec_Wo)
    %disp(i)
    if  i < length(Vec_Wo)-10
        Vec_10 = Vec_Wo(i:i+9);
        Vec_Mean(i) = mean(Vec_10);
    else
        Vec_aleatoire = Vec_Wo(i:end);
        Vec_Mean(i) = mean(Vec_aleatoire);
    end
end
Vec_Mean = Vec_Mean(1:10:length(Vec_Mean));
Time_Mod = transpose(1:length(Vec_Mean));
end

