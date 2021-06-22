%function [ Variable_Names_Vector , Values_Matrix ] = read_Data( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear;
file = 'CarteSD.TXT';
fileID = fopen(file); % =3
C_Scan = textscan(fileID,'%s','Delimiter','/n'); % size [1 1]
fclose(fileID);

Datas_OBD = C_Scan{1};
Size_Data = size(Datas_OBD);
C_Length = Size_Data(1);

Variable_Names = Datas_OBD{1};
Variable_Names_Vector = strsplit(Variable_Names, ',');
% X_Lambda1 = zeros(C_Length,1);
% Y_Lambda1 = zeros(C_Length,1);
% X_Lambda2 = zeros(C_Length,1);
% Y_Lambda2 = zeros(C_Length,1);
Size_Var = size(Variable_Names_Vector);
Values_Matrix = zeros(C_Length-1, Size_Var(2)+1); 
% zeros(171, 16) +1 car data sur "17 colonnes" car dernière colonne =
% espace pour passer à la ligne suivante
size(Values_Matrix);
formatIn = 'HH:MM:SS';

for i = 2:Size_Data(1)-1 % -1 car sinon fonctionne pas pour dernière ligne qui s'arrete au milieu
    Data_OBD = strsplit(Datas_OBD{i}, ',');
    for j = 1:Size_Var(2)
        if j == 1
            [~,~,~,H,MN,S] = datevec(Data_OBD(j),formatIn);
            Seconds = 3600*H + 60*MN + S;
            Values_Matrix(i-1,j) = Seconds; 
        else
            To_Insert = Data_OBD(j);
            %Is_OBD = strfind(To_Insert,'1 ');
            if length(To_Insert{1}) > 12
                [~,Values_Matrix(i-1,j)] = str_hex_2_dec(To_Insert{1});
            else
                [Values_Matrix(i-1,j),~] = str_hex_2_dec(To_Insert{1});
            end
        end
    end
end
figure; plot(mod(Values_Matrix(:,1),45000), Values_Matrix(:,10));


%end

