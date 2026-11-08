```markdown
# Nintendo Switch Homebrew：RPG Maker 2003 游戏移植与封装指南

> 整理时间：2026-11-02  
> 基于 EasyRPG Player 及相关社区工具

---

## 1. 核心结论

**RPG Maker 2003 游戏在 Switch 上最推荐的运行方式是 EasyRPG Player**，而不是用 Wine / Autorun 直接运行原版 `RPG_RT.exe`。

EasyRPG Player 是专门重新实现 RPG Maker 2000 / 2003 引擎的开源解释器，直接解析游戏数据文件（`.ldb`、`.lmt`、`.lmu` 等），兼容性和性能都远优于兼容层方案。

---

## 2. 推荐运行方案对比

| 方案 | 适用场景 | 优点 | 缺点 | 推荐度 |
|------|----------|------|------|--------|
| **EasyRPG Player** | RPG Maker 2000/2003 游戏 | 原生支持、性能好、兼容性高、有设置菜单 | 仅支持 2000/2003 | ★★★★★ |
| Autorun / Wine-NX | 想直接跑原版 EXE | 理论上可跑任意 Windows 程序 | 性能差、兼容性不稳定、配置复杂 | ★★☆ |
| 串流（SkyNX 等） | 临时体验 | 无需移植 | 依赖 PC、有延迟 | ★★ |
| 真正原生重编译 | 几乎没有案例 | - | 工作量极大 | ★ |

---

## 3. EasyRPG Player 基础使用

### 安装

1. 下载最新版 EasyRPG Player for Switch（当前稳定版约 0.8.1.1）
   - 官方：https://easyrpg.org/player/downloads/
   - GameBrew / Homebrew App Store 也可获取
2. 解压到 SD 卡 `switch/easyrpg-player/` 目录
3. 把游戏文件夹（包含 `RPG_RT.ldb`）放入该目录
   - 多个游戏放子文件夹 → 启动后出现游戏浏览器
   - 单个游戏直接放在 nro 同目录 → 可实现直接启动

### RTP（运行时素材包）

如果游戏依赖官方 RTP：

- 2003 RTP → `switch/easyrpg-player/rtp/2003/`
- 2000 RTP → `switch/easyrpg-player/rtp/2000/`

### 默认按键映射（Switch）

| 按键 | 功能 |
|------|------|
| 方向键 / 左摇杆 | 移动 |
| A | 确认 |
| B / X / + | 取消 |
| Y | Shift |
| - | 重置游戏 |
| L | 显示 FPS |
| R | 快进 |
| ZL | 切换显示模式（4:3 带触摸 / 4:3 无触摸 / 16:9） |
| 触摸屏角落 | 数字键虚拟面板（部分游戏需要，如《梦日记》） |

> 0.8.0 版本后支持在设置菜单中重新映射按键。

---

## 4. 源码编译与游戏打包（PLAYER_BUNDLE）

官方支持把游戏直接打包进 NRO，实现“启动即进入指定游戏”。

### 关键要点

- 源码：https://github.com/EasyRPG/Player
- 构建文档：`docs/BUILDING.md`
- 需要 devkitA64 + libnx（通过 devkitPro 安装）

关键命令示例：

```bash
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=$DEVKITPRO/cmake/Switch.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DPLAYER_BUNDLE=ON \
  -DPLAYER_BUNDLE_PATH=/path/to/your/rpgmaker/game
```

生成的 `easyrpg-player.nro` 会内置游戏数据，启动后直接进入该游戏。

### 相关源码位置

- 平台相关：`src/platform/switch/`
- 输入系统：`src/input_*` 系列文件（输入系统在 0.8 前后有重构）
- 早期 Switch 输入实现参考：`switch_ui.cpp`（历史 PR）

---

## 5. 按键映射处理方式

优先级从高到低：

1. **运行时设置（推荐日常使用）**  
   EasyRPG 0.8+ 自带设置菜单，可重新映射按键，配置会保存。

2. **修改源码默认映射**  
   修改平台输入初始化代码后重新编译，适合做成“开箱即用”的定制版。

3. **配置文件 / 命令行**  
   部分功能支持，但完整控制器重映射在源码层面更直接。

---

## 6. NSP 封装（做成主屏幕可启动的游戏）

真正做成可安装的 NSP，社区主流是 **NRO → Forwarder NSP**，而不是完整独立 Title。

### 常用工具

| 工具                           | 说明                                        | 推荐度   |
| ---------------------------- | ----------------------------------------- | ----- |
| **Nro2Nsp**                  | 经典 NRO 转 NSP 工具，支持 Redirection 和 RomFS 模式 | ★★★★★ |
| **NSP Auto Installer Maker** | 图形界面，支持 Homebrew Forwarder + 自动复制游戏文件夹    | ★★★★  |
| **switch-nsp-forwarder**     | 直接在 Switch 上生成并安装 Forwarder               | ★★★   |
| Sphaira 等文件管理器内置功能           | 较新，操作方便                                   | ★★★   |

### 推荐流程（做成“主屏幕一个图标直接进游戏”）

1. 用官方 CMake + `PLAYER_BUNDLE=ON` 把目标游戏打进 NRO（或手动把游戏文件放在 NRO 同目录）。
2. 如需改默认按键，修改源码后重新编译。
3. 使用 **Nro2Nsp** 或 **NSP Auto Installer Maker** 生成 Forwarder NSP，自定义名称、图标、Title ID。
4. 安装 NSP 后，主屏幕点击即可启动。

> 注意：Forwarder NSP 本质上是“主屏幕图标 → 启动指定 NRO”，并不是把整个引擎+游戏完整嵌入成独立系统 Title。完整嵌入式 NSP 工作量较大，公开案例很少。

---

## 7. 已有参考案例

- **Link's Awakening Remake Demo + EasyRPG**：有人把特定 RPG Maker 2003 游戏与 EasyRPG 打包分发（GameBrew 有条目）。常见做法是游戏 + EasyRPG NRO + Forwarder。
- Wii 端有官方 Forwarder/Channel（`EasyRPG/Wii-Channel`），思路可参考，但 Switch 没有同等官方实现。
- 社区更多是“单游戏 + EasyRPG NRO + Forwarder NSP”的组合，大规模公开源码级封装案例较少。

---

## 8. 注意事项

- 仅支持 **RPG Maker 2000 / 2003**，不支持 XP / VX / VX Ace / MV / MZ。
- 部分使用大量特殊补丁（PicPointer、特殊战斗系统等）的游戏可能需要额外配置或存在小问题。
- 中文游戏建议确认编码设置（EasyRPG 支持手动指定代码页）。
- 存档保存在游戏文件夹内，兼容性较好。
- 高固件版本可能需要重新编译以适配新版 libnx。

---

## 9. 实用建议总结

| 需求                    | 推荐做法                                                                  |
| --------------------- | --------------------------------------------------------------------- |
| 自己玩多个游戏               | 官方 EasyRPG NRO + 游戏放对应目录                                              |
| 主屏幕一个图标直接进指定游戏        | PLAYER_BUNDLE 编译 NRO + Nro2Nsp / NSP Auto Installer Maker 做 Forwarder |
| 修改默认按键                | 优先用设置菜单；需要固化则改源码重新编译                                                  |
| 完整独立 NSP（无 Forwarder） | 工作量大，公开案例少，不推荐优先尝试                                                    |

---

## 参考链接

- EasyRPG 官网：https://easyrpg.org/
- 源码仓库：https://github.com/EasyRPG/Player
- 构建文档：https://github.com/EasyRPG/Player/blob/master/docs/BUILDING.md
- GameBrew Switch 页面：https://www.gamebrew.org/wiki/EasyRPG_Player_Switch
- Nro2Nsp：https://github.com/Root-MtX/Nro2Nsp
- NSP Auto Installer Maker：可在 GameBrew 搜索

---

*本文档整理自对话结论，仅供技术参考。使用 Homebrew 需自行承担风险。*
```
