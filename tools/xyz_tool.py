import zlib
import os
import sys
from PIL import Image

def xyz_to_png(xyz_path, png_path):
    with open(xyz_path, 'rb') as f:
        data = f.read()
    if data[:4] != b'XYZ1':
        raise ValueError('Invalid XYZ file')
    w = int.from_bytes(data[4:6], 'little')
    h = int.from_bytes(data[6:8], 'little')
    raw = zlib.decompress(data[8:])
    palette = raw[:768]
    pixels = raw[768:]
    img = Image.frombytes('P', (w, h), pixels)
    img.putpalette(palette)
    img.save(png_path)
    print(f'Converted {xyz_path} -> {png_path} ({w}x{h})')

def png_to_xyz(png_path, xyz_path):
    img = Image.open(png_path)
    if img.mode != 'P':
        img = img.convert('P', palette=Image.ADAPTIVE, colors=256)
    w, h = img.size
    palette = img.getpalette()
    if len(palette) < 768:
        palette = palette + [0] * (768 - len(palette))
    palette_bytes = bytes(palette[:768])
    pixel_bytes = img.tobytes()
    raw = palette_bytes + pixel_bytes
    compressed = zlib.compress(raw)
    header = b'XYZ1' + w.to_bytes(2, 'little') + h.to_bytes(2, 'little')
    with open(xyz_path, 'wb') as f:
        f.write(header + compressed)
    print(f'Converted {png_path} -> {xyz_path} ({w}x{h})')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python xyz_tool.py <xyz2png|png2xyz|batch_xyz2png> ...')
        sys.exit(1)
    cmd = sys.argv[1]
    if cmd == 'batch_xyz2png':
        import glob
        in_dir = sys.argv[2]
        out_dir = sys.argv[3]
        os.makedirs(out_dir, exist_ok=True)
        for p in glob.glob(os.path.join(in_dir, '*.xyz')):
            name = os.path.splitext(os.path.basename(p))[0]
            xyz_to_png(p, os.path.join(out_dir, name + '.png'))
    elif cmd == 'xyz2png':
        xyz_to_png(sys.argv[2], sys.argv[3])
    elif cmd == 'png2xyz':
        png_to_xyz(sys.argv[2], sys.argv[3])
    else:
        print(f'Unknown command {cmd}')
        sys.exit(1)
