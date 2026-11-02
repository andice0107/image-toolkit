#!/usr/bin/env bash
set -e
command -v brew >/dev/null || { echo "請先安裝 Homebrew: https://brew.sh"; exit 1; }
brew install imagemagick librsvg python@3.12 node
[ -d /Applications/Inkscape.app ] || brew install --cask inkscape
mkdir -p ~/image-toolkit && cd ~/image-toolkit
/opt/homebrew/opt/python@3.12/bin/python3.12 -m venv venv
./venv/bin/pip install pillow
npm init -y >/dev/null && npm i sharp playwright && npx playwright install chromium
magick -version | head -1
./venv/bin/python -c "import PIL; print('Pillow', PIL.__version__)"
