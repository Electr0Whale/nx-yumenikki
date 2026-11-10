import os

def bin2h(bin_path, h_path, var_name="bezel_png"):
    with open(bin_path, 'rb') as f:
        data = f.read()
    
    with open(h_path, 'w', encoding='utf-8') as f:
        f.write("/* Auto-generated header for Yume Nikki Switch Bezel - DO NOT EDIT DIRECTLY */\n")
        f.write("#pragma once\n\n")
        f.write("#include <cstddef>\n")
        f.write("#include <cstdint>\n\n")
        f.write(f"static const uint8_t {var_name}[] = {{\n")
        
        for i in range(0, len(data), 16):
            chunk = data[i:i+16]
            hex_str = ", ".join(f"0x{b:02x}" for b in chunk)
            if i + 16 < len(data):
                hex_str += ","
            f.write(f"    {hex_str}\n")
            
        f.write("};\n\n")
        f.write(f"static const size_t {var_name}_size = sizeof({var_name});\n")
    print(f"Generated {h_path} ({len(data)} bytes, var: {var_name})")

if __name__ == '__main__':
    src = "work/bezel/bezel_base_640x360.png"
    dst = "work/src/easyrpg-player-0.8.1.1/src/platform/switch/bezel_png.h"
    bin2h(src, dst)
