from ReadFile import Read_Property_File as RPF
from ReadFile import Read_Hydro_Parameter_File as RHPF
import re

#rpf = RPF(".\HydroDynamicData\Platform_Property.txt") 
rhpf = RHPF('.\HydroDynamicData\Spar.1')

print(rhpf.hydro_P1_file)