# 以 PowerShell 執行；已安裝的會略過。安裝後請重開終端機讓 PATH 生效。
$ErrorActionPreference = 'Continue'

function Ensure-UserPath([string]$PathToAdd) {
    if (-not (Test-Path -LiteralPath $PathToAdd)) { return }
    $parts = [Environment]::GetEnvironmentVariable('PATH', 'User') -split ';' | Where-Object { $_ -ne '' }
    if ($parts -notcontains $PathToAdd) {
        [Environment]::SetEnvironmentVariable('PATH', (($parts + $PathToAdd) -join ';'), 'User')
        Write-Host "已加入使用者 PATH：$PathToAdd"
    }
    if (($env:PATH -split ';') -notcontains $PathToAdd) { $env:PATH = "$($env:PATH);$PathToAdd" }
}

# 系統工具
if (-not (Get-Command magick   -ErrorAction SilentlyContinue)) { winget install --id ImageMagick.ImageMagick -e --accept-package-agreements --accept-source-agreements }
if (-not (Get-Command inkscape -ErrorAction SilentlyContinue)) { winget install --id Inkscape.Inkscape -e --accept-package-agreements --accept-source-agreements }
if (-not (Get-Command py -ErrorAction SilentlyContinue) -and -not (Get-Command python -ErrorAction SilentlyContinue)) {
    winget install --id Python.Python.3.12 -e --accept-package-agreements --accept-source-agreements
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { winget install --id OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements }

# Inkscape 的安裝程式不會自動寫入 PATH，這裡補上
Ensure-UserPath 'C:\Program Files\Inkscape\bin'

# Python 端
New-Item -ItemType Directory -Force "$HOME\image-toolkit" | Out-Null
Set-Location "$HOME\image-toolkit"
if (-not (Test-Path '.\venv\Scripts\python.exe')) { py -3.12 -m venv venv }
if (Test-Path '.\venv\Scripts\pip.exe') { .\venv\Scripts\pip install pillow }

# Node 端
if (-not (Test-Path '.\package.json')) { npm init -y | Out-Null }
npm i sharp playwright
npx playwright install chromium

# 驗證（找不到通常是 PATH 還沒進到這個終端機，重開即可）
Write-Host '--- 驗證 ---'
foreach ($c in @(
        @('magick', @('-version')),
        @('inkscape', @('--version')),
        @('py', @('-3.12', '--version')),
        @('node', @('-v'))
    )) {
    $name = $c[0]
    if (Get-Command $name -ErrorAction SilentlyContinue) {
        $out = & $name @($c[1]) 2>&1 | Select-Object -First 1
        Write-Host ("{0,-9} {1}" -f $name, $out)
    } else {
        Write-Host ("{0,-9} 未找到，請重開終端機後再驗證" -f $name)
    }
}
