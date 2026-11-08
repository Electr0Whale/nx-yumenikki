# 打包工具与构建辅助脚本 (`tools/`)

本目录包含 Nintendo Switch NSP/NRO 打包、元数据修补与单元测试工具。

## 工具清单与状态

| 文件 / 目录 | 状态 | 职责与说明 |
|:---|:---|:---|
| **`build_nsp_v3.sh`** | **当前主力** | 一键全自动化构建流水线：包含资产同步、单元测试、交叉编译、NSO/NRO 生成、NACP 修补与 `hacBrewPack v3.05` 打包 NSP。 |
| **`patch_nacp.py`** | **当前主力** | 核心属性修补工具：向 `control.nacp` 写入 `StartupUserAccount = 1`（启动选人）及 16MB/32MB 机身 NAND 存档配额。 |
| **`build_npdm.py`** | **当前主力** | 生成现代 HOS 20+ 合规的 NPDM JSON（含 `system_resource_size: 0x0` 与 80+ 个合法系统调用权限）。 |
| **`tests/test_input_mapping.cpp`** | **当前主力** | `SwitchInput::ApplyPad` 输入映射与双向松手锁存防误触单元测试（主机端 C++17 纯单元测试）。 |
| `test_npdm.py` | 辅助脚本 | NPDM 结构静态解析与校验辅助工具。 |
| `build_v2.sh` | 历史归档 | Interim2 开发过程中的打包中间脚本（已被 `build_nsp_v3.sh` 继承）。 |
| `Nro2Nsp-master/` | 历史归档 | 早期 Nro2Nsp 3.3.6 工具源码（已退役，本项目已全面转向原生的 `hacBrewPack v3.05` 现代化打包体系）。 |
