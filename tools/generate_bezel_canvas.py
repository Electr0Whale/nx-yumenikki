"""
Yume Nikki Switch Custom Bezel Generator (YNOproject Theme 9 Style & WenQuanYi 12px Native Bitmap)
Strictly adheres to:
1. Pure key hints only on both borders (no illustrations, frames, or decorative badges).
2. Key symbols rendered in tight bracket notation: [A], [摇杆], [B], [X], [Y], [L], [R], [+], [-], [ZL].
3. YNOproject theme 9 purple vertical gradient with pixel drop shadow.
4. Updated wording: A = 交互, X = 使用效果, ZL = 显示边框.
5. Compact vertical rhythm: line_gap = 1px, inter-group step = 48px, centered on Y=180.
6. Base resolution 640x360 (center [80, 560) 100% transparent), scaled 2x (720p) and 3x (1080p).
7. Uses native 1-bit WenQuanYi Bitmap Song (wenquanyi_9pt.pcf, 12px) for 100% razor-sharp pixel font rendering.
"""

import os
import shutil
import numpy as np
from PIL import Image, ImageFont, ImageDraw

wqy_pcf = r"D:\Download\wqy-bitmapsong-pcf-1.0.0-RC1.tar\wqy-bitmapsong-pcf-1.0.0-RC1\wqy-bitmapsong\wenquanyi_9pt.pcf"
font_wqy = ImageFont.truetype(wqy_pcf, 12)

# YNOproject theme 9 gradient stops
STOPS = [
    (0.0000, (217, 179, 228)),
    (0.4375, (217, 179, 228)),
    (0.5625, (205, 162, 214)),
    (0.6875, (194, 146, 200)),
    (0.8125, (182, 130, 186)),
    (0.8750, (171, 115, 173)),
    (0.9375, (159, 98, 158)),
    (1.0000, (137, 87, 131)),
]

def interpolate_gradient(pos):
    pos = max(0.0, min(1.0, pos))
    for i in range(len(STOPS) - 1):
        p0, c0 = STOPS[i]
        p1, c1 = STOPS[i+1]
        if p0 <= pos <= p1:
            if p1 == p0:
                return c0
            t = (pos - p0) / (p1 - p0)
            r = int(c0[0] + t * (c1[0] - c0[0]))
            g = int(c0[1] + t * (c1[1] - c0[1]))
            b = int(c0[2] + t * (c1[2] - c0[2]))
            return (r, g, b)
    return STOPS[-1][1]

def render_wqy_text(text, font, shadow_color=(20, 8, 20, 255), shadow_offset=(1, 1)):
    """
    Renders pure 1-bit native WenQuanYi Bitmap Song with 1px drop shadow.
    """
    bbox = font.getbbox(text)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    
    pad = 2
    w = tw + pad * 2 + abs(shadow_offset[0])
    h = th + pad * 2 + abs(shadow_offset[1])
    
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 1. Shadow (+1, +1)
    sx = pad - bbox[0] + shadow_offset[0]
    sy = pad - bbox[1] + shadow_offset[1]
    draw.text((sx, sy), text, font=font, fill=shadow_color)
    
    # 2. Crisp 1-bit alpha mask
    mask = Image.new("L", (w, h), 0)
    mdraw = ImageDraw.Draw(mask)
    tx = pad - bbox[0]
    ty = pad - bbox[1]
    mdraw.text((tx, ty), text, font=font, fill=255)
    
    mask_np = np.array(mask)
    mask_np = np.where(mask_np > 50, 255, 0).astype(np.uint8)
    crisp_mask = Image.fromarray(mask_np, mode="L")
    
    # 3. YNOproject gradient fill
    grad_img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(grad_img)
    for y in range(h):
        rel_pos = (y - pad) / float(max(1, th))
        col = interpolate_gradient(rel_pos)
        gdraw.line([(0, y), (w, y)], fill=(col[0], col[1], col[2], 255))
        
    grad_img.putalpha(crisp_mask)
    final = Image.alpha_composite(img, grad_img)
    return final, tw, th

def build_wqy_bezel_canvas(step=48, line_gap=1):
    canvas = Image.new("RGBA", (640, 360), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    
    # Fill solid black on left [0, 80) and right [560, 640)
    draw.rectangle([0, 0, 79, 359], fill=(0, 0, 0, 255))
    draw.rectangle([560, 0, 639, 359], fill=(0, 0, 0, 255))
    
    # 5 items centered vertically around y=180
    centers = [180 + (i - 2) * step for i in range(5)]
    
    # Tight bracket formatting per user request: [A], [摇杆], etc.
    left_entries = [
        ("[摇杆]", "角色移动"),
        ("[A]", "交互"),
        ("[B]", "菜单·取消"),
        ("[X]", "使用效果"),
        ("[Y]", "退出效果"),
    ]
    right_entries = [
        ("[L]", "丢下效果"),
        ("[R]", "掐脸醒来"),
        ("[+]", "游戏加速"),
        ("[-]", "系统设置"),
        ("[ZL]", "显示边框"),
    ]
        
    # Render left
    for (btn, desc), cy in zip(left_entries, centers):
        im_b, bw, bh = render_wqy_text(btn, font_wqy)
        im_d, dw, dh = render_wqy_text(desc, font_wqy)
        
        total_h = bh + line_gap + dh
        top_y = cy - total_h // 2
        
        bx = 40 - bw // 2
        by = top_y
        canvas.alpha_composite(im_b, (bx, by))
        
        dx = 40 - dw // 2
        dy = top_y + bh + line_gap
        canvas.alpha_composite(im_d, (dx, dy))
        
    # Render right
    for (btn, desc), cy in zip(right_entries, centers):
        im_b, bw, bh = render_wqy_text(btn, font_wqy)
        im_d, dw, dh = render_wqy_text(desc, font_wqy)
        
        total_h = bh + line_gap + dh
        top_y = cy - total_h // 2
        
        bx = 600 - bw // 2
        by = top_y
        canvas.alpha_composite(im_b, (bx, by))
        
        dx = 600 - dw // 2
        dy = top_y + bh + line_gap
        canvas.alpha_composite(im_d, (dx, dy))
        
    # Enforce 100% transparency on [80, 560)
    arr = np.array(canvas)
    arr[:, 80:560, :] = 0
    return Image.fromarray(arr, "RGBA")

def main():
    os.makedirs("work/bezel", exist_ok=True)
    brain_dir = r"C:\Users\Admin\.gemini\antigravity\brain\38db0c58-1e23-48dd-ad6f-20cbedd169c5"
    
    # 1. Base 640x360 canvas (Compact standard: step=48, line_gap=1, tight brackets)
    base_640x360 = build_wqy_bezel_canvas(step=48, line_gap=1)
    base_path = "work/bezel/bezel_base_640x360.png"
    base_640x360.save(base_path)
    print(f"Generated base canvas: {base_path} (640x360)")
    
    # Verify center transparency
    arr = np.array(base_640x360)
    assert np.max(arr[:, 80:560, 3]) == 0, "Center area must be 100% transparent!"
    print("Verification PASSED: Center 480x360 area is 100% transparent (alpha=0)!")
    
    # 2. Handheld 2x scale (1280x720) with nearest-neighbor
    handheld_1280x720 = base_640x360.resize((1280, 720), Image.NEAREST)
    hh_path = "work/bezel/bezel_handheld_1280x720.png"
    handheld_1280x720.save(hh_path)
    print(f"Generated handheld canvas: {hh_path} (1280x720, 2x)")
    
    # 3. Docked 3x scale (1920x1080) with nearest-neighbor
    docked_1920x1080 = base_640x360.resize((1920, 1080), Image.NEAREST)
    dk_path = "work/bezel/bezel_docked_1920x1080.png"
    docked_1920x1080.save(dk_path)
    print(f"Generated docked canvas: {dk_path} (1920x1080, 3x)")
    
    # 4. Mockup preview with actual 4:3 game screen
    preview = handheld_1280x720.copy()
    game_title = Image.open('work/title.png').convert('RGBA')
    game_screen = game_title.resize((960, 720), Image.NEAREST)
    preview.paste(game_screen, (160, 0), game_screen)
    prev_path = "work/bezel/preview_handheld_with_game.png"
    preview.save(prev_path)
    print(f"Generated full mockup preview: {prev_path} (1280x720)")
    
    # Copy previews to brain artifact dir
    shutil.copyfile(prev_path, os.path.join(brain_dir, "preview_bezel.png"))
    shutil.copyfile(prev_path, os.path.join(brain_dir, "preview_bezel_tight_bracket.png"))
    print("Copied preview images to artifact directory.")

if __name__ == '__main__':
    main()
