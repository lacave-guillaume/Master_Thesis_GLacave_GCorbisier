close all;
clear;
% Script to plot the histograms and to analyse the driving behaviours
% Order : Ref, Agressive, Economic, Bad driver

% Raw_Data_Testo = readtable('Testo-wltp-agressif-v2.xlsx');
% Raw_Datalog = readtable('Datalogger-10-04-Overijse.xlsx'); % reading datalogger
%% Reading Datalogger

% test to determine the driving behaviours
Raw_Datalog_Wltp2_Ordre = readtable('WLTP2-Datalogger-BonOrdre.xlsx');
[ Ay_wltp2, Ay_wltp2_Pos, Speed_wltp2, Theta_wltp2, RPM_wltp2, Time_wltp2 ] = read_Datalogger( Raw_Datalog_Wltp2_Ordre );
Raw_Datalog_Agressif_V2 = readtable('Datalogger-wltp-AgressifV2-BonOrdre.xlsx'); 
[ Ay_AgressifV2, Ay_AgressifV2_Pos, Speed_AgressifV2, Theta_AgressifV2, RPM_AgressifV2 ,Time_AgressifV2 ] = read_Datalogger( Raw_Datalog_Agressif_V2 );
Raw_Datalog_Papy_Eco = readtable('PapyEco-Datalogger-BonOrdre.xlsx'); 
[ Ay_Papy_Eco, Ay_Papy_Eco_Pos, Speed_Papy_Eco, Theta_Papy_Eco, RPM_Papy_Eco, Time_Papy_Eco ] = read_Datalogger( Raw_Datalog_Papy_Eco );
Raw_Datalog_BadV2 = readtable('BadDriverV2-Datalogger-BonOrdre.xlsx'); 
[ Ay_BadV2, Ay_BadV2_Pos, Speed_BadV2, Theta_BadV2, RPM_BadV2, Time_BadV2 ] = read_Datalogger( Raw_Datalog_BadV2 );

% test to analyse the NOx production
% Raw_Datalog_Wltp2_Ordre = readtable('BONORDRE-WLTPV3-Datalogger.xlsx');
% [ Ay_wltp2, Ay_wltp2_Pos, Speed_wltp2, Theta_wltp2, RPM_wltp2, Time_wltp2 ] = read_Datalogger( Raw_Datalog_Wltp2_Ordre );
% Raw_Datalog_Agressif_V2 = readtable('BONORDRE-AgressifV3-Datalogger.xlsx'); 
% [ Ay_AgressifV2, Ay_AgressifV2_Pos, Speed_AgressifV2, Theta_AgressifV2, RPM_AgressifV2, Time_AgressifV2 ] = read_Datalogger( Raw_Datalog_Agressif_V2 );
% Raw_Datalog_Papy_Eco = readtable('BONORDRE-Eco-Datalogger.xlsx'); 
% [ Ay_Papy_Eco, Ay_Papy_Eco_Pos, Speed_Papy_Eco, Theta_Papy_Eco, RPM_Papy_Eco, Time_Papy_Eco ] = read_Datalogger( Raw_Datalog_Papy_Eco );
% Raw_Datalog_BadV2 = readtable('BONORDRE-BadDriverV3-Datalogger.xlsx'); 
% [ Ay_BadV2, Ay_BadV2_Pos, Speed_BadV2, Theta_BadV2, RPM_BadV2, Time_BadV2 ] = read_Datalogger( Raw_Datalog_BadV2 );

%% Reading Testo
Raw_Data_Testo_Wltp2_Ordre = readtable('WLTP2-Testo-BonOrdre.xlsx');
[ NOx_gkm_05_Wltp2_Ordre, Time_Mod_Wltp2_Ordre, Ppm_wltp2 ] = read_Testo( Raw_Data_Testo_Wltp2_Ordre, Raw_Datalog_Wltp2_Ordre );
Raw_Data_Testo_agressifV2_Ordre = readtable('Testo-AgressifV2-BonOrdre.xlsx');
[ NOx_gkm_05_AgressifV2, Time_Mod_AgressifV2, Ppm_AgressifV2 ] = read_Testo( Raw_Data_Testo_agressifV2_Ordre, Raw_Datalog_Agressif_V2 );
Raw_Data_Testo_Papy_Eco = readtable('Testo-PapyEco-BonOrdre.xlsx');
[ NOx_gkm_05_Papy_Eco, Time_Mod_Papy_Eco, Ppm_Papy_Eco ] = read_Testo( Raw_Data_Testo_Papy_Eco, Raw_Datalog_Papy_Eco );
Raw_Data_Testo_BadV2 = readtable('BadDriverV2-Testo-BonOrdre.xlsx');
[ NOx_gkm_05_BadV2, Time_Mod_BadV2, Ppm_BadV2 ] = read_Testo( Raw_Data_Testo_BadV2, Raw_Datalog_BadV2 );

% Raw_Data_Testo_Wltp2_Ordre = readtable('BONORDRE-WLTPV3-Testo.xlsx');
% [ NOx_gkm_05_Wltp2_Ordre, Time_Mod_Wltp2_Ordre, Ppm_wltp2 ] = read_Testo( Raw_Data_Testo_Wltp2_Ordre, Raw_Datalog_Wltp2_Ordre );
% Raw_Data_Testo_AgressifV2_Ordre = readtable('BONORDRE-AgressifV3-Testo.xlsx');
% [ NOx_gkm_05_AgressifV2, Time_Mod_AgressifV2, Ppm_AgressifV2 ] = read_Testo( Raw_Data_Testo_AgressifV2_Ordre, Raw_Datalog_Agressif_V2 );
% Raw_Data_Testo_Papy_Eco = readtable('BONORDRE-Eco-Testo.xlsx');
% [ NOx_gkm_05_Papy_Eco, Time_Mod_Papy_Eco, Ppm_Papy_Eco ] = read_Testo( Raw_Data_Testo_Papy_Eco, Raw_Datalog_Papy_Eco );
% Raw_Data_Testo_BadV2 = readtable('BONORDRE-BadDriverV3-Testo.xlsx');
% [ NOx_gkm_05_BadV2, Time_Mod_BadV2, Ppm_BadV2 ] = read_Testo( Raw_Data_Testo_BadV2, Raw_Datalog_BadV2 );

%% Moyenne de NOx
Mean_NOx_05_Wltp2_Ordre = mean(NOx_gkm_05_Wltp2_Ordre)
Mean_NOx_05_AgressifV2 = mean(NOx_gkm_05_AgressifV2)
Mean_NOx_05_Papy_Eco = mean(NOx_gkm_05_Papy_Eco)
Mean_NOx_05_BadV2 = mean(NOx_gkm_05_BadV2)

%% Analyse audi A1
% Raw_Datalog_Mai = readtable('Datalogger-18-05-21-wltp.xlsx'); 
% [ Ay_Mai, Ay_Mai_Pos, Speed_Mai, Theta_Mai, RPM_Mai, Time_Mai ] = read_Datalogger( Raw_Datalog_Mai );
% Raw_Data_Testo_Mai = readtable('Testo-18-05-21-wltp.xlsx');
% [ NOx_gkm_05_Mai, Time_Mod_Mai, Ppm_Mai ] = read_Testo( Raw_Data_Testo_Mai, Raw_Datalog_Mai );
% Mean_NOx_05_Mai = mean(NOx_gkm_05_Mai) % moy nox g/km
% Va_Pos_Mai = Speed_Mai.*Ay_Mai_Pos*9.81; % va pos
% CL_Mai_Pos = carload_fun(Ay_Mai_Pos, Speed_Mai, Theta_Mai, RPM_Mai); % calcul car load
% [N_Mai,Edges_Mai] = histcounts(Va_Pos_Mai,'BinWidth',1,'Normalization', 'probability');
% Perc_AboveX_Mai = 0; % calcul critere vapos 
% for i = 1:length(N_Mai)
%     if (Edges_Mai(i) <= 10) && (Edges_Mai(i) >= 2)
%         Perc_AboveX_Mai = Perc_AboveX_Mai + N_Mai(i);
%     end
% end
% [N_Mai_CL,Edges_Mai_CL] = histcounts(CL_Mai_Pos,'BinWidth',1,'Normalization', 'probability');
% Perc_CL_Mai = 0; % calcul critere CL
% for i = 1:length(N_Mai_CL)
%     if (Edges_Mai_CL(i) >= 50)
%         Perc_CL_Mai = Perc_CL_Mai + N_Mai_CL(i);
%     end
% end
% Mean_Mai = mean(Ay_Mai);
% Std_Mai = std(Ay_Mai);
% Mean = Mean_Mai;
% Std = Std_Mai;
% figure;
% h1 = histogram(Ay_Mai,'BinWidth',0.01,'Normalization', 'probability','FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')
% ylim([0 0.06]); xlim([-0.5 0.5]); yl = ylim;
% y_mean = linspace(yl(1),yl(end),100); x_mean = Mean*ones(length(y_mean),1);
% line(x_mean,y_mean, 'Color', 'b', 'LineWidth', 2);
% y_std_1 = linspace(yl(1),yl(end),100); x_std_1 = (Mean-Std)*ones(length(y_std_1),1);
% y_std_2 = linspace(yl(1),yl(end),100); x_std_2 = (Mean+Std)*ones(length(y_std_2),1);
% line(x_std_1, y_std_1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
% line(x_std_2, y_std_2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'HandleVisibility','off');
% sMean = sprintf('Mean = %.3f',Mean);
% sStd = sprintf('SD = %.3f',Std);
% set(gca,'FontSize',25); yticklabels(yticks*100); legend(sMean,sStd);
% xlabel('Acceleration [g]','FontSize',25); ylabel('Percentage of time [%]','FontSize',25);
% % limite à 20
% Edges_Agg = [0:1:20 60];
% figure; 
% h = histogram(Va_Pos_Mai,'BinEdges',Edges_Agg,'Normalization', 'probability');
% ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% % % limite à 10 
% Edges_Eco = [2 10:1:60];
% figure;
% h = histogram(Va_Pos_Mai,'BinEdges',Edges_Eco,'Normalization', 'probability');
% ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 
% Edges_CL = [0:1:50 100];
% figure; 
% h = histogram(CL_Mai_Pos,'BinEdges',Edges_CL,'Normalization', 'probability');
% ylim([0 0.06]); xlim([1 55]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 50*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.04*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('Calculated car load [%]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% % a garder - nox- car load-rpm
% figure;
% subplot(3,1,1)
% plot(Time_Mod_Mai,NOx_gkm_05_Mai); 
% set(gca,'FontSize',20); ylabel('NOx [g/km]','FontSize',25); ylim([0 5])
% subplot(3,1,2)
% plot(Time_Mai,CL_Mai_Pos);
% set(gca,'FontSize',20); ylabel('Car load [%]','FontSize',25);
% subplot(3,1,3)
% plot(Time_Mai,RPM_Mai); ylim([0 3000])
% set(gca,'FontSize',20);
% xlabel('Duration [s]','FontSize',25); ylabel('RPM [rot/min]','FontSize',25);
% 
% figure;
% plot(Time_Mod_Mai,NOx_gkm_05_Mai,'LineWidth', 2, 'Color',  [0.7 0.7 0.7]);
% sMean_Mai = sprintf('Mean Audi = %.3f',Mean_NOx_05_Mai);
% ylim([0 3]); hold on;
% plot(Time_Mod_Wltp2_Ordre, NOx_gkm_05_Wltp2_Ordre, 'LineWidth', 2);%, 'Color',  [0.7 0.7 0.7])
% sMean_Scala = sprintf('Mean Skoda = %.3f',Mean_NOx_05_Wltp2_Ordre);
% set(gca,'FontSize',25); legend(sMean_Mai, sMean_Scala)
% xlabel('Duration [s]','FontSize',25); 
% ylabel('NOx [g/km]','FontSize',25);
% %sMean = sprintf('Mean = %.3f',Mean_NOx_05_Papy_Eco); legend(sMean);
% 


%% Calcul de v*a_pos
Va_Pos_wltp2 = Speed_wltp2.*Ay_wltp2_Pos*9.81;
Va_Pos_AgressifV2 = Speed_AgressifV2.*Ay_AgressifV2_Pos*9.81;
Va_Pos_Papy_Eco = Speed_Papy_Eco.*Ay_Papy_Eco_Pos*9.81;
Va_Pos_BadV2 = Speed_BadV2.*Ay_BadV2_Pos*9.81;

%% Calcul de Car Load
CL_wltp2_Pos = carload_fun(Ay_wltp2_Pos, Speed_wltp2, Theta_wltp2, RPM_wltp2);
CL_AgressifV2_Pos = carload_fun(Ay_AgressifV2_Pos, Speed_AgressifV2, Theta_AgressifV2, RPM_AgressifV2);
CL_Papy_Eco_Pos = carload_fun(Ay_Papy_Eco_Pos, Speed_Papy_Eco, Theta_Papy_Eco, RPM_Papy_Eco);
CL_BadV2_Pos = carload_fun(Ay_BadV2_Pos, Speed_BadV2, Theta_BadV2, RPM_BadV2);

%% Calcul des critères pour v*a pos
[N_wltp2,Edges_wltp2] = histcounts(Va_Pos_wltp2,'BinWidth',1,'Normalization', 'probability');
[N_AgressifV2,Edges_AgressifV2] = histcounts(Va_Pos_AgressifV2,'BinWidth',1,'Normalization', 'probability');
[N_Papy_Eco,Edges_Papy_Eco] = histcounts(Va_Pos_Papy_Eco,'BinWidth',1,'Normalization', 'probability');
[N_BadV2,Edges_BadV2] = histcounts(Va_Pos_BadV2,'BinWidth',1,'Normalization', 'probability');

Perc_AboveX_wltp2 = 0;
for i = 1:length(N_wltp2)
    if (Edges_wltp2(i) <= 10) && (Edges_wltp2(i) >= 2) 
        Perc_AboveX_wltp2 = Perc_AboveX_wltp2 + N_wltp2(i);
    end
end
Perc_AboveX_AgressifV2 = 0;
for i = 1:length(N_AgressifV2)
    if (Edges_AgressifV2(i) <= 10) && (Edges_AgressifV2(i) >= 2)  
        Perc_AboveX_AgressifV2 = Perc_AboveX_AgressifV2 + N_AgressifV2(i);
    end
end
Perc_AboveX_Papy_Eco = 0;
for i = 1:length(N_Papy_Eco)
    if (Edges_Papy_Eco(i) <= 10) && (Edges_Papy_Eco(i) >= 2)
        Perc_AboveX_Papy_Eco = Perc_AboveX_Papy_Eco + N_Papy_Eco(i);
    end
end
Perc_AboveX_BadV2 = 0;
for i = 1:length(N_BadV2)
    if (Edges_BadV2(i) <= 10) && (Edges_BadV2(i) >= 2)
        Perc_AboveX_BadV2 = Perc_AboveX_BadV2 + N_BadV2(i);
    end
end

%% Calcul des critères pour car load
[N_wltp2_CL,Edges_wltp2_CL] = histcounts(CL_wltp2_Pos,'BinWidth',1,'Normalization', 'probability');
[N_AgressifV2_CL,Edges_AgressifV2_CL] = histcounts(CL_AgressifV2_Pos,'BinWidth',1,'Normalization', 'probability');
[N_Papy_Eco_CL,Edges_Papy_Eco_CL] = histcounts(CL_Papy_Eco_Pos,'BinWidth',1,'Normalization', 'probability');
[N_BadV2_CL,Edges_BadV2_CL] = histcounts(CL_BadV2_Pos,'BinWidth',1,'Normalization', 'probability');

Perc_CL_wltp2 = 0;
for i = 1:length(N_wltp2_CL)
    if (Edges_wltp2_CL(i) >= 50)
        Perc_CL_wltp2 = Perc_CL_wltp2 + N_wltp2_CL(i);
    end
end
Perc_CL_AgressifV2 = 0;
for i = 1:length(N_AgressifV2_CL)
    if (Edges_AgressifV2_CL(i) >= 50) 
        Perc_CL_AgressifV2 = Perc_CL_AgressifV2 + N_AgressifV2_CL(i);
    end
end
Perc_CL_Papy_Eco = 0;
for i = 1:length(N_Papy_Eco_CL)
    if (Edges_Papy_Eco_CL(i) >= 50)
        Perc_CL_Papy_Eco = Perc_CL_Papy_Eco + N_Papy_Eco_CL(i);
    end
end
Perc_CL_BadV2 = 0;
for i = 1:length(N_BadV2_CL)
    if (Edges_BadV2_CL(i) >= 50)
        Perc_CL_BadV2 = Perc_CL_BadV2 + N_BadV2_CL(i);
    end
end

%% Mean and standard deviations
Mean_wltp2 = mean(Ay_wltp2);
Std_wltp2 = std(Ay_wltp2);
Mean_AgressifV2 = mean(Ay_AgressifV2);
Std_AgressifV2 = std(Ay_AgressifV2);
Mean_Papy_Eco = mean(Ay_Papy_Eco);
Std_Papy_Eco = std(Ay_Papy_Eco);
Mean_BadV2 = mean(Ay_BadV2);
Std_BadV2 = std(Ay_BadV2);
% 
% % %% Histograms of acceleration
% Mean = Mean_wltp2;
% Std = Std_wltp2;
% figure;
% h1 = histogram(Ay_wltp2,'BinWidth',0.01,'Normalization', 'probability','FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')
% ylim([0 0.06]); xlim([-0.5 0.5]); yl = ylim;
% y_mean = linspace(yl(1),yl(end),100); x_mean = Mean*ones(length(y_mean),1);
% line(x_mean,y_mean, 'Color', 'b', 'LineWidth', 2);
% y_std_1 = linspace(yl(1),yl(end),100); x_std_1 = (Mean-Std)*ones(length(y_std_1),1);
% y_std_2 = linspace(yl(1),yl(end),100); x_std_2 = (Mean+Std)*ones(length(y_std_2),1);
% line(x_std_1, y_std_1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
% line(x_std_2, y_std_2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'HandleVisibility','off');
% sMean = sprintf('Mean = %.3f',Mean);
% sStd = sprintf('SD = %.3f',Std);
% set(gca,'FontSize',25); yticklabels(yticks*100); legend(sMean,sStd);
% xlabel('Acceleration [g]','FontSize',25); ylabel('Percentage of time [%]','FontSize',25);
% 
% Mean = Mean_AgressifV2;
% Std = Std_AgressifV2;
% figure; 
% h2 = histogram(Ay_AgressifV2,'BinWidth',0.01,'Normalization', 'probability','FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')
% ylim([0 0.06]); xlim([-0.5 0.5]); yl = ylim;
% y_mean = linspace(yl(1),yl(end),100); x_mean = Mean*ones(length(y_mean),1);
% line(x_mean,y_mean, 'Color', 'b', 'LineWidth', 2);
% y_std_1 = linspace(yl(1),yl(end),100); x_std_1 = (Mean-Std)*ones(length(y_std_1),1);
% y_std_2 = linspace(yl(1),yl(end),100); x_std_2 = (Mean+Std)*ones(length(y_std_2),1);
% line(x_std_1, y_std_1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
% line(x_std_2, y_std_2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'HandleVisibility','off');
% sMean = sprintf('Mean = %.3f',Mean);
% sStd = sprintf('SD = %.3f',Std);
% set(gca,'FontSize',25); yticklabels(yticks*100); legend(sMean,sStd);
% xlabel('Acceleration [g]','FontSize',25); ylabel('Percentage of time [%]','FontSize',25);
% 
% Mean = Mean_Papy_Eco;
% Std = Std_Papy_Eco;
% figure; 
% h3 = histogram(Ay_Papy_Eco,'BinWidth',0.01,'Normalization', 'probability','FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')
% ylim([0 0.06]); xlim([-0.5 0.5]); yl = ylim;
% y_mean = linspace(yl(1),yl(end),100); x_mean = Mean*ones(length(y_mean),1);
% line(x_mean,y_mean, 'Color', 'b', 'LineWidth', 2);
% y_std_1 = linspace(yl(1),yl(end),100); x_std_1 = (Mean-Std)*ones(length(y_std_1),1);
% y_std_2 = linspace(yl(1),yl(end),100); x_std_2 = (Mean+Std)*ones(length(y_std_2),1);
% line(x_std_1, y_std_1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
% line(x_std_2, y_std_2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'HandleVisibility','off');
% sMean = sprintf('Mean = %.3f',Mean);
% sStd = sprintf('SD = %.3f',Std);
% set(gca,'FontSize',25); yticklabels(yticks*100); legend(sMean,sStd);
% xlabel('Acceleration [g]','FontSize',25); ylabel('Percentage of time [%]','FontSize',25);
% 
% Mean = Mean_BadV2;
% Std = Std_BadV2;
% figure; 
% h4 = histogram(Ay_BadV2,'BinWidth',0.01,'Normalization', 'probability','FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')
% ylim([0 0.06]); xlim([-0.5 0.5]); yl = ylim;
% y_mean = linspace(yl(1),yl(end),100); x_mean = Mean*ones(length(y_mean),1);
% line(x_mean,y_mean, 'Color', 'b', 'LineWidth', 2);
% y_std_1 = linspace(yl(1),yl(end),100); x_std_1 = (Mean-Std)*ones(length(y_std_1),1);
% y_std_2 = linspace(yl(1),yl(end),100); x_std_2 = (Mean+Std)*ones(length(y_std_2),1);
% line(x_std_1, y_std_1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
% line(x_std_2, y_std_2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'HandleVisibility','off');
% sMean = sprintf('Mean = %.3f',Mean);
% sStd = sprintf('SD = %.3f',Std);
% set(gca,'FontSize',25); yticklabels(yticks*100); legend(sMean,sStd);
% xlabel('Acceleration [g]','FontSize',25); ylabel('Percentage of time [%]','FontSize',25);
% 
% 
% fig = figure; 
% subplot(2,2,1)
% h = histogram(Ay_wltp2,'BinWidth',0.01,'Normalization', 'probability');
% % [-0.4300 0.3500]
% ylim([0 0.06]); xlim([-0.5 0.5]); 
% yticklabels(yticks*100); title('Reference','FontSize',15)
% subplot(2,2,2)
% h = histogram(Ay_AgressifV2,'BinWidth',0.01,'Normalization', 'probability');
% % [-0.5000 0.4700]
% ylim([0 0.06]); xlim([-0.5 0.5]);
% yticklabels(yticks*100); title('Aggressive','FontSize',15)
% subplot(2,2,3)
% h = histogram(Ay_Papy_Eco,'BinWidth',0.01,'Normalization', 'probability');
% % [-0.3600 0.3400]
% ylim([0 0.06]); xlim([-0.5 0.5]);
% yticklabels(yticks*100); title('Economic','FontSize',15)
% subplot(2,2,4)
% h = histogram(Ay_BadV2,'BinWidth',0.01,'Normalization', 'probability');
% % [-0.4300 0.3200]
% ylim([0 0.06]);xlim([-0.5 0.5]);
% yticklabels(yticks*100); title('Low Engine Speed','FontSize',15)
% 
% han=axes(fig,'visible','off'); % to put one same label for the 3 subplots
% han.XLabel.Visible='on'; han.YLabel.Visible='on';
% set(gca,'FontSize',15);
% xlabel('Acceleration [g]','FontSize',15); ylabel('Percentage of time [%]','FontSize',15);

%% Histograms of v*a pos
% % limite à 20
% Edges_Agg = [0:1:20 60];
% figure; 
% h = histogram(Va_Pos_wltp2,'BinEdges',Edges_Agg,'Normalization', 'probability');
% ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% figure; 
% h = histogram(Va_Pos_AgressifV2,'BinEdges',Edges_Agg,'Normalization', 'probability');
% ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% figure;
% h = histogram(Va_Pos_Papy_Eco,'BinEdges',Edges_Agg,'Normalization', 'probability');
% ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% figure;
% h = histogram(Va_Pos_BadV2,'BinEdges',Edges_Agg,'Normalization', 'probability');
% ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 
% % % limite à 10 
% Edges_Eco = [2 10:1:60];
% figure;
% h = histogram(Va_Pos_wltp2,'BinEdges',Edges_Eco,'Normalization', 'probability');
% ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% figure;
% h = histogram(Va_Pos_AgressifV2,'BinEdges',Edges_Eco,'Normalization', 'probability');
% ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% figure;
% h = histogram(Va_Pos_Papy_Eco,'BinEdges',Edges_Eco,'Normalization', 'probability');
% ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15);  
% ylabel('Percentage of time [%]','FontSize',15);
% figure;
% h = histogram(Va_Pos_BadV2,'BinEdges',Edges_Eco,'Normalization', 'probability');
% ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 
% 
% 
% fig = figure; 
% subplot(2,2,1)
% h = histogram(Va_Pos_wltp2,'BinWidth',1,'Normalization', 'probability');
% % [-0.4300 0.3500]
% ylim([0 0.04]); xlim([0 55]);
% yticklabels(yticks*100); title('Reference','FontSize',15)
% subplot(2,2,2)
% h = histogram(Va_Pos_AgressifV2,'BinWidth',1,'Normalization', 'probability');
% % [-0.5000 0.4700]
% ylim([0 0.04]); xlim([0 55]);
% yticklabels(yticks*100); title('Aggressive','FontSize',15)
% subplot(2,2,3)
% h = histogram(Va_Pos_Papy_Eco,'BinWidth',1,'Normalization', 'probability');
% % [-0.3600 0.3400]
% ylim([0 0.04]); xlim([0 55]);
% yticklabels(yticks*100); title('Economic','FontSize',15)
% subplot(2,2,4)
% h = histogram(Va_Pos_BadV2,'BinWidth',1,'Normalization', 'probability');
% % [-0.4300 0.3200]
% ylim([0 0.04]); xlim([0 55]);
% yticklabels(yticks*100); title('Low Engine Speed','FontSize',15)
% 
% han=axes(fig,'visible','off'); % to put one same label for the 3 subplots
% han.XLabel.Visible='on'; han.YLabel.Visible='on';
% set(gca,'FontSize',15);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 

%% Histograms of Car Load
% Edges_CL = [0:1:50 100];
% figure; 
% h = histogram(CL_wltp2_Pos,'BinEdges',Edges_CL,'Normalization', 'probability');
% ylim([0 0.06]); xlim([1 55]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 50*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.04*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('Calculated car load [%]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 
% figure; 
% h = histogram(CL_AgressifV2_Pos,'BinEdges',Edges_CL,'Normalization', 'probability');
% ylim([0 0.06]); xlim([1 55]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 50*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.04*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('Calculated car load [%]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 
% figure; 
% h = histogram(CL_Papy_Eco_Pos,'BinEdges',Edges_CL,'Normalization', 'probability');
% ylim([0 0.06]); xlim([1 55]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 50*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.04*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('Calculated car load [%]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 
% figure; 
% h = histogram(CL_BadV2_Pos,'BinEdges',Edges_CL,'Normalization', 'probability');
% ylim([0 0.06]); xlim([1 55]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 50*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.04*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('Calculated car load [%]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);
% 
% 
% 
% fig = figure; 
% subplot(2,2,1)
% h = histogram(CL_wltp2_Pos,'BinWidth',1,'Normalization', 'probability');
% % [-0.4300 0.3500]
% ylim([0 0.04]);% xlim([0.1 6]);
% yticklabels(yticks*100); title('Reference','FontSize',15)
% subplot(2,2,2)
% h = histogram(CL_AgressifV2_Pos,'BinWidth',1,'Normalization', 'probability');
% % [-0.5000 0.4700]
% ylim([0 0.04]); %xlim([0.1 6]);
% yticklabels(yticks*100); title('Aggressive','FontSize',15)
% subplot(2,2,3)
% h = histogram(CL_Papy_Eco_Pos,'BinWidth',1,'Normalization', 'probability');
% % [-0.3600 0.3400]
% ylim([0 0.04]); %xlim([0.1 6]);
% yticklabels(yticks*100); title('Economic','FontSize',15)
% subplot(2,2,4)
% h = histogram(CL_BadV2_Pos,'BinWidth',1,'Normalization', 'probability');
% % [-0.4300 0.3200]
% ylim([0 0.04]); %xlim([0.1 6]);
% yticklabels(yticks*100); title('Low Engine Speed','FontSize',15)
% 
% han=axes(fig,'visible','off'); % to put one same label for the 3 subplots
% han.XLabel.Visible='on'; han.YLabel.Visible='on';
% set(gca,'FontSize',15);
% xlabel('Calculated car load [%]','FontSize',15);
% ylabel('Percentage of time [%]','FontSize',15);
% 

%% Plot de NOx
% figure;
% plot(Time_Mod_Papy_Eco,NOx_gkm_05_Papy_Eco,'LineWidth', 2); ylim([0 1])
% set(gca,'FontSize',20);
% xlabel('Duration [s]','FontSize',20); 
% ylabel('NOx [g/km]','FontSize',20);
% %sMean = sprintf('Mean = %.3f',Mean_NOx_05_Papy_Eco); legend(sMean);

% NOx - va pos - rpm - agressif
% figure; 
% subplot(3,1,1)
% plot(Time_Mod_AgressifV2,NOx_gkm_05_AgressifV2); ylim([0 3])
% set(gca,'FontSize',20);
% %xlabel('Duration [s]','FontSize',20); 
% ylabel('NOx [g/km]','FontSize',25);
% subplot(3,1,2)
% plot(Time_AgressifV2,Va_Pos_AgressifV2); ylim([0 100]);
% set(gca,'FontSize',20);
% %xlabel('Duration [s]','FontSize',20); 
% ylabel('v a_{pos} [m^2/s^3]','FontSize',25);
% subplot(3,1,3)
% plot(Time_AgressifV2,RPM_AgressifV2); ylim([0 4500])
% set(gca,'FontSize',20);
% xlabel('Duration [s]','FontSize',25); 
% ylabel('RPM','FontSize',25);


% NOx - va Pos
% figure; 
% subplot(2,1,1)
% plot(Time_Mod_Wltp2_Ordre,NOx_gkm_05_Wltp2_Ordre); 
% subplot(2,1,2)
% plot(Time_wltp2,Va_Pos_wltp2);
% figure; 
% subplot(2,1,1)
% plot(Time_Mod_AgressifV2,NOx_gkm_05_AgressifV2); 
% subplot(2,1,2)
% plot(Time_AgressifV2,Va_Pos_AgressifV2);
% figure;
% subplot(2,1,1)
% plot(Time_Mod_Papy_Eco,NOx_gkm_05_Papy_Eco); 
% subplot(2,1,2)
% plot(Time_Papy_Eco,Va_Pos_Papy_Eco); 
% figure;
% subplot(2,1,1)
% plot(Time_Mod_BadV2,NOx_gkm_05_BadV2); 
% subplot(2,1,2)
% plot(Time_BadV2,Va_Pos_BadV2);

% NOx - car load
% A garder NOx - Car load pour wltp2
% figure; 
% subplot(2,1,1)
% plot(Time_Mod_Wltp2_Ordre,NOx_gkm_05_Wltp2_Ordre); ylim([0 1]);
% set(gca,'FontSize',20);
% %xlabel('Duration [s]','FontSize',25);
% ylabel('NOx [g/km]','FontSize',25);
% subplot(2,1,2)
% plot(Time_wltp2,CL_wltp2_Pos); 
% set(gca,'FontSize',20);
% xlabel('Duration [s]','FontSize',25); 
% ylabel('Car load [%]','FontSize',25);

% % a garder - nox- car load-rpm - wltpV3
% figure;
% subplot(3,1,1)
% plot(Time_Mod_Wltp2_Ordre,NOx_gkm_05_Wltp2_Ordre); 
% set(gca,'FontSize',20); ylabel('NOx [g/km]','FontSize',25);
% subplot(3,1,2)
% plot(Time_wltp2,CL_wltp2_Pos);
% set(gca,'FontSize',20); ylabel('Car load [%]','FontSize',25);
% subplot(3,1,3)
% plot(Time_wltp2,RPM_wltp2); ylim([0 3000])
% set(gca,'FontSize',20);
% xlabel('Duration [s]','FontSize',25); ylabel('RPM [rot/min]','FontSize',25);

% % a garder
% figure;
% subplot(3,1,1)
% plot(Time_Mod_Papy_Eco,NOx_gkm_05_Papy_Eco); 
% set(gca,'FontSize',20); ylabel('NOx [g/km]','FontSize',25);
% subplot(3,1,2)
% plot(Time_Papy_Eco,CL_Papy_Eco_Pos)
% set(gca,'FontSize',20); ylabel('Car load [%]','FontSize',25);
% subplot(3,1,3)
% plot(Time_Papy_Eco,RPM_Papy_Eco); ylim([0 3000]);
% set(gca,'FontSize',20);
% xlabel('Duration [s]','FontSize',25); ylabel('RPM [rot/min]','FontSize',25);
% 
% % a garder zoom 1200-1600 nox-CL-BadV2 
% figure;
% subplot(3,1,1)
% plot(Time_Mod_BadV2,NOx_gkm_05_BadV2); ylim([0 0.5]); xlim([1200 1600])
% set(gca,'FontSize',20);
% %xlabel('Duration [s]','FontSize',25);
% ylabel('NOx [g/km]','FontSize',25);
% subplot(3,1,2)
% plot(Time_BadV2,CL_BadV2_Pos); xlim([1200 1600])
% set(gca,'FontSize',20);
% %xlabel('Duration [s]','FontSize',25); 
% ylabel('Car load [%]','FontSize',25);
% subplot(3,1,3)
% plot(Time_BadV2,RPM_BadV2); ylim([0 3000]); xlim([1200 1600])
% set(gca,'FontSize',20);
% xlabel('Duration [s]','FontSize',25); ylabel('RPM [rot/min]','FontSize',25);

%% Gros subplots NOx g/km et NOx ppm
fig = figure; 
subplot(4,1,1)
plot(Time_Mod_Wltp2_Ordre,NOx_gkm_05_Wltp2_Ordre,'LineWidth', 2); ylim([0 1]);
sMean = sprintf('Mean = %.3f',Mean_NOx_05_Wltp2_Ordre);
set(gca,'FontSize',20, 'XTick', []); legend(sMean);
subplot(4,1,2)
plot(Time_Mod_AgressifV2,NOx_gkm_05_AgressifV2,'LineWidth', 2); 
sMean = sprintf('Mean = %.3f',Mean_NOx_05_AgressifV2); ylim([0 1]);
set(gca,'FontSize',20, 'XTick', []); legend(sMean);
subplot(4,1,3)
plot(Time_Mod_Papy_Eco,NOx_gkm_05_Papy_Eco,'LineWidth', 2); 
sMean = sprintf('Mean = %.3f',Mean_NOx_05_Papy_Eco); ylim([0 1]);
set(gca,'FontSize',20, 'XTick', []); legend(sMean);
subplot(4,1,4)
plot(Time_Mod_BadV2,NOx_gkm_05_BadV2,'LineWidth', 2); 
sMean = sprintf('Mean = %.3f',Mean_NOx_05_BadV2); ylim([0 1]);
set(gca,'FontSize',20); legend(sMean);

han=axes(fig,'visible','off'); % to put one same label for the 4 subplots
han.XLabel.Visible='on'; han.YLabel.Visible='on';
set(gca,'FontSize',25);
xlabel('Duration [s]','FontSize',25); 
ylabel('NOx [g/km]','FontSize',25);




fig = figure; 
subplot(4,1,1)
plot(Time_Mod_Wltp2_Ordre,NOx_gkm_05_Wltp2_Ordre,'LineWidth', 2); ylim([0 1]);
ylim([0 1]);
set(gca,'FontSize',20, 'XTick', []); legend('Ordinary');
subplot(4,1,2)
plot(Time_Mod_AgressifV2,NOx_gkm_05_AgressifV2,'LineWidth', 2); 
ylim([0 1]);
set(gca,'FontSize',20, 'XTick', []); legend('Aggressive');
subplot(4,1,3)
plot(Time_Mod_Papy_Eco,NOx_gkm_05_Papy_Eco,'LineWidth', 2); 
ylim([0 1]);
set(gca,'FontSize',20, 'XTick', []); legend('Economic');
subplot(4,1,4)
plot(Time_Mod_BadV2,NOx_gkm_05_BadV2,'LineWidth', 2); 
ylim([0 1]);
set(gca,'FontSize',20); legend('Low Engine Speed');

han=axes(fig,'visible','off'); % to put one same label for the 4 subplots
han.XLabel.Visible='on'; han.YLabel.Visible='on';
set(gca,'FontSize',25);
xlabel('Duration [s]','FontSize',25); 
ylabel('NOx [g/km]','FontSize',25);


% fig = figure; 
% subplot(4,1,1)
% plot(Time_Mod_Wltp2_Ordre,Ppm_wltp2,'LineWidth', 2); ylim([0 400]);
% set(gca,'FontSize',20, 'XTick', []); legend('Ordinary');
% subplot(4,1,2)
% plot(Time_Mod_AgressifV2,Ppm_AgressifV2,'LineWidth', 2); ylim([0 400]);
% set(gca,'FontSize',20, 'XTick', []); legend('Aggressive');
% subplot(4,1,3)
% plot(Time_Mod_Papy_Eco,Ppm_Papy_Eco,'LineWidth', 2); ylim([0 400]);
% set(gca,'FontSize',20, 'XTick', []); legend('Economic');
% subplot(4,1,4)
% plot(Time_Mod_BadV2,Ppm_BadV2,'LineWidth', 2); ylim([0 400]);
% set(gca,'FontSize',20); legend('Low Engine Speed');
% 
% han=axes(fig,'visible','off'); % to put one same label for the 4 subplots
% han.XLabel.Visible='on'; han.YLabel.Visible='on';
% set(gca,'FontSize',25);
% xlabel('Duration [s]','FontSize',25); 
% ylabel('NOx [Ppm_v]','FontSize',25);



% figure;
% plot(Time_Mod_Papy_Eco,NOx_gkm_05_Papy_Eco,'LineWidth', 2);
% 
% figure; 
% subplot(1,4,1)
% h =histogram(Ay_wltp2,'BinWidth',0.02,'Normalization', 'probability')
% ylim([0 0.08]);
% ylabel('Wltp 2')
% subplot(1,4,2)
% h = histogram(Ay_Agressif_V2,'BinWidth',0.02,'Normalization', 'probability')
% ylim([0 0.08]);
% ylabel('Agressif V2')
% subplot(1,4,3)
% h = histogram(Ay_Papy_Eco,'BinWidth',0.02,'Normalization', 'probability')
% ylim([0 0.08]);
% ylabel('Papy Eco')
% subplot(1,4,4)
% h = histogram(Ay_BadV2,'BinWidth',0.02,'Normalization', 'probability')
% ylim([0 0.08]);
% ylabel('Bad Driver V2')





%% Histogram slides 
Mean = Mean_wltp2;
Std = Std_wltp2;
figure;
h1 = histogram(Ay_wltp2,'BinWidth',0.01,'Normalization', 'probability','FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')
ylim([0 0.06]); xlim([-0.5 0.5]); yl = ylim;
y_mean = linspace(yl(1),yl(end),100); x_mean = Mean*ones(length(y_mean),1);
line(x_mean,y_mean, 'Color', 'b', 'LineWidth', 2);
y_std_1 = linspace(yl(1),yl(end),100); x_std_1 = (Mean-Std)*ones(length(y_std_1),1);
y_std_2 = linspace(yl(1),yl(end),100); x_std_2 = (Mean+Std)*ones(length(y_std_2),1);
line(x_std_1, y_std_1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
line(x_std_2, y_std_2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'HandleVisibility','off');
sMean = sprintf('Mean = %.3f',Mean);
sStd = sprintf('SD = %.3f',Std);
set(gca,'FontSize',25); yticklabels(yticks*100); legend(sMean,sStd);
xlabel('Acceleration [g]','FontSize',25); ylabel('Percentage of time [%]','FontSize',25);

Mean = Mean_Papy_Eco;
Std = Std_Papy_Eco;
figure; 
h3 = histogram(Ay_Papy_Eco,'BinWidth',0.01,'Normalization', 'probability','FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')
ylim([0 0.06]); xlim([-0.5 0.5]); yl = ylim;
y_mean = linspace(yl(1),yl(end),100); x_mean = Mean*ones(length(y_mean),1);
line(x_mean,y_mean, 'Color', 'b', 'LineWidth', 2);
y_std_1 = linspace(yl(1),yl(end),100); x_std_1 = (Mean-Std)*ones(length(y_std_1),1);
y_std_2 = linspace(yl(1),yl(end),100); x_std_2 = (Mean+Std)*ones(length(y_std_2),1);
line(x_std_1, y_std_1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
line(x_std_2, y_std_2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--', 'HandleVisibility','off');
sMean = sprintf('Mean = %.3f',Mean);
sStd = sprintf('SD = %.3f',Std);
set(gca,'FontSize',25); yticklabels(yticks*100); legend(sMean,sStd);
xlabel('Acceleration [g]','FontSize',25); ylabel('Percentage of time [%]','FontSize',25);

figure; 
histogram(Ay_wltp2,'BinWidth',0.01,'Normalization', 'probability');% ,'FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off');
hold on; ylim([0 0.06]); xlim([-0.4 0.4]); set(gca,'FontSize',25);
histogram(Ay_Papy_Eco,'BinWidth',0.01,'Normalization', 'probability');% ,'FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')


figure; 
histogram(Ay_wltp2,'BinWidth',0.01,'Normalization', 'probability');% ,'FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off');
hold on; ylim([0 0.06]); xlim([-0.4 0.4]); set(gca,'FontSize',20, 'XTick',[],'YTick',[]);
histogram(Ay_Papy_Eco,'BinWidth',0.01,'Normalization', 'probability');% ,'FaceColor', [0.7 0.7 0.7], 'HandleVisibility','off')


%% va pos slides limite à 20
Edges_Agg = [0:1:20 60];
figure; 
h = histogram(Va_Pos_wltp2,'BinEdges',Edges_Agg,'Normalization', 'probability');
ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
ylabel('Percentage of time [%]','FontSize',15);
figure; 
h = histogram(Va_Pos_AgressifV2,'BinEdges',Edges_Agg,'Normalization', 'probability');
ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
ylabel('Percentage of time [%]','FontSize',15);

figure; 
histogram(Va_Pos_wltp2,'BinEdges',Edges_Agg,'Normalization', 'probability'); hold on; 
histogram(Va_Pos_AgressifV2,'BinEdges',Edges_Agg,'Normalization', 'probability');
ylim([0 0.15]); xlim([1 21]);

figure; 
subplot(1,2,1);
histogram(Va_Pos_wltp2,'BinEdges',Edges_Agg,'Normalization', 'probability');
ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
ylabel('Percentage of time [%]','FontSize',15);
subplot(1,2,2);
histogram(Va_Pos_AgressifV2,'BinEdges',Edges_Agg,'Normalization', 'probability');
ylim([0 0.15]); xlim([1 21]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 20*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.1*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
ylabel('Percentage of time [%]','FontSize',15);



%% va pos slides limite à 10 
Edges_Eco = [2 10:1:60];
figure;
h = histogram(Va_Pos_wltp2,'BinEdges',Edges_Eco,'Normalization', 'probability');
ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
ylabel('Percentage of time [%]','FontSize',15);

figure;
h = histogram(Va_Pos_Papy_Eco,'BinEdges',Edges_Eco,'Normalization', 'probability');
ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('v a_{pos} [m^2/s^3]','FontSize',15);  
ylabel('Percentage of time [%]','FontSize',15);
% figure;
% h = histogram(Va_Pos_BadV2,'BinEdges',Edges_Eco,'Normalization', 'probability');
% ylim([0 0.30]); xlim([9 20]); yl = ylim; xl = xlim;
% y_vert = linspace(yl(1),yl(end),100); x_vert = 10*ones(length(y_vert),1);
% x_hor = linspace(xl(1),xl(end),100); y_hor = 0.20*ones(length(x_hor),1);
% line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
% line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
% set(gca,'FontSize',15); yticklabels(yticks*100);
% xlabel('v a_{pos} [m^2/s^3]','FontSize',15); 
% ylabel('Percentage of time [%]','FontSize',15);

%% Car load Slide 

Edges_CL = [0:1:50 100];
figure; 
h = histogram(CL_wltp2_Pos,'BinEdges',Edges_CL,'Normalization', 'probability');
ylim([0 0.06]); xlim([1 100]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 50*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.04*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('Calculated car load [%]','FontSize',15); 
ylabel('Percentage of time [%]','FontSize',15);

figure; 
h = histogram(CL_BadV2_Pos,'BinEdges',Edges_CL,'Normalization', 'probability');
ylim([0 0.06]); xlim([1 100]); yl = ylim; xl = xlim;
y_vert = linspace(yl(1),yl(end),100); x_vert = 50*ones(length(y_vert),1);
x_hor = linspace(xl(1),xl(end),100); y_hor = 0.04*ones(length(x_hor),1);
line(x_vert,y_vert, 'Color', 'r','LineStyle','--', 'LineWidth', 2);
line(x_hor,y_hor, 'Color', 'r','LineStyle','--','LineWidth', 2);
set(gca,'FontSize',15); yticklabels(yticks*100);
xlabel('Calculated car load [%]','FontSize',15); 
ylabel('Percentage of time [%]','FontSize',15);

