function [ NOx_gkm_05, Time_Mod, Ppm_V_NOx ] = read_Testo( Raw_Data_Testo, Raw_Datalogger )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Ppm_V_NOx = Raw_Data_Testo{1:end,4};
Time_Testo = transpose(1:length(Ppm_V_NOx));
Ppm_V_NO = Raw_Data_Testo{1:end,5};
Ppm_V_NO2 = Raw_Data_Testo{1:end,6};
Ppm_V_CO = Raw_Data_Testo{1:end,7};
Perc_O2 = Raw_Data_Testo{1:end,8};
%Perc_CO2IR = Raw_Data_Testo{1:end,9};
Ppm_V_CO2IR = Raw_Data_Testo{1:end,9};

Speed = Raw_Datalogger{1:end,6}./3.6; % [m/s]
Mass_Flow_Air = Raw_Datalogger{1:end,9}; % [g_air/s]
CL = Raw_Datalogger{1:end,8}; % car load [%]
Time_Datalogger = transpose(1:0.1:length(Speed)/10+0.9);
% fait un vecteur commençant à 1s et s'incrementant de 0.1s

AF_st = 14.5;
% Ppm massiques de NO et NO2 : calculs comme 2 zouaves
Ppm_M_NO = (30./(4*Perc_O2.*10^-2+16*Ppm_V_CO2IR.*10^-6+28)).*Ppm_V_NO;
Ppm_M_NO2 = (46./(4*Perc_O2.*10^-2+16*Ppm_V_CO2IR.*10^-6+28)).*Ppm_V_NO2;

Lambda_06 = 1/0.6;
Lambda_03 = 1/0.3;
Lambda_05 = 1/0.5;

% dans la suite MOD vaut pour modifier, a savoir donnees du datalogger sont
% divisees par 10 en longueur et donnees du testo sont recoupees a la bonne
% longueur
Speed = Speed/1000; % to be in [km/s]
[Mass_Flow_Air_Mod, ~] = mean_datalogger(Mass_Flow_Air);
%Mean_Maf = mean(Mass_Flow_Air_Mod) % 23.5 [g/s]
[Speed_Mod, Time_Mod] = mean_datalogger(Speed);
%Lambda_Mod = Lambda(1:length(Mass_Flow_Air_Mod));
Lambda_Mod_06 = ones(length(Mass_Flow_Air_Mod),1)*Lambda_06;
Lambda_Mod_03 = ones(length(Mass_Flow_Air_Mod),1)*Lambda_03;
Lambda_Mod_05 = ones(length(Mass_Flow_Air_Mod),1)*Lambda_05;

Ppm_M_NO_Mod = Ppm_M_NO(1:length(Mass_Flow_Air_Mod)); 
Ppm_M_NO2_Mod = Ppm_M_NO2(1:length(Mass_Flow_Air_Mod)); 
%Mass_Flow_Gas = Mass_Flow_Air_Mod.*(1+(1./(Lambda_Mod*AF_st)));
Mass_Flow_Gas_06 = Mass_Flow_Air_Mod.*(1+(1./(Lambda_Mod_06*AF_st)));
Mass_Flow_Gas_03 = Mass_Flow_Air_Mod.*(1+(1./(Lambda_Mod_03*AF_st)));
Mass_Flow_Gas_05 = Mass_Flow_Air_Mod.*(1+(1./(Lambda_Mod_05*AF_st)));
Mass_Flow_Gas_ma = Mass_Flow_Air_Mod;

% ajout corbi
Ppm_V_NOx = Ppm_V_NOx(1:length(Mass_Flow_Air_Mod));

%NOx_gkm = zeros(length(Mass_Flow_Gas),1);
NOx_gkm_06 = zeros(length(Mass_Flow_Gas_06),1);
NOx_gkm_03 = zeros(length(Mass_Flow_Gas_06),1);
NOx_gkm_05 = zeros(length(Mass_Flow_Gas_06),1);
NOx_gkm_ma = zeros(length(Mass_Flow_Gas_06),1);

for j = 1:length(Speed_Mod)
    if Speed_Mod(j) > 1/3600 % Si vit sup à 3 km/h
        %NOx_gkm(j) = ((Ppm_M_NO_Mod(j)*10^(-6)+Ppm_M_NO2_Mod(j)*10^(-6)).*Mass_Flow_Gas(j))./Speed_Mod(j);
        NOx_gkm_06(j) = ((Ppm_M_NO_Mod(j)*10^(-6)+Ppm_M_NO2_Mod(j)*10^(-6)).*Mass_Flow_Gas_06(j))./Speed_Mod(j);
        NOx_gkm_03(j) = ((Ppm_M_NO_Mod(j)*10^(-6)+Ppm_M_NO2_Mod(j)*10^(-6)).*Mass_Flow_Gas_03(j))./Speed_Mod(j);
        NOx_gkm_05(j) = ((Ppm_M_NO_Mod(j)*10^(-6)+Ppm_M_NO2_Mod(j)*10^(-6)).*Mass_Flow_Gas_05(j))./Speed_Mod(j);
        
        NOx_gkm_ma(j) = ((Ppm_M_NO_Mod(j)*10^(-6)+Ppm_M_NO2_Mod(j)*10^(-6)).*Mass_Flow_Gas_ma(j))./Speed_Mod(j);
    end
end
%Mean_NOx_06 = mean(NOx_gkm_06);
%Mean_NOx_03 = mean(NOx_gkm_03);
Mean_NOx_05 = mean(NOx_gkm_05);
%Mean_NOx_ma = mean(NOx_gkm_ma);


%% Plots
% figure; % plot ppm NOx
% plot(Time_Testo,Ppm_V_CO);
% xlabel('Duration [s]','FontSize',20); ylabel('CO [Ppm]','FontSize',20);
% set(gca,'FontSize',20);

% figure; % [11]
% plot(Time_Mod, NOx_gkm_05); 
% sMean = sprintf('Mean = %.3f',Mean_NOx_05);
% xlabel('Duration [s]','FontSize',20); ylabel('NOx [g/km]','FontSize',20);
% set(gca,'FontSize',20); legend(sMean);

end

