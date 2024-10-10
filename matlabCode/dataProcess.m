function [A,B]=dataProcess(data)

Data.Infi = data(data(:,1)<0,:); % 无穷大频率对应的附加质量

Data.zero = data(data(:,1)==0,:); % 0频处对应的附加质量

Data.Normal = data(data(:,1)>0,:); % 正常数据

Data.Normal(:,1) = 2*pi ./Data.Normal(:,1);

unique_combinations = unique(Data.Normal(:,2:3),'rows'); % 判断有多少种自由度组合

separated_data = cell(size(unique_combinations,1),1); % 创建一个元胞数组

for i = 1:size(unique_combinations,1)
    combination = unique_combinations(i,:);
    separated_data{i} = Data.Normal(Data.Normal(:,2)==combination(1) & Data.Normal(:,3)==combination(2),:);
end

A = separated_data;
B = unique_combinations;