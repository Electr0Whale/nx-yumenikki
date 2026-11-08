# Yume Nikki (梦日记) - Nintendo Switch 中文完整自包含移植版

![License](https://img.shields.io/badge/license-GPLv3%20%2F%20Freeware-blue)
![Platform](https://img.shields.io/badge/platform-Nintendo%20Switch-e60012)
![Status](https://img.shields.io/badge/status-Completed-brightgreen)

经典探险解谜 RPG 游戏《梦日记》（Yume Nikki 0.10 简体中文版）面向 Nintendo Switch 平台的现代化高画质、全键位适配、官方机身 NAND 存档的自包含（Self-Contained）原生移植版本。

基于 [EasyRPG Player](https://easyrpg.org/) 引擎核心，深度重构 Switch 平台输入系统、显示管线及 HOS 系统服务集成，支持通过 **DBI** 独立安装至主机桌面运行，无需前置安装 RetroArch、hbmenu 或 EasyRPG 通用前端。

> [!IMPORTANT]
> **后续接手与开发者必读**：本项目全景架构设计、机身 NAND 存档事务原理、按键锁存算法、全量贴图重绘说明及故障排查手册，请详见 **[项目核心接手文档 (HANDOVER.md)](HANDOVER.md)**。

---

## 🌟 移植特性

1. **官方级独立 NSP 体验**
   - 独立 Title ID（`0100A1B2C3D40000`），采用官方最新 `hacBrewPack v3.05` 重构打包，完全合规 HOS 20+ / Atmosphère 现代 Loader 签名及 NPDM 权限配置。
   - 随游戏内置完整 256×256 高清点阵风格图标（支持简中/繁中/英文多区域控制元数据）。

2. **官方机身 NAND 账户存档方案（零 SD 卡污染）**
   - 开启 HOS 官方 `StartupUserAccount = Required` 机制：从主界面点击图标启动游戏时自动拉起系统 **“由谁游玩？”** 账户选择器。
   - 游戏存档（`save:/Save01.lsd` ~ `Save15.lsd`）与引擎配置（`save:/easyrpg.ini`）直接写入 Switch 机身 NAND 用户加密存档分区。
   - 每次写日记保存、修改设置或退出游戏时自动执行 `fsdevCommitDevice("save")` 事务日志落盘，防止断电或意外退出丢档。
   - 完全兼容 Switch 系统的 **数据管理 $\rightarrow$ 管理保存数据**，支持使用 **JKSV**、**Checkpoint** 或 **DBI** 查看与备份还原。

3. **原生 3× / 4× 完美等比整数点阵缩放**
   - 原版 320×240 分辨率输出，在 Switch **掌机模式 (720p)** 采用严格 **3× 等比整数缩放 (960×720)** 居中显示；在 **底座模式 (1080p)** 采用 **4× 等比整数缩放 (1280×960)** 居中显示。
   - 四周纯黑填充背景，零模糊、零拉伸形变，锁定触屏与移动端虚拟按键，提供极致纯净的怀旧点阵观感。

4. **全面 Switch 掌机手柄操作优化**
   - 针对附子醒来、丢弃效果、效果特殊动作及 NASU 小游戏进行了防误触防粘滞优化。
   - **新增开屏专属手柄「操作指南」画面（`Picture/SwitchKeyGuide.xyz`）**：点击“开始游戏”时最先呈现高精度纯点阵操作图解，采用严格 1-bit Mono 丁卯点阵体（10px 规格 / 9×9 字形无损映射）与原版三色渐变欧式描边，完美契合原版美术风格。
   - **游戏内所有 7 张教学与说明贴图（`Picture/*.xyz`）全量重新绘制为 Switch 实体按键提示**（支持包括 NASU 外框与标题画面）。

---

## 🎮 手柄按键对照表

| 按键 / 组合键 | 映射游戏动作 | 功能说明 |
|:---|:---|:---|
| **左摇杆 / 十字键 (D-Pad)** | 移动 / 光标方向 | 附子上下左右走动与菜单光标移动 |
| **A 键** | 调查 / 决定 (`DECISION`) | 对话、调查房间/物品、确定保存 |
| **B 键** | 取消 / 返回 (`CANCEL`) | 取消选择、退出小游戏、关闭菜单 |
| **Plus (+) 键** | **呼出游戏菜单 (`CANCEL`)** | 随时开启/关闭梦日记效果物品栏菜单 |
| **R 键** | **奔跑 / 加速 (`SHIFT`)** | 骑自行车加速或特殊奔跑 |
| **X 键** | **捏脸醒来 (`N9`)** | 掐附子的脸，从梦境中醒来回到现实房间 |
| **Y 键** | **丢弃效果 (`N5`)** | 在门的房间内丢弃当前装备的效果 |
| **L + A** | **效果特殊动作 1 (`N1`)** | 触发当前效果的主动技能 1（内置松手锁存防误触） |
| **L + B** | **效果特殊动作 2 (`N3`)** | 触发当前效果的主动技能 2（内置松手锁存防误触） |
| **ZR 键** | 快进游戏 (`FAST_FORWARD`) | 按住后以多倍速快进探索节奏 |
| **Minus (-) 键** | **EasyRPG 系统设置菜单** | 调整全局音量、音频渲染器配置 |

> **组合键防误触保护**：按住 `L` 键时，独立的 A 与 B 按键动作会被完全抑制，仅响应特殊动作 1/2，松开 `L` 键后附带防粘滞锁存，杜绝误触发调查或取消。

---

## 📦 安装与使用指南

### 方式一：NSP 桌面安装（推荐）
1. 在 [Releases 页面](https://github.com/Electr0Whale/YumeNikki-Nx/releases) 下载 `梦日记_interim2.nsp`。
2. 连接 Switch 至电脑，使用 **DBI**（推荐通过 MTP 模式直接拖入 `5: MicroSD install` 或 `4: NAND install`）或使用 Awoo-Installer / Tinfoil 进行安装。
3. 返回 Switch 主界面，点击《梦日记》图标，在系统弹出的“由谁游玩？”中选择你的玩家档案即可畅玩。

> [!TIP]
> **旧 SD 存档迁移**：若您之前曾通过 SD 卡模式运行过并留存有 `sdmc:/switch/yumenikki-nx/save/Save01.lsd`，可在安装新版并至少运行一次后，通过 **DBI -> Browse saves** 或 **JKSV** 将旧存档导入至《梦日记》的专属 NAND 空间。

### 方式二：独立 NRO 运行
1. 下载 `梦日记_standalone.nro`，放置在 Switch TF 卡的 `/switch/` 目录下。
2. 进入相册（hbmenu，建议使用 Title Override 模式获取完整内存权限），选中《梦日记》启动。

---

## 🛠️ 项目结构与本地构建

```text
YumeNikki-Nx/
├── HANDOVER.md                             # 核心接手与全景开发文档 (必读)
├── README.md                               # 项目主说明文档
├── dist/                                   # 预编译 Release NSP / NRO 交付包
├── docs/                                   # 历史会话记录与技术调研文档
├── keys/                                   # 打包密钥 (本地专用，不入库)
├── patches/
│   └── easyrpg-player-yumenikki-nx.patch   # 核心引擎源码修改补丁 (37KB)
├── tools/
│   ├── build_nsp_v3.sh                     # 自动化全流程构建与打包脚本
│   ├── build_npdm.py                       # NPDM JSON 描述符构建
│   ├── patch_nacp.py                       # NACP 官方 NAND 存档属性修补脚本
│   └── tests/                              # 输入映射与防误触单元测试
├── work/
│   ├── icon_256.jpg                        # 256x256 高清点阵游戏图标
│   └── patched_picture/                    # 重绘后的 8 张 Switch 专用点阵图 (.xyz)
└── yumenikki0.10chs/                       # 梦日记简体中文原版资产与资源
```

### 从源码编译流程
1. **环境准备**：
   - 安装 [devkitPro](https://devkitpro.org/)（包含 `devkitA64`、`libnx`、`switch-tools`、`switch-sdl2` 等依赖库）。
   - Linux 环境（或 Windows WSL2 Ubuntu）。
2. **应用源码补丁**：
   ```bash
   tar -xzf easyrpg-player-0.8.1.1.tar.gz
   cd easyrpg-player-0.8.1.1
   patch -p1 < ../patches/easyrpg-player-yumenikki-nx.patch
   ```
3. **打包生成 NSP**：
   ```bash
   bash tools/build_nsp_v3.sh
   ```

---

## 📜 鸣谢与版权声明

- **游戏原作**：ききやま (KIKIYAMA)
- **中文汉化**：梦日记贴吧汉化组
- **引擎支持**：[EasyRPG Player Team](https://github.com/EasyRPG/Player) (GPL-3.0)
- **打包工具**：[hacBrewPack](https://github.com/The-4n/hacBrewPack) by The-4n
- **移植维护**：Electr0Whale
