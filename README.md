# 圖片生成軟體包 (Image Generation Toolkit)

給所有 agent 與各台電腦（macOS / Windows / Linux 雲端）共用的圖片處理與生圖工具。
搭配影片軟體包使用：https://github.com/andice0107/video-toolkit
GitHub：https://github.com/andice0107/image-toolkit
最後更新：2026-11-03。「Mac 狀態」與「Windows 狀態」欄為實測結果，其餘平台的指令尚未實測。

## 一、圖片處理工具（不需 GPU）

| 工具 | 用途 | Mac | Windows | Linux (apt) | Mac 狀態 | Windows 狀態 |
|---|---|---|---|---|---|---|
| ImageMagick | 縮放、裁切、合成、轉檔 | `brew install imagemagick` | `winget install --id ImageMagick.ImageMagick -e` | `sudo apt install imagemagick` | 7.1.2 已裝 | 7.1.2-34 已裝 |
| librsvg | SVG 轉 PNG（`rsvg-convert`） | `brew install librsvg` | 改用 Inkscape 或 sharp | `sudo apt install librsvg2-bin` | 2.63.4 已裝 | 未裝（改用 Inkscape／sharp） |
| Inkscape | 向量圖編輯與轉檔 | `brew install --cask inkscape` | `winget install --id Inkscape.Inkscape -e` | `sudo apt install inkscape` | 1.4.4 已裝 | 1.4.4 已裝 |
| Python 3.12 | Pillow、ComfyUI 的執行環境 | `brew install python@3.12` | `winget install --id Python.Python.3.12 -e` | `sudo apt install python3.12 python3.12-venv` | 3.12.16 已裝 | 3.12.10 已裝 |
| Pillow | 程式化畫圖、加文字、拼圖 | `python3.12 -m venv venv && venv/bin/pip install pillow` | `py -3.12 -m venv venv; venv\Scripts\pip install pillow` | 同 Mac | 13.0.0 已裝 | 13.0.0 已裝（`%USERPROFILE%\image-toolkit\venv`；全域 12.3.0） |
| sharp | Node 高速圖片處理 | `npm i sharp` | `npm i sharp` | `npm i sharp` | 已裝 | 已裝（`%USERPROFILE%\image-toolkit`） |
| Playwright | 把 HTML/SVG 排版截成 PNG | `npm i playwright && npx playwright install chromium` | 同左 | 同左，另需 `npx playwright install-deps` | 已裝 | 已裝（chromium-1248） |

註：新版 macOS 的 Homebrew Python 受 PEP 668 限制，不能直接 `pip install`，一律用 venv。

## 二、本機 AI 生圖：ComfyUI

| 平台 | 安裝 | 備註 |
|---|---|---|
| Mac (Apple Silicon) | `git clone https://github.com/comfyanonymous/ComfyUI.git ~/ComfyUI`，建 venv，`pip install torch torchvision torchaudio`，再 `pip install -r requirements.txt` | 8GB 記憶體只能跑 SD 1.5 級模型；Flux 等大模型不建議 |
| Windows (NVIDIA) | 用官方 Windows portable 版，或同上流程搭配 CUDA 版 PyTorch | 需要 NVIDIA 顯卡 |
| Linux 雲端 | 沒有 GPU 時不建議 | CPU 太慢 |

Mac 實測：ComfyUI 0.43.0、PyTorch 2.15.0、偵測到 MPS（Apple GPU），後端 API 可回應；尚未下載任何模型、尚未實際生圖。
Windows 實測（2026-11-03）：本機僅有 Intel UHD Graphics 770，無 NVIDIA 顯卡（`nvidia-smi` 不存在），故未安裝 ComfyUI、未下載模型。

啟動（Mac）：`cd ~/ComfyUI && ./venv/bin/python main.py`，開啟 http://127.0.0.1:8188 。
模型放在 `ComfyUI/models/checkpoints/`。**模型不在此包內**，下載前先確認授權，並徵得使用者同意（每個約 2–4GB）。

## 三、生圖的選擇

- **設計圖、圖表、排版、批次處理：** 用第一節的工具，不需 AI。
- **AI 生成圖片（最快）：** Claude 連接的 Canva 連接器有 `generate-image`，不用安裝。
- **風格控制或固定角色：** 用 ComfyUI 搭配合適的模型。
- **版權：** 不生成有版權的現有角色（如多啦A夢、海賊王、咒術迴戰）。要日系動漫風，就設計原創角色。

## 四、一鍵安裝

- Mac：`bash install-mac.sh`
- Windows（PowerShell）：`.\install-windows.ps1`
- Linux：`bash install-linux.sh`

三個腳本都只裝第一節的工具；ComfyUI 因為體積大且需要使用者同意，不包含在內。

## 五、維護規則（給 agent）

- 新增或移除工具時，同步更新本表與安裝腳本，再更新日期。
- 「狀態」欄只寫實測結果，沒測過就寫未驗證。
- 不要在此放金鑰、帳密、模型檔或個人檔案。
