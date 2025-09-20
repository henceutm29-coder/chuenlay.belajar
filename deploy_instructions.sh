#!/bin/bash
# Deploy instructions for CHUENLAY Belajar proxy

# 1. Init Git repo
git init
git add .
git commit -m "Initial commit for CHUENLAY proxy"

# 2. Add GitHub remote (ganti <username> dan <repo>)
git remote add origin https://github.com/<username>/<repo>.git
git branch -M main
git push -u origin main

echo "Repo pushed. Sekarang buka Render.com -> New Web Service -> pilih repo ini."
