clc;
clear;

% 读取数据

filename = ".\HydroDynamicData\Spar.1";
fileID = fopen(filename);
DataIn = textscan(fileID,repmat('%f',[1,5]),'CollectOutput',1); 
fclose(fileID);
Data = DataIn{1,1};

