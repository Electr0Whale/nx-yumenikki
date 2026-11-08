# 构建调试与桌面自动化测试工具集 (`build/`)

本目录主要包含早期在 Linux/WSL 环境下使用 Xvfb + xdotool 进行无头/桌面端 EasyRPG Player 自动化冒烟测试、窗口探针与输入回放脚本，供开发调试与自动化测试参考。

## 文件索引

- **`run_host_test.sh`**：在虚拟帧缓冲（Xvfb）中拉起 Linux 静态版 EasyRPG Player 并挂载 `work/game` 进行自动化冒烟测试与截图。
- **`run_host_nav.sh` / `run_host_interact.sh`**：模拟键盘输入导航到游戏新游戏/读档界面，验证标题与菜单交互。
- **`test_inputs.sh` / `test_inputs2.sh` / `test_inputs3.sh`**：xdotool 自动化键盘按键序列回放脚本。
- **`inspect_window.sh`**：使用 `xdotool` 与 `xwininfo` 检查 EasyRPG Player 窗口标题、ID 及几何属性。
- **`env.sh`**：构建与运行环境变量配置样例。
- **`source-manifest.csv`**：梦日记 0.10 原版 749 个游戏文件的大小、路径与 MD5/SHA 清单，用于对比资产完整性。
- **`icon.jpg`**：早期测试图标暂存。

> 注：正式 Switch NSP 打包请使用 `tools/build_nsp_v3.sh`，单元测试请使用 `tools/tests/test_input_mapping.cpp`。
