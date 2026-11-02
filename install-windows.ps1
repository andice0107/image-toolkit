# 以 PowerShell 執行；安裝後請重開終端機讓 PATH 生效。
winget install --id ImageMagick.ImageMagick -e
winget install --id Inkscape.Inkscape -e
winget install --id Python.Python.3.12 -e
winget install --id OpenJS.NodeJS.LTS -e
New-Item -ItemType Directory -Force "$HOME\image-toolkit" | Out-Null
Set-Location "$HOME\image-toolkit"
py -3.12 -m venv venv
.\venv\Scripts\pip install pillow
npm init -y | Out-Null
npm i sharp playwright
npx playwright install chromium
