function [ Data ] = wltp_fun( Speed )
%UNTITLED3 Summary of this function goes here
%   Input : Speed Vector Representing one of the four parts of the wltp
%   cycle 
%   Output : Vector Data with the following parts
% - Duration [s]
% - Stop Duration [s]
% - Maximum Speed [km/h]
% - Mean Speed without stop [km/h]
% - Mean Speed with stop [km/h]
Duration = length(Speed)/10;
Stop_Duration = 0;
for i = 1:length(Speed)
   if Speed(i) <= 2 
       Stop_Duration = Stop_Duration + 1;
   end
end
Stop_Duration = Stop_Duration/10;
Speed_wo_stop = Speed(Speed~=0);
Mean_Speed = mean(Speed);
Mean_Speed_wo_stop = mean(Speed_wo_stop);
Max_Speed = max(Speed);
Data = [Duration; Stop_Duration; Max_Speed; Mean_Speed_wo_stop; Mean_Speed];
end

