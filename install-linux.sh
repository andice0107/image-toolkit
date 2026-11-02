#!/usr/bin/env bash
# Debian/Ubuntu。需要 sudo 權限。
set -e
sudo apt update
sudo apt install -y imagemagick librsvg2-bin inkscape python3-venv nodejs npm
mkdir -p ~/image-toolkit && cd ~/image-toolkit
python3 -m venv venv
./venv/bin/pip install pillow
npm init -y >/dev/null && npm i sharp playwright
npx playwright install --with-deps chromium
