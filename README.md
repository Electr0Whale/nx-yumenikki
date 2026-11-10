# Yume Nikki for Nintendo Switch

A standalone Nintendo Switch port of the classic surreal exploration adventure game *Yume Nikki* (0.10), built on a customized build of the EasyRPG Player engine.

---

## Controls

| Button | Action | Description |
|:---|:---|:---|
| Left Stick / D-Pad | Move / Cursor | Move Madotsuki or navigate menus |
| A | Interact / Confirm | Interact with objects, talk, confirm in menus |
| B | Menu / Cancel | Open/close effect menu, cancel selection |
| X | Use Effect | Trigger active effect action or sit down (Num 1) |
| Y | Exit Effect | Cancel current effect state or stand up (Num 3) |
| L | Drop Effect | Drop equipped effect onto the carpet in the Nexus (Num 5) |
| R | Wake Up | Pinch cheek to wake up from dream to bedroom (Num 9) |
| ZL | Show Bezel | Hold to display 16:9 pixel bezel overlay; release to hide |
| + (Plus) | Fast Forward | Speed up gameplay |
| ZR | Fast Forward | Alternate fast-forward trigger |
| - (Minus) | Settings | Open EasyRPG system settings menu |

---

## Installation

### Method 1: NSP Package (Recommended)

1. Download `梦日记_v1.2.1.nsp` from the [Releases](https://github.com/Electr0Whale/nx-yumenikki/releases) page.
2. Connect your Nintendo Switch to your computer and launch **DBI** (or your preferred installer such as Awoo-Installer / Tinfoil).
3. Using DBI MTP mode, drag and drop the `.nsp` file into `MicroSD install` or `NAND install`.
4. Launch *Yume Nikki* directly from the Switch Home Menu and choose your user profile when prompted.

### Method 2: Standalone NRO

1. Download `梦日记_standalone.nro` from the [Releases](https://github.com/Electr0Whale/nx-yumenikki/releases) page.
2. Copy `梦日记_standalone.nro` to `/switch/` on your microSD card.
3. Launch via the Homebrew Menu (holding R on an installed title for Title Override is recommended).

---

## Building from Source

### Prerequisites

- A Linux environment or Windows Subsystem for Linux (WSL2, Ubuntu recommended).
- **devkitPro** with the Nintendo Switch toolchain:
  - `devkitA64`
  - `libnx`
  - `switch-mesa`, `switch-glad`, `switch-libdrm_nouveau`
  - `switch-freetype`, `switch-harfbuzz`, `switch-libpng`, `switch-zlib`
  - `switch-mpg123`, `switch-libsamplerate`
- `liblcf` (v0.8.1) compiled for Nintendo Switch.
- `hacBrewPack` (v3.05 or newer).
- A valid `prod.keys` file placed in `keys/prod.keys`.
- Python 3.

### Build Steps

1. Clone this repository:
   ```bash
   git clone https://github.com/Electr0Whale/nx-yumenikki.git
   cd nx-yumenikki
   ```

2. Run the automated build and packaging pipeline:
   ```bash
   bash tools/build_nsp_v3.sh
   ```

3. Upon completion, the output binaries will be placed in `dist/`:
   - `dist/梦日记_v1.2.1.nsp`
   - `dist/梦日记_standalone.nro`

---

## Dependencies & Upstream Projects

This project relies on and integrates work from the following open-source projects and tools:

- [EasyRPG Player](https://easyrpg.org/) - RPG Maker 2000/2003 interpreter engine.
- [liblcf](https://github.com/EasyRPG/liblcf) - Library for parsing RPG Maker 2000/2003 game data.
- [devkitPro](https://devkitpro.org/) & [libnx](https://github.com/switchbrew/libnx) - Nintendo Switch homebrew development toolchain and libraries.
- [hacBrewPack](https://github.com/The-4n/hacBrewPack) - Nintendo Switch homebrew NCA/NSP packaging utility.
- [YNOproject](https://ynoproject.net/) & [ynotranslations](https://github.com/ynoproject/ynotranslations) - Community translations, multilingual assets, and color scheme references.
- [WenQuanYi Bitmap Song](http://wenq.org/) - Open-source 12px bitmap font for pixel-perfect CJK rendering.

---

## Credits & Acknowledgments

- **Kikiyama (ききやま)** - Original creator and author of *Yume Nikki*.
- **Enterbrain / Kadokawa** - Creator of RPG Maker 2003.
- **PLAYISM / AGM PLAYISM** - Official publisher of *Yume Nikki* on Steam.
- **The EasyRPG Team and Contributors** - For creating and maintaining the EasyRPG Player engine.
- **SwitchBrew & devkitPro Communities** - For Nintendo Switch homebrew research, documentation, and toolchains.
- **YNOproject Community & Translators** - For their dedicated work on game translations and preservation.

---

## License

EasyRPG Player is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html). *Yume Nikki* game assets remain the property of Kikiyama.
