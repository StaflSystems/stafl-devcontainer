python
import sys 
sys.path.insert(0, '/opt/gcc-arm-none-eabi-10.3-2021.10/share/gcc-arm-none-eabi/libstdcxx')
from v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
