close all; 
clear;
%function [NOx_gkm_06] = NOx_Reader(Raw_Data_Testo, Raw_Datalog)
%% NOx : extracting data from TESTO
%Raw_Data_Testo = readtable('Testo-10-04-Overijse.xlsx');
%Raw_Data_Testo = readtable('Testo-18-05-TESTNOX.xlsx');
Raw_Data_Testo = readtable('BONORDRE-WLTPV3-Testo.xlsx');

% Measured PPM are PPM in volume
%Time_Testo = Raw_Data_Testo{1:end,2};
Ppm_V_NOx = Raw_Data_Testo{1:end,4};
Time_Testo = transpose(1:length(Ppm_V_NOx));
Ppm_V_NO = Raw_Data_Testo{1:end,5};
Mean_Ppm_V_NO = mean(Ppm_V_NO(885:905));
Ppm_V_NO2 = Raw_Data_Testo{1:end,6};
Mean_Ppm_V_NO2 = mean(Ppm_V_NO2(885:905));
Ppm_V_CO = Raw_Data_Testo{1:end,7};
Perc_O2 = Raw_Data_Testo{1:end,8};
%Perc_CO2IR = Raw_Data_Testo{1:end,9};
Ppm_V_CO2IR = Raw_Data_Testo{1:end,9};
Lam = Raw_Data_Testo{1:end,15};
% chiant, le lambda est une cell car cases contenant '-'
Lam2 = zeros(length(Lam),1);
for i = 1:length(Lam)% boucle pour transformer les '-' en 0 et les string en double
    if Lam{i} == '-'
        Lam2(i) = 0;
    else
    Lam2(i) = str2double(Lam{i});
    end
end 

%% Datalogger
%Raw_Datalog = readtable('wltp3-datalogger.xlsx');
Raw_Datalog = readtable('BONORDRE-WLTPV3-Datalogger.xlsx');
Speed = Raw_Datalog{1:end,6}./3.6; % [m/s]
Mass_Flow_Air = Raw_Datalog{1:end,9}; % [g_air/s]
CL = Raw_Datalog{1:end,8}; % car load [%]
Time_Datalogger = transpose(1:0.1:length(Speed)/10+0.9); 
% fait un vecteur commençant à 1s et s'incrementant de 0.1s

%% Variable declaration : Diesel C12H23, x=0; y=23.12
% Fuel CHyOx = diesel C12H23 = CH_{23/12}
X = 0;
Y = 23/12;
AF_st = 14.5; % air-fuel ratio stoichiometric for diesel
% https://x-engineer.org/automotive-engineering/internal-combustion-engines
% /performance/air-fuel-ratio-lambda-engine-performance/ 

%% Computations
Lambda = (Perc_O2*10^-2 - (0.5*(1+Y/4)*Ppm_V_CO*10^-6))...
./((1+(Y-2*X)/4)*(Ppm_V_CO2IR*10^-6 + Ppm_V_CO*10^-6))+1;
% equation 3.46 livre combustion
Lambda_wo = filloutliers(Lambda,'linear');
Mean_Lambda_wo = mean(Lambda_wo);

Lambda_Other = (Perc_O2*(10^-2)*(Y/4)-1-(Y/4))./(Perc_O2*(10^-2)*(1+(Y/4)+3.76*(1+(Y/4)))-(1+(Y/4)));
Lambda_Other_wo = filloutliers(Lambda_Other,'linear');
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
Mean_Maf = mean(Mass_Flow_Air_Mod) % 23.5 [g/s]
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
Mean_NOx_06 = mean(NOx_gkm_06);
Mean_NOx_03 = mean(NOx_gkm_03);
Mean_NOx_05 = mean(NOx_gkm_05)
Mean_NOx_ma = mean(NOx_gkm_ma);

%% Plots
figure; % [1] % plot ppm NOx and ppm CO Testo      
plot(Time_Testo,Ppm_V_NOx); 
hold on;
plot(Time_Testo,Ppm_V_CO); 
xlabel('Duration [s]','FontSize',20); ylabel('[Ppm]','FontSize',20);
set(gca,'FontSize',20); legend('NOx','CO');

figure; % [plot ]
plot(Time_Testo,Ppm_V_NOx); 
xlabel('Duration [s]','FontSize',20); ylabel('NOx [Ppm]','FontSize',20);
set(gca,'FontSize',20); %legend('NOx');

k = (Ppm_V_CO*10^-6)./(Ppm_V_CO*10^-6+ Ppm_V_CO2IR*10^-6);
figure; %[2] plot ppm NOx and ppm CO Testo   
subplot(2,1,1);
plot(Time_Testo,Ppm_V_NOx); 
xlabel('Duration [s]','FontSize',20); ylabel('[Ppm]','FontSize',20);
set(gca,'FontSize',20); legend('NOx');
subplot(2,1,2);
plot(Time_Testo,k); 
xlabel('Duration [s]','FontSize',20); ylabel('k [-]','FontSize',20);
set(gca,'FontSize',20); legend('k');

figure; % [3]
plot(Time_Testo, Perc_O2);  hold on;
plot(Time_Testo,Ppm_V_CO2IR.*10^-4);
xlabel('Duration [s]','FontSize',20); ylabel('[%]','FontSize',20);
set(gca,'FontSize',20); legend('O2','CO2IR');

figure; % [4]
plot(Time_Testo, Lambda_wo, 'LineWidth', 2);  %hold on;
%plot(Time_Testo, Lam2)
xlabel('Duration [s]','FontSize',20); ylabel('Lambda [-]','FontSize',20);
set(gca,'FontSize',20);

figure; % [5]
plot(Time_Testo, Lambda_wo);  hold on;
plot(Time_Testo, Lam2)
xlabel('Duration [s]','FontSize',20); ylabel('Lambda [-]','FontSize',20);
set(gca,'FontSize',20);

figure; % [6] 
plot(Time_Testo, Lambda_Other_wo);  
xlabel('Duration [s]','FontSize',20); ylabel('Lambda [-]','FontSize',20);
set(gca,'FontSize',20);

figure; % [9]
subplot(2,1,1);
plot(Time_Mod, Mass_Flow_Air_Mod); 
xlabel('Duration [s]','FontSize',20); ylabel('Mass flow air [g/s]','FontSize',20);
set(gca,'FontSize',20);
subplot(2,1,2);
plot(Time_Mod, NOx_gkm_05); 
xlabel('Duration [s]','FontSize',20); ylabel('NOx [g/km]','FontSize',20);
set(gca,'FontSize',20);

figure; 
subplot(2,1,1);
plot(Time_Testo,Ppm_V_NO); 
xlabel('Duration [s]','FontSize',20); ylabel('Ppm-v NO [Ppm]','FontSize',20);
set(gca,'FontSize',20);
subplot(2,1,2)
plot(Time_Testo,Ppm_V_NO2); 
xlabel('Duration [s]','FontSize',20); ylabel('Ppm-v NO2 [Ppm]','FontSize',20);
set(gca,'FontSize',20);

% figure; % [10]
% plot(Time_Mod, NOx_gkm);  
% xlabel('Duration [s]','FontSize',20); ylabel('NOx [g/km]','FontSize',20);
% set(gca,'FontSize',20);

figure; % [11]
plot(Time_Mod, NOx_gkm_06); hold on; plot(Time_Mod, NOx_gkm_03); 
xlabel('Duration [s]','FontSize',20); ylabel('NOx [g/km]','FontSize',20);
set(gca,'FontSize',20); legend('06','03');

figure; % [11]
plot(Time_Mod(550:800), NOx_gkm_06(550:800)); hold on; plot(Time_Mod(550:800), NOx_gkm_03(550:800)); 
xlabel('Duration [s]','FontSize',20); ylabel('NOx [g/km]','FontSize',20);
set(gca,'FontSize',20); legend('06','03');


 
% %% NOx en fonction de v*a+
% Speed_va = Raw_Datalog{2:end,6};
% Speed_va = Speed_va./3.6;
% Time_va = transpose(0.1:0.1:length(Speed_va)/10);
% % this is the "finite difference" derivative. Note it is  one element shorter than y and x
% y_Acc = diff(Speed_va)./diff(Time_va);
% % this is to assign yd an abscissa midway between two subsequent x
% x_Acc = (Time_va(2:end)+Time_va(1:(end-1)))/2;
% % this should be a rough plot of your derivative
% Speed_va = Speed_va(1:end-1);
% Time_va = Time_va(1:end-1);
% for i=length(y_Acc):-1:1
%     if y_Acc(i) <= 0
%         y_Acc(i) = [];
%         Speed_va(i) = [];
%         Time_va(i) = [];
%     end
% end
% va_pos = zeros(length(Speed_va),1);
% for i=1:length(Speed_va)
%     va_pos(i) = Speed_va(i)*y_Acc(i); 
% end
% [va_pos_wo,Time_va_pos] = remove_outlier_va_pos(va_pos,Time_va);
% [Mean_va_pos,Time_va_pos] = mean_datalogger(va_pos_wo,Time_va_pos);
% 
% figure; % va_pos & NOx
% subplot(2,1,1)
% plot(Time_Testo,Ppm_NOx);
% xlabel('Duration [s]','FontSize',20);
% ylabel('NOx [Ppm]','FontSize',20); set(gca,'FontSize',20);
% legend('NOx');
% subplot(2,1,2)
% plot(Time_va_pos,Mean_va_pos);
% xlabel('Duration [s]','FontSize',20);
% ylabel('v*a_{pos}[m^2/s^3]','FontSize',20);
% set(gca,'FontSize',20)
% legend('v*a_{+}');


