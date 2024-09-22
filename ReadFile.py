import re
import pandas as pd
import numpy as np

# 定义一个函数来处理每行数据，将不定长度的空格分隔转换为固定分隔符（这里以逗号为例）
def process_line(line): # 调整格式
    return re.sub(r'\s+', ',', line.strip())

class Read_Property_File: # 读取Platform_Property.txt文件，获取其中参数
    def __init__(self, data_file_path=".\HydroDynamicData\Platform_Property.txt"):
        self.data_dict = {}
        self.data_file_path = data_file_path #".\HydroDynamicData\Platform_Property.txt"
        self.read_file()

    def read_file(self):
        parts = []
        with open(self.data_file_path, "r") as file:
            for line in file:
                processed_line = process_line(line)		
                parts = processed_line.strip().split(',')
                data_value = float(parts[0])
                variable_name = parts[1]
                self.data_dict[variable_name] = data_value


class Read_Hydro_Parameter_File: # 读取水动力参数.1/.3文件
    def __init__(self,file_name='.\HydroDynamicData\Spar.1'):
        self.file_name = file_name
        self.hydro_P1_file = self.open_file()
        
    def open_file(self):
        data = []
        with open(self.file_name, 'r') as file:
            for line in file:
                # 根据实际情况分割每一行数据
                processed_line = process_line(line)
                data.append(processed_line.split(','))        

        # 创建数据框
        df = pd.DataFrame(data)

        df.iloc[:,0] = df.iloc[:,0].astype(float)
        df.iloc[:,1] = df.iloc[:,1].astype(int)
        df.iloc[:,2] = df.iloc[:,2].astype(int)
        df.iloc[:,3] = df.iloc[:,3].astype(float)

        def convert_to_float(val):
            if val is None:
                return np.nan
            else:
                return float(val)

        # 应用转换函数到指定列
        df.iloc[:,4]= df.iloc[:,4].apply(convert_to_float)

        # 计算第5列中NaN的数量
        nan_count = df.iloc[:,4].isna().sum()

        # 取出第 5 列包含 NaN 的行
        nan_rows = df[df.iloc[:,4].isna()]

        # 取出第 5 列不包含 NaN 的行并存入新的 DataFrame
        new_df = df[~df.iloc[:,4].isna()]

        # 遍历dataframe中每一行，取出第2列和第3列的数据有10种不同的组合，找到这些组合形式，并将相同的组合那一行数据归为一类
        unique_combinations = {}
        for index, row in new_df.iterrows():
            combination = (row[1], row[2])
            if combination not in unique_combinations:
                unique_combinations[combination] = [index]
            else:
                unique_combinations[combination].append(index)

        # 把相同的类型归到一个dataframe中
        result_dfs = {} # 创建字典，字典中key为自由度编号，值为dataframe
        for combination, indices in unique_combinations.items():
            result_dfs[combination] = new_df.loc[indices]

        for combination,result_df in result_dfs.items():
            result_df.iloc[:,0] = (1 / result_df.iloc[:,0]) * 2 * np.pi
            
        print(result_dfs)
        return result_dfs
        