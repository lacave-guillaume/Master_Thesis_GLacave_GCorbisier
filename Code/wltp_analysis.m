close all; 
clear;
%% Script qui analyse les différentes parties du cycle wltp pour voir si
% elles sont en concordance avec un vrai cycle wltp
Raw_Datalog_Low = readtable('LOW-BadDriver-Datalogger.xlsx');
Raw_Datalog_Medium = readtable('MEDIUM-BadDriver-Datalogger.xlsx');
Raw_Datalog_High = readtable('HIGH-BadDriver-Datalogger.xlsx');
Raw_Datalog_Extra_High = readtable('EXHIGH-BadDriver-Datalogger.xlsx');

Speed_Low = Raw_Datalog_Low{2:end,6};
Speed_Medium = Raw_Datalog_Medium{2:end,6};
Speed_High = Raw_Datalog_High{2:end,6};
Speed_Extra_High = Raw_Datalog_Extra_High{2:end,6};

Data = zeros(5,4);
[Data_Low] = wltp_fun(Speed_Low);
[Data_Medium] = wltp_fun(Speed_Medium);
[Data_High] = wltp_fun(Speed_High);
[Data_Extra_High] = wltp_fun(Speed_Extra_High);
Data(:,1) = Data_Low;
Data(:,2) = Data_Medium;
Data(:,3) = Data_High;
Data(:,4) = Data_Extra_High;
Data


