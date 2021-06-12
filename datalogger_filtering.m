close all;
clear;
% Script that will read and compare the different filters applied to raw
% data coming from the datalogger
%% Where we choose the excel file to read
Raw_Datalog = readtable('Datalogger-10-04-Overijse.xlsx');
% Raw_Datalog = readtable('Scala-Lln-Wolu.xlsx');
%Raw_Datalog = readtable('Datalogger-18-05-21.xlsx');
%Raw_Datalog = readtable('WLTP2-Datalogger-BonOrdre.xlsx');

filtering = false; % if true, plot all the graphs for the filtering
angle = true; 

%% Initialisation
Ay = Raw_Datalog{1:end,11};
%Ay = Ay(1:1000);
Az = Raw_Datalog{1:end,12};
%Az = Az(1:1000);
Time_Datalogger = transpose(0.1:0.1:length(Ay)/10);
Alt = Raw_Datalog{1:end,4}.*10^(-2); % because in [cm] in datalogger
%Alt = Alt(1:1000);
Speed = Raw_Datalog{1:end,6}./3.6; % to be in [m/s]
for i = 1:length(Speed) % car une valeur de speed est à -0.2778 wtf
   if Speed(i) < 0 
       Speed(i) = 0;
   end
end
%Speed = Speed(1:1000);
%Ay_wo = filloutliers(Ay,'linear');
Ay_wo = filloutliers(Ay,'linear','quartiles');
%Az_wo = filloutliers(Az,'linear');%,'quartiles');
Az_wo = filloutliers(Az,'linear','quartiles');
Tol = 0.05;
Theta_Init = zeros(length(Alt),1);
order = 3;
framelen = 7;

%% Computations and plots
if filtering
    
    %% Raw Data
    figure;
    scatter(Time_Datalogger, Ay, 'filled'); hold on; % box on;
    scatter(Time_Datalogger, Az, 'filled');
    xlabel('Duration [s]','FontSize',20);%'Interpreter','latex');
    ylabel('Acceleration [g]','FontSize',20);
    set(gca,'FontSize',20); legend('Acceleration-y','Acceleration-z');
    Az_log = log10(Az);
    
    figure; 
    %c = [0.9 0.3 0];
    scatter(Time_Datalogger(1000:2000), Az_log(1000:2000),[],[0.9 0.3 0],'filled');
    
    %% Raw Data without outliers
    [ Range_Ay_wo ] = operating_range( Ay_wo, Tol );
    [ Range_Az_wo ] = operating_range( Az_wo, Tol );
    figure;
    plot(Time_Datalogger, Ay_wo); hold on; %
    plot(Time_Datalogger, Az_wo)
    %xlabel('Duration [s]','FontSize',20); ylabel('Acceleration [g]','FontSize',20);
    set(gca,'FontSize',30); %legend('Ay', 'Az')
    
    % % Boxplot of raw data and raw data without outliers
%     figure;
%     boxplot([Ay_wo, Az_wo], 'Labels',{'Ay','Az'}); %
%     box off; set(gca,'FontSize',20); ylabel('Acceleration [g]','FontSize',20);
    
    Ay_wo_mean = mean(Ay_wo); % 0.6482
    Az_wo_mean = mean(Az_wo); % 0.7822
    
    %% Data filtering : Median filter
    Ay_med_fil = medfilt1(Ay_wo,5); % window of length 3 by default
    Ay_med_fil_11 = medfilt1(Ay_wo,15); % window of length eleven
    
    fig = figure;
    subplot(2,1,1); plot(Time_Datalogger, Ay_wo, 'Color', [0.7 0.7 0.7]); hold on;
    set(gca,'FontSize',20); %legend('Data','Location','Best')
    plot(Time_Datalogger, Ay_med_fil, 'red')
    set(gca,'FontSize',20); legend('Data','n = 5','Location','Best')
    subplot(2,1,2); plot(Time_Datalogger, Ay_wo, 'Color', [0.7 0.7 0.7]); hold on;
    set(gca,'FontSize',20); %legend('Data','Location','Best')
    plot(Time_Datalogger, Ay_med_fil_11,'red') %'Color', [0 0.7 0])
    set(gca,'FontSize',20); legend('Data','n = 15','Location','Best')

    han=axes(fig,'visible','off'); % to put one same label for the 3 subplots
    %han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    set(gca,'FontSize',20);
    ylabel(han,'Acceleration [g]','FontSize',20);
    xlabel(han,'Duration [s]','FontSize',20);
    %title(han,'yourTitle');
    
    % Test tout sur le même graphe
    figure;
    plot(Time_Datalogger, Ay_wo, 'Color', [0.7 0.7 0.7]); hold on;
    plot(Time_Datalogger, Ay_med_fil, 'red');
    plot(Time_Datalogger, Ay_med_fil_11,'Color', [0 0.7 0]);
    set(gca,'FontSize',25); legend('Data','n = 3','n=11');
    
    %% Data filtering : Moving average filter
    Ay_mov_av = zeros(length(Ay_wo),2);
    window_Size_5 = 5;
    a = 1;
    b_5 = (1/window_Size_5)*ones(1,window_Size_5);
    Ay_mov_av(:,1) = filter(b_5,a,Ay_wo);
    window_Size_10 = 10;
    b_10 = (1/window_Size_10)*ones(1,window_Size_10);
    Ay_mov_av(:,2) = filter(b_10,a,Ay_wo);
    
    figure;
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7] ); hold on; 
    plot(Time_Datalogger, Ay_mov_av(:,1), 'red'); hold on;
    plot(Time_Datalogger, Ay_mov_av(:,2), 'Color', [0 0.7 0]); xlim([5 30])
    xlabel('Duration [s]','FontSize',20); ylabel('Acceleration [g]','FontSize',20);
    set(gca,'FontSize',20); legend('Data', 'n = 5', 'n = 10')
    
    %% Data filtering : Savitzky-Golay filter
    order_3 = 3; order_4 = 4;
    framelen_11 = 11;
    framelen_5 = 5;
    framelen_7 = 7;
    framelen_9 = 9;
    
    Ay_sgf_3_7 = sgolayfilt(Ay_wo,order_3,framelen_7);
    Az_sgf_3_7 = sgolayfilt(Az_wo,order_3,framelen_7);
    Ay_sgf_3_5 = sgolayfilt(Ay_wo,order_3,framelen_5);
    Ay_sgf_3_9 = sgolayfilt(Ay_wo,order_3,framelen_9);
    Ay_sgf_4_7 = sgolayfilt(Ay_wo,order_4,framelen_7);
    Ay_sgf_4_5 = sgolayfilt(Ay_wo,order_4,framelen_5);
    
    fig = figure; 
    subplot(2,1,1)
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7],'LineWidth',2); hold on;
    plot(Time_Datalogger, Ay_sgf_3_7,'red','LineWidth',2); hold on;
    plot(Time_Datalogger, Ay_sgf_4_7,'Color', [0 0.7 0],'LineWidth',2); xlim([30 40])
    set(gca,'FontSize',20); legend('Data', 'order = 3, frame length = 7', 'order = 4, frame length = 7' )
    subplot(2,1,2)
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7],'LineWidth',2); hold on;
    plot(Time_Datalogger, Ay_sgf_3_5,'red','LineWidth',2); hold on;
    plot(Time_Datalogger, Ay_sgf_3_9,'Color', [0 0.7 0],'LineWidth',2); xlim([30 40])
    set(gca,'FontSize',20); legend('Data', 'order = 3, frame length = 5', 'order = 3, frame length = 9' )
    
    han=axes(fig,'visible','off'); % to put one same label for the 2 subplots
    %han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    set(gca,'FontSize',20);
    ylabel(han,'Acceleration [g]','FontSize',20);
    xlabel(han,'Duration [s]','FontSize',20);
    %title(han,'yourTitle');
    
    fig = figure; 
    subplot(2,1,1)
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7]); hold on;
    plot(Time_Datalogger, Ay_sgf_3_7,'red'); hold on;
    plot(Time_Datalogger, Ay_sgf_4_7,'Color', [0 0.7 0]); %xlim([30 40])
    set(gca,'FontSize',20); legend('Data', 'order = 3, frame length = 7', 'order = 4, frame length = 7' )
    subplot(2,1,2)
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7]); hold on;
    plot(Time_Datalogger, Ay_sgf_3_5,'red'); hold on;
    plot(Time_Datalogger, Ay_sgf_3_9,'Color', [0 0.7 0]); %xlim([30 40])
    set(gca,'FontSize',20); legend('Data', 'order = 3, frame length = 5', 'order = 3, frame length = 9' )
    
    han=axes(fig,'visible','off'); % to put one same label for the 2 subplots
    %han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    set(gca,'FontSize',20);
    ylabel(han,'Acceleration [g]','FontSize',20);
    xlabel(han,'Duration [s]','FontSize',20);
    %title(han,'yourTitle');
    %% Comparison
    fig = figure;
    subplot(4,1,1); plot(Time_Datalogger, Ay_wo); xlim([10, 100])
    set(gca,'FontSize',20); legend('Data','Location','Best')
    subplot(4,1,2); plot(Time_Datalogger, Ay_med_fil, 'red'); xlim([10, 100])
    set(gca,'FontSize',20); legend('Median Filtering','Location','Best')
    subplot(4,1,3); plot(Time_Datalogger, Ay_mov_av(:,2), 'Color', '[0 0.7 0]'); xlim([10, 100])
    set(gca,'FontSize',20); legend('Moving Average Filtering','Location','Best')
    subplot(4,1,4); plot(Time_Datalogger, Ay_sgf_3_7, 'Color', 'k'); xlim([10, 100])
    set(gca,'FontSize',20); legend('Savitzky-Golay Filtering','Location','Best')
    
    han=axes(fig,'visible','off'); % to put one same label for the 3 subplots
    %han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    set(gca,'FontSize',20);
    ylabel(han,'Acceleration [g]','FontSize',20);
    xlabel(han,'Duration [s]','FontSize',20);
    %title(han,'yourTitle');
    
    fig = figure;
    subplot(3,1,1);  
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7],'LineWidth',2); xlim([10, 100]); hold on;
    plot(Time_Datalogger, Ay_sgf_3_7, 'Color', 'red','LineWidth',2); 
    set(gca,'FontSize',20); legend('Data','Savitzky-Golay Filtering','Location','Best') 
    subplot(3,1,2);  
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7],'LineWidth',2); xlim([10, 100]); hold on;
    plot(Time_Datalogger, Ay_med_fil, 'Color', 'red','LineWidth',2); 
    set(gca,'FontSize',20); legend('Data','Median Filtering','Location','Best')
    subplot(3,1,3);  
    plot(Time_Datalogger, Ay_wo,'Color', [0.7 0.7 0.7],'LineWidth',2); xlim([10, 100]); hold on;
    plot(Time_Datalogger, Ay_mov_av(:,2), 'Color', 'red','LineWidth',2); 
    set(gca,'FontSize',20); legend('Data','Moving Average Filtering','Location','Best')
    
    han=axes(fig,'visible','off'); % to put one same label for the 3 subplots
    %han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    set(gca,'FontSize',20);
    ylabel(han,'Acceleration [g]','FontSize',20);
    xlabel(han,'Duration [s]','FontSize',20);
    %title(han,'yourTitle');
    
    figure;
    plot(Time_Datalogger, Ay_sgf_3_7);  hold on;
    plot(Time_Datalogger, Az_sgf_3_7)
    xlabel('Duration [s]','FontSize',20); ylabel('Acceleration [g]','FontSize',20);
    set(gca,'FontSize',20); legend('Ay filtered', 'Az filtered')
    
elseif (filtering || angle) 
    %% Modification of principal code
    figure;
    plot(Time_Datalogger,Speed.*3.6,'LineWidth',1.5); %xlim([0 1200]); % to be in [km/h] 
    xlabel('Duration [s]','FontSize',20); ylabel('Speed [km/h]','FontSize',20);
    set(gca,'FontSize',20);
    
    figure;
    subplot(2,1,1);
    plot(Time_Datalogger, Alt); 
    xlabel('Duration [s]','FontSize',20); ylabel('Altitude [m]','FontSize',20);
    set(gca,'FontSize',20);
    subplot(2,1,2);
    plot(Time_Datalogger,Speed.*3.6); ylim([-20, 130]); % to be in [km/h] 
    xlabel('Duration [s]','FontSize',20); ylabel('Speed [km/h]','FontSize',20);
    set(gca,'FontSize',20);
    
    Ay_OBD_grad = gradient(Speed,0.1); 
    Ay_OBD_grad_sgf = sgolayfilt(Ay_OBD_grad,order,framelen);
    
    % beau graphe pour dérivée de la vitesse
    y_up = 0.1416*ones(length(Time_Datalogger),1);
    y_down = -0.1416*ones(length(Time_Datalogger),1);
    fig = figure; 
    subplot(2,1,1);
    plot(Time_Datalogger, Ay_OBD_grad./9.81);  ylim([-0.5, 0.5]); xlim([0 1000]); hold on;
    set(gca,'FontSize',18); 
    line(Time_Datalogger,y_up,'Color','red','LineStyle','--','LineWidth',2);%,'HandleVisibility','off'); 
    line(Time_Datalogger,y_down,'Color','red','LineStyle','--','LineWidth',2,'HandleVisibility','off');
    legend('Ay-OBD Not-filtered','Upper and down limit: 0.14');%,'', 'off','','off');
    subplot(2,1,2);
    plot(Time_Datalogger, Ay_OBD_grad_sgf./9.81);  ylim([-0.5, 0.5]); xlim([0 1000]);
    set(gca,'FontSize',18); legend('Ay-OBD Filtered')
    han=axes(fig,'visible','off'); % to put one same label for the 3 subplots
    %han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    set(gca,'FontSize',20);
    ylabel(han,'Acceleration [g]','FontSize',20);
    xlabel(han,'Duration [s]','FontSize',20);
    %title(han,'yourTitle');
    
    %% Redressement
    Cond = 1; % When Cond = 1 then Theta = Theta_Init
    [Ay_Redress_Init_1, Az_Redress_Init_1, Theta_1] = redressement(Ay_wo, Az_wo, Alt, Speed, Theta_Init, Cond);
    Cond = 2; % When Cond = 2 then limite à 0.2 appliquée sur Theta_Init
    [Ay_Redress_Init_2, Az_Redress_Init_2, Theta_2] = redressement(Ay_wo, Az_wo, Alt, Speed, Theta_Init, Cond);
    Cond = 3; % When Theta = Theta_sgf and we want to obtain different Ay_Redress and Az_Redress
    Theta_sgf = sgolayfilt(Theta_2,order,framelen);
    [Ay_Redress_Tsgf, Az_Redress_Tsgf, ~] = redressement(Ay_wo, Az_wo, Alt, Speed, Theta_sgf, Cond);
    % pas besoin du theta dans le cas 3 car on l'a déjà le Theta qu'on veut
    
    Ay_Redress_sgf = sgolayfilt(Ay_Redress_Tsgf,order,framelen);
    Az_Redress_sgf = sgolayfilt(Az_Redress_Tsgf,order,framelen);
    
%% Operating Range
    [ Range_Ay_wo, Diff_Ay_wo ] = operating_range( Ay_wo, Tol )
    [ Range_Az_wo, Diff_Az_wo ] = operating_range( Az_wo, Tol )
    [ Range_Ay_Redress, Diff_Ay_Redress ] = operating_range( Ay_Redress_Init_2, Tol )
    [ Range_Az_Redress, Diff_Az_Redress ] = operating_range( Az_Redress_Init_2, Tol )
    [ Range_Ay_Redress_Tsgf, Diff_Ay_Redress_Tsgf ] = operating_range( Ay_Redress_Tsgf, Tol )
    [ Range_Az_Redress_Tsgf, Diff_Az_Redress_Tsgf ] = operating_range( Az_Redress_Tsgf, Tol )
    

    
%% Plots     
    figure;
    subplot(2,1,1)
    plot(Time_Datalogger,Theta_1); 
    xlabel('Duration [s]','FontSize',20); ylabel('Theta [°]','FontSize',20);
    set(gca,'FontSize',20);
    subplot(2,1,2)
    plot(Time_Datalogger,Theta_2); 
    xlabel('Duration [s]','FontSize',20); ylabel('Theta [°]','FontSize',20);
    set(gca,'FontSize',20);
    
    figure; % Theta_2 - Theta_sgf
    subplot(2,1,1)
    plot(Time_Datalogger, Theta_2); ylim([-30 30])
    xlabel('Duration [s]','FontSize',20); ylabel('Theta [°]','FontSize',20);
    set(gca,'FontSize',20)
    subplot(2,1,2)
    plot(Time_Datalogger, Theta_sgf); ylim([-30 30])
    xlabel('Duration [s]','FontSize',20); ylabel('Theta [°]','FontSize',20);
    set(gca,'FontSize',20)
    
    yalt = linspace(0,100,150); xalt = 500*ones(length(yalt),1);
    ytheta = linspace(-10,20,150); xtheta = 500*ones(length(ytheta),1);
    figure; % Alt - Theta_sgf 
    subplot(2,1,1) 
    plot(Time_Datalogger, Alt); xlim([400 600]);
    xlabel('Duration [s]','FontSize',20); ylabel('Altitude [m]','FontSize',20);
    set(gca,'FontSize',20)
    line(xalt,yalt,'Color','red','LineStyle','--','LineWidth',2);
    subplot(2,1,2)
    plot(Time_Datalogger, Theta_sgf); xlim([400 600]);
    xlabel('Duration [s]','FontSize',20); ylabel('Theta [°]','FontSize',20);
    set(gca,'FontSize',20)
    line(xtheta,ytheta,'Color','red','LineStyle','--','LineWidth',2);
    
    % Plot Theta - Speed with limits
    yleft_1 = linspace(0,140,141); 
    yright_1 = yleft_1; 
    xleft_1 = -64.16*ones(length(yleft_1),1); 
    xright_1 = 64.16*ones(length(yleft_1),1); % max values of theta
    yleft_2 = linspace(0,140,141);
    yright_2 = yleft_2; 
    xleft_2 = -9.648*ones(length(yleft_2),1); 
    xright_2 = 9.648*ones(length(yleft_2),1); % max values of theta
    figure; % Theta - Speed
    subplot(1,2,1)
    plot(Theta_1, Speed*3.6, 'HandleVisibility','off');  %ylim([0,40]);
    xlabel('Theta [°]','FontSize',20); ylabel('Speed [km/h]','FontSize',20);
    set(gca,'FontSize',20)
    line(xleft_1,yleft_1,'Color','red','LineStyle','--','LineWidth',2);%,'HandleVisibility','off'); 
    line(xright_1,yright_1,'Color','red','LineStyle','--','LineWidth',2,'HandleVisibility','off');
    legend('Left and right limit: 64.16°')
    subplot(1,2,2)
    plot(Theta_2, Speed*3.6,'HandleVisibility','off');  xlim([-15, 15]); %ylim([0,40]); 
    xlabel('Theta [°]','FontSize',20); ylabel('Speed [km/h]','FontSize',20);
    set(gca,'FontSize',20)
    line(xleft_2,yleft_2,'Color','red','LineStyle','--','LineWidth',2);%,'HandleVisibility','off'); 
    line(xright_2,yright_2,'Color','red','LineStyle','--','LineWidth',2,'HandleVisibility','off');
    legend('Left and right limit: 9.65°')
    
    figure; % OBDsgf - Acc_y - Acc_z - Non Filtré
    plot(Time_Datalogger,Ay_OBD_grad_sgf./9.81);  hold on;
    xlabel('Duration [s]','FontSize',20); ylabel('Acceleration [g]','FontSize',20);
    plot(Time_Datalogger,Ay_Redress_Init_1);
    plot(Time_Datalogger,Az_Redress_Init_1);
    set(gca,'FontSize',20); legend('Ay-OBD','Ay-Accelerometer','Az-Accelerometer');
    
    figure; % OBDsgf - Acc_y - Acc_z - Non Filtré mais avec le Theta_sgf
    plot(Time_Datalogger,Ay_OBD_grad_sgf./9.81);  hold on;
    xlabel('Duration [s]','FontSize',20); ylabel('Acceleration [g]','FontSize',20);
    plot(Time_Datalogger,Ay_Redress_Tsgf);
    plot(Time_Datalogger,Az_Redress_Tsgf);
    set(gca,'FontSize',20); legend('Ay-OBD','Ay-Accelerometer','Az-Accelerometer');
    
    figure; % OBDsgf - Acc_y - Acc_z - Filtré SGF sur le theta sgf
    plot(Time_Datalogger,Ay_OBD_grad_sgf./9.81);  hold on; %xlim([0, 600]);
    xlabel('Duration [s]','FontSize',20); ylabel('Acceleration [g]','FontSize',20);
    plot(Time_Datalogger,Ay_Redress_sgf); hold on; xlim([0, 600]);
    plot(Time_Datalogger,Az_Redress_sgf); xlim([0, 600]);
    set(gca,'FontSize',20); legend('Ay-OBD','Ay-Accelerometer','Az-Accelerometer');
    
    %% Partie pour corbi - critique accelerometre
     [ Mean_Ay_Redress_sgf, Time_Mod_Ay_sgf] = mean_datalogger( Ay_Redress_sgf )
     [ Mean_Ay_OBD_sgf, Time_Mod_Ay_OBD_sgf] = mean_datalogger( Ay_OBD_grad_sgf )
    
    
    figure;
    plot(Time_Datalogger,Speed.*3.6,'LineWidth',1.5); xlim([0 600]); % to be in [km/h] 
    xlabel('Duration [s]','FontSize',25); ylabel('Speed [km/h]','FontSize',25);
    set(gca,'FontSize',25);
    
    figure; % OBDsgf - Acc_y  - Filtré SGF sur le theta sgf
    plot(Time_Datalogger,Ay_OBD_grad_sgf./9.81);  hold on; %xlim([0, 600]);
    xlabel('Duration [s]','FontSize',25); ylabel('Acceleration [g]','FontSize',25);
    plot(Time_Datalogger,Ay_Redress_sgf); hold on; xlim([0, 600]);
    %plot(Time_Datalogger,Az_Redress_sgf); xlim([0, 600]);
    set(gca,'FontSize',25); legend('Ay-OBD','Ay-Accelerometer');%,'Az-Accelerometer');
    
    figure; % OBDsgf - Acc_y  - Filtré SGF sur le theta sgf
    plot(Time_Datalogger,Ay_OBD_grad_sgf./9.81);  hold on; xlim([245, 270]);
    xlabel('Duration [s]','FontSize',25); ylabel('Acceleration [g]','FontSize',25);
    plot(Time_Datalogger,Ay_Redress_sgf); hold on; xlim([245 270]);
    %plot(Time_Datalogger,Az_Redress_sgf); xlim([0, 600]);
    set(gca,'FontSize',25); legend('Ay-OBD','Ay-Accelerometer');%,'Az-Accelerometer');
    
    figure; % OBDsgf - Acc_y  - Filtré SGF sur le theta sgf
    plot(Time_Datalogger,Ay_OBD_grad_sgf./9.81);  hold on; xlim([0, 100]);
    xlabel('Duration [s]','FontSize',25); ylabel('Acceleration [g]','FontSize',25);
    plot(Time_Datalogger,Ay_Redress_sgf); %xlim([245 270]);
    %plot(Time_Datalogger,Az_Redress_sgf); xlim([0, 600]);
    set(gca,'FontSize',25); legend('Ay-OBD','Ay-Accelerometer');%,'Az-Accelerometer');
    
    figure; % OBDsgf - Acc_y  - Filtré SGF sur le theta sgf
    plot(Time_Mod_Ay_OBD_sgf,Mean_Ay_OBD_sgf./9.81);  hold on; xlim([820, 980]); ylim([-0.05 0.2])
    xlabel('Duration [s]','FontSize',25); ylabel('Acceleration [g]','FontSize',25);
    plot( Time_Mod_Ay_sgf,Mean_Ay_Redress_sgf); hold on; xlim([820, 980]);
    %plot(Time_Datalogger,Az_Redress_sgf); xlim([0, 600]);
    set(gca,'FontSize',25); legend('Ay-OBD','Ay-Accelerometer');%,'Az-Accelerometer');
    
%     figure; 
%     x = linspace(-1,1,500);
%     y = asind(x);
%     plot(x,y); 
   

end


