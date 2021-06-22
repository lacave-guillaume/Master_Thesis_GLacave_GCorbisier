function [ Value_1, Value_2 ] = str_hex_2_dec( String )
% STR_HEX_2_DEC Function that transforms strings expressed in hexadecimal
% to decimal values 
% Order of coming strings: NAME-Adress
% ENGINE_LOAD - 04
% ENGINE_TEMP - 05
% INTAKE_MAP - 0B
% RPM - 0C
% SPEED - 0D
% TIMING_ADVANCE - (0 DATA)
% INTAKE_TEMP - 0F
% MAF_FLOW - 10
% OX_SENS_1_LV - 24
% OX_SENS_2_LV - ?? (0 DATA)
% COMMANDED_EGR - 2C (0 DATA)
% EGR_ERROR - 2D (0 DATA)
% AMBIENT_AIR - 46
% FUEL_INJEC_TIMING - 5D (0 DATA)
% FUEL_RATE - 5E (0 DATA)
%
if nargin == 0
    String = '41 34 85 D0 80 1E ';
end
String = strrep(String,' ','');
% if strcmp(String,'')
%     Value_1 = 0;
%     Value_2 = 0;
% end
adress = String(3:4);
String = String(5:end);
Value_1 = 0;
Value_2 = 0;
if strcmp(adress,'04') % ENGINE_LOAD
    Value_1 = hex2dec(String)/2.55; % [%]
elseif strcmp(adress,'05') % ENGINE_TEMP
    Value_1 = hex2dec(String)-40; % [°C]
elseif strcmp(adress,'0B') % INTAKE_MAP
    Value_1 = hex2dec(String); % [kPa]
elseif strcmp(adress,'0C') % RPM
    String_1 = String(1:2);
    String_2 = String(3:end);
    Value_1 = (256*hex2dec(String_1)+hex2dec(String_2))/4; % [rpm]
elseif strcmp(adress,'0D') % SPEED
    Value_1 = hex2dec(String); % [km/h]
elseif strcmp(adress,'0F') % INTAKE_TEMP
    Value_1 = hex2dec(String); % [°C]
elseif strcmp(adress,'10') % MAF_FLOW (mass air flow sensor)
    String_1 = String(1:2);
    String_2 = String(3:end);
    Value_1 = (256*hex2dec(String_1)+hex2dec(String_2))/100; % [g/s]
elseif strcmp(adress,'11') % THROTTLE_POSITION
    Value_1 = (100/255)*hex2dec(String); % [%]
elseif strcmp(adress,'24') % OX_SENS_1_LV - Voltage
    String_1 = String(1:2);
    String_2 = String(3:4);
    String_3 = String(5:6);
    String_4 = String(7:end);
    Value_1 = (2/65536)*(256*hex2dec(String_1)+hex2dec(String_2)); % [ratio]
    Value_2 = (8/65536)*(256*hex2dec(String_3)+hex2dec(String_4)); % [V]
elseif strcmp(adress,'34') % OX_SENSOR_34 - Current
    String_1 = String(1:2);
    String_2 = String(3:4);
    String_3 = String(5:6);
    String_4 = String(7:end);
    Value_1 = (2/65536)*(256*hex2dec(String_1)+hex2dec(String_2)); % [ratio]
    Value_2 = hex2dec(String_3)+(hex2dec(String_4)/256)-128; % [mA]
elseif strcmp(adress,'35') % OX_SENSOR_35 - Current
    String_1 = String(1:2);
    String_2 = String(3:4);
    String_3 = String(5:6);
    String_4 = String(7:end);
    Value_1 = (2/65536)*(256*hex2dec(String_1)+hex2dec(String_2)); % [ratio]
    Value_2 = hex2dec(String_3)+(hex2dec(String_4)/256)-128; % [mA] % [mA]
elseif strcmp(adress,'44') % COMMANDED_AIR_FUEL_RATIO
    String_1 = String(1:2);
    String_2 = String(3:end);
    Value_1 = (2/65536)*(256*hex2dec(String_1)+hex2dec(String_2)); % [ratio]
elseif strcmp(adress,'46') % AMBIENT_AIR
    Value_1 = hex2dec(String)-40; % [°C]
end

