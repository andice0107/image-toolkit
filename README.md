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
| Windows (Intel Arc 內顯) | `git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git`，建 venv，`pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/xpu`，再 `pip install -r requirements.txt`，啟動加 `--use-pytorch-cross-attention` | 能跑但 CP 值低，見下方實測與結論 |
| Linux 雲端 | 沒有 GPU 時不建議 | CPU 太慢 |

Mac 實測：ComfyUI 0.43.0、PyTorch 2.15.0、偵測到 MPS（Apple GPU），後端 API 可回應；尚未下載任何模型、尚未實際生圖。
Windows 實測（2026-11-03，Intel UHD 770 那台）：本機僅有 Intel UHD Graphics 770，無 NVIDIA 顯卡（`nvidia-smi` 不存在），故未安裝 ComfyUI、未下載模型。

Windows 實測（2026-11-03，MSI Claw 8 AI+：Intel Core Ultra 7 258V、Arc 140V 內顯 16GB 共用、32GB RAM）：

- PyTorch 2.15.0+xpu 偵測到 Arc 顯卡（`torch.xpu.is_available()` 為 True），ComfyUI 可啟動並出圖。
- SDXL-Turbo（`sd_xl_turbo_1.0_fp16.safetensors`，約 6.5GB）：512×512、2 步，約 24 秒一張，畫質普通，動物臉部結構容易出錯。
- LTX-Video 2B（v0.9.5，需搭配 `t5xxl_fp8_e4m3fn_scaled.safetensors`，`CLIPLoader` 類型選 `ltxv`）：384×256、25 幀約 35 秒，畫面模糊、主體幾乎沒動。
- 結論：內顯上 CP 值低，使用機會也低，已全部移除（含 PyTorch 環境，共約 24GB）。需要 AI 插圖時優先用 Canva `generate-image` 或線上服務；設計圖、圖表、教材排版用第一節的程式化工具即可。
- 想挑戰更高畫質（SDXL 1.0、Flux）尚未實測，Arc 內顯能否負擔與耗時不確定。
- SDXL-Turbo 的授權我記得是個人／研究用途免費、商用需另購會員，未逐字核對最新條款，商用前請先到模型頁面確認。

啟動（Mac）：`cd ~/ComfyUI && ./venv/bin/python main.py`，開啟 http://127.0.0.1:8188 。
模型放在 `ComfyUI/models/checkpoints/`。**模型不在此包內**，下載前先確認授權，並徵得使用者同意（每個約 2–4GB）。

## 三、生圖的選擇

- **設計圖、圖表、排版、批次處理：** 用第一節的工具，不需 AI。
- **AI 生成圖片（最快）：** Claude 連接的 Canva 連接器有 `generate-image`，不用安裝。
- **風格控制或固定角色：** 用 ComfyUI 搭配合適的模型（需有 NVIDIA 顯卡或足夠算力；Intel Arc 內顯不建議，見第二節）。
- **版權：** 不生成有版權的現有角色（如多啦A夢、海賊王、咒術迴戰）。要日系動漫風，就設計原創角色。

## 四、一鍵安裝

- Mac：`bash install-mac.sh`
- Windows（PowerShell）：`.\install-windows.ps1`
- Linux：`bash install-linux.sh`

三個腳本都只裝第一節的工具；ComfyUI 因為體積大且需要使用者同意，不包含在內。

Windows 腳本補充（2026-11-03 實測）：

- 已安裝的項目會略過，不重複安裝。
- Inkscape 安裝後不會自動寫入 PATH，腳本會檢查後補進使用者 PATH；已存在就不重複寫入。
- venv 已存在就不重建，只補 Pillow。
- 結尾逐項驗證並印出結果；若顯示找不到指令，重開終端機後再跑一次。

## 五、給 agent 的最佳建議（精簡版）

完整版與 YouTuber 推薦流程見影片軟體包：https://github.com/andice0107/video-toolkit 第十、十一節。

- **先分清楚「程式化生成」與「AI 生成式影像」。** 使用者說生圖時，預設先用第一節的程式化工具（Pillow、Playwright、Inkscape、ImageMagick），能做圖表、教材、排版與向量圖；要寫實 AI 插圖才走 AI 生成。
- **要 AI 插圖：** 優先用 Canva `generate-image` 或線上服務；沒有 NVIDIA 顯卡的電腦（含 Intel 內顯）不要在本機裝 ComfyUI，MSI Claw 8 AI+ 實測 CP 值低（見第二節）。
- **先查硬體、先量空間、再徵得同意，才下載數 GB 的模型。**
- **交付前自己看過成品。** 不要把普通的結果說成品質不錯。
- 使用者提供的 YouTuber 流程（Blender、Node.js、FFmpeg、Remotion、three.js，由 Claude 寫程式做影片）是程式化生成，不是 AI 生成寫實影像，細節見影片軟體包第十節。

## 六、維護規則（給 agent）

- 新增或移除工具時，同步更新本表與安裝腳本，再更新日期。
- 多台同作業系統的電腦要分機型記錄，不要用新機器的結果覆寫舊機器的紀錄。
- 「狀態」欄只寫實測結果，沒測過就寫未驗證。
- 不要在此放金鑰、帳密、模型檔或個人檔案。
