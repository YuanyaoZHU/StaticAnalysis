# encoding:utf-8

"""
@ProjectName:StaticAnalysis
@Author:Zhu Yuanyao
@File:StaticAnalysis.py
@Date:2024/9/6
@Email:zhuyuanyao_only@hotmail.com
@ProjectInformation: This project is to simulate the floating wind turbine in frequency domain
"""

import numpy as np
import pandas as pd
import numpy.matlib
from dataclasses import dataclass

@dataclass
class dimension:
    column_diameter:float   # 上浮桶直径
    column_height:float     # 上浮筒之间的距离
    column_distance:float   # 上浮筒高度
    bottom_diameter:float   # 下浮筒直径
    bottom_height:float     # 下浮筒高度    

class stability:
    def __init__(self,dimension) -> None:
        self.col_D = dimension.column_diameter    # 上浮桶直径
        self.col_dis = dimension.column_distance  # 上浮筒之间的距离
        self.col_H = dimension.column_height      # 上浮筒高度
        self.bot_D = dimension.bottom_diameter    # 下浮筒直径
        self.bot_H = dimension.bottom_height      # 下浮筒高度
        self.total_I = self.moment_inertia()
        self.volumn = self.volumn_platform()
        self.GM = self.GM_cal()

    def moment_inertia(self):
        I_col = 1/64*np.pi*self.col_D**4
        A_col = 1/4*np.pi*self.col_D**2
        total_I = I_col+2*A_col*(self.col_dis/2)**2
        return total_I
    
    def volumn_platform(self):
        area_column = 0.25*np.pi*self.col_D**2
        volumn_column = area_column*self.col_H
        area_bottom = 0.25*np.pi*self.bot_D**2
        volumn_bottom = area_bottom*self.bot_H
        total_volumn = 3*(volumn_bottom+volumn_column)
        return total_volumn
    
    def GM_cal(self):
        GM = self.total_I/self.volumn
        return GM
        
platform_dimension = dimension(10,30,10,20,6)
stab = stability(platform_dimension)
print(stab.GM)