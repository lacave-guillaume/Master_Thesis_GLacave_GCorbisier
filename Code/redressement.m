function [ Ay_Redress, Az_Redress, Theta ] = redressement( Ay, Az, Alt, Speed, Theta, Cond)
%UNTITLED Fonction qui va redresser l'accélération au cours du temps grâce
% à l'altitude afin d'obtenir Ay oscillant autour de 0 [g] et Az oscillant
% autour de 1 [g]
%   Detailed explanation goes here
Ay_Redress = zeros(length(Ay),1);
Az_Redress = zeros(length(Az),1);
%g = 9.81; % [m/s^2]

%% Si theta=0, on est à plat au départ mais alpha est penché dans la voiture
nbr_sec_plat = 100; % =10sec  % attendre 10 [s] avec l'OBD avant de démarrer
Ay_start = zeros(nbr_sec_plat,1);
Az_start = zeros(nbr_sec_plat,1);
for i = 1:nbr_sec_plat
    Ay_start = Ay(i);
    Az_start = Az(i);
end
Ay_plat = mean(Ay_start);
Az_plat = mean(Az_start);
%Alpha_plat = atand(Ay_plat/Az_plat)
%Alpha_plat = 38.1015;
Alpha_plat = -52.5;

gtest = sqrt(Ay_plat^2+Az_plat^2); % g calculé à plat pythagore

%% Si theta ~= 0, alors on est en montée ou en descente
Delta_t = 0.1; % [s]
%Theta = zeros(length(Alt),1);

if Cond == 1 % meaning that Theta = Theta_Init without limit at 0.2
    for i = 2:length(Alt)-1
        if Speed(i) == 0
            Theta(i) = Theta(i-1);
            Ay_Redress(i) = 0;
            Az_Redress(i) = gtest;
        else
            if abs((Alt(i+1) - Alt(i))/(Delta_t*Speed(i))) >= 1
                Theta(i) = 0;
                Ay_Redress(i) = Ay(i)*cosd(Alpha_plat+Theta(i)) - Az(i)*sind(Alpha_plat+Theta(i));
                Az_Redress(i) = Az(i)*cosd(Alpha_plat+Theta(i)) + Ay(i)*sind(Alpha_plat+Theta(i));
            else
                Theta(i) = asind((Alt(i+1) - Alt(i))/(Delta_t*Speed(i)));
                Ay_Redress(i) = Ay(i)*cosd(Alpha_plat+Theta(i)) - Az(i)*sind(Alpha_plat+Theta(i));
                Az_Redress(i) = Az(i)*cosd(Alpha_plat+Theta(i)) + Ay(i)*sind(Alpha_plat+Theta(i));
            end
        end
    end
elseif Cond == 2 % meaning that Theta = Theta_Init but with the limit at 0.2
    for i = 2:length(Alt)-1
        if Speed(i) == 0
            Theta(i) = Theta(i-1);
            Ay_Redress(i) = 0;
            Az_Redress(i) = gtest;
        else
            if abs((Alt(i+1) - Alt(i))/(Delta_t*Speed(i))) >= 1
                Theta(i) = 0;
                Ay_Redress(i) = Ay(i)*cosd(Alpha_plat+Theta(i)) - Az(i)*sind(Alpha_plat+Theta(i));
                Az_Redress(i) = Az(i)*cosd(Alpha_plat+Theta(i)) + Ay(i)*sind(Alpha_plat+Theta(i));
            elseif abs((Alt(i+1) - Alt(i))/(Delta_t*Speed(i))) >= sind(atand(17/100))
                if (Alt(i+1) - Alt(i))/(Delta_t*Speed(i)) >= 0
                    Theta(i) = asind(sind(atand(17/100)));
                    Ay_Redress(i) = Ay(i)*cosd(Alpha_plat+Theta(i)) - Az(i)*sind(Alpha_plat+Theta(i));
                    Az_Redress(i) = Az(i)*cosd(Alpha_plat+Theta(i)) + Ay(i)*sind(Alpha_plat+Theta(i));
                else
                    Theta(i) = asind(-sind(atand(17/100)));
                    Ay_Redress(i) = Ay(i)*cosd(Alpha_plat+Theta(i)) - Az(i)*sind(Alpha_plat+Theta(i));
                    Az_Redress(i) = Az(i)*cosd(Alpha_plat+Theta(i)) + Ay(i)*sind(Alpha_plat+Theta(i));
                end
            else
                Theta(i) = asind((Alt(i+1) - Alt(i))/(Delta_t*Speed(i)));
                Ay_Redress(i) = Ay(i)*cosd(Alpha_plat+Theta(i)) - Az(i)*sind(Alpha_plat+Theta(i));
                Az_Redress(i) = Az(i)*cosd(Alpha_plat+Theta(i)) + Ay(i)*sind(Alpha_plat+Theta(i));
            end
        end
    end
else % meaning that Theta = Theta_sgf
    for i = 2:length(Alt)-1
        if Speed(i) == 0
            Ay_Redress(i) = 0;
            Az_Redress(i) = gtest;
        else
            Ay_Redress(i) = Ay(i)*cosd(Alpha_plat+Theta(i)) - Az(i)*sind(Alpha_plat+Theta(i));
            Az_Redress(i) = Az(i)*cosd(Alpha_plat+Theta(i)) + Ay(i)*sind(Alpha_plat+Theta(i));
        end
    end
    
end

end

