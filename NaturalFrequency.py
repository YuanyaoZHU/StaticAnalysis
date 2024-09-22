# encoding:utf-8

"""
@ProjectName:NaturalFrequency
@Author:Zhu Yuanyao
@File:NatrualFrequency.py
@Date:2024/9/8
@Email:zhuyuanyao_only@hotmail.com
@ProjectInformation: This project is to calculate the natural frequency
"""

import numpy as np
import pandas as pd
import numpy.matlib
import re
import matplotlib.pyplot as plt
from ReadFile import Read_Hydro_Parameter_File as RHPF


rhpf = RHPF('.\HydroDynamicData\Spar.1')
plt.plot(rhpf.hydro_P1_file[(1,1)].iloc[:, 0], rhpf.hydro_P1_file[(1,1)].iloc[:, 3])
plt.xlabel('Frequency [Radian]')
plt.ylabel('Added mass [kg]')
plt.title('Plot of First vs Fourth Column')
plt.show()

class InertiaTensor:
    def __init__(self, data_file):
        self.tensor = np.zeros((6, 6))
        self.read_data(data_file)

    def read_data(self, file_path):
        try:
            data = np.loadtxt(file_path)
            if data.shape!= (6, 6):
                raise ValueError("Data shape must be 6x6.")
            self.tensor = data
        except FileNotFoundError:
            print(f"File {file_path} not found.")
        except ValueError as e:
            print(e)

          
data_file_path = ".\HydroDynamicData\mass.txt"
inertia = InertiaTensor(data_file_path)
print(inertia.tensor)



'''  	
# 打印每个组合对应的 DataFrame
for combination, result_df in result_dfs.items():
    print(f"组合 {combination} 的 DataFrame：")
    print(result_df)
    print("-" * 30)   
'''