# CHUENLAY Belajar - Proxy Deployment Guide

## 1. Persiapan
- Install Node.js & npm
- Install Git
- Buat akun GitHub + Render (atau Railway/Replit)

## 2. Push ke GitHub
```bash
chmod +x deploy_instructions.sh
./deploy_instructions.sh
```

## 3. Deploy ke Render
- New Web Service
- Connect GitHub repo
- Build Command: `npm install`
- Start Command: `node server.js`
- Tambah Environment Variables:
  - `OPENAI_API_KEY=sk-xxxxx`
  - `API_KEY_CLIENT=your_client_key`
  - `OPENAI_MODEL=gpt-4o-mini`

## 4. Tes Proxy
```bash
curl -X POST https://your-proxy.onrender.com/api/chat   -H "Content-Type: application/json"   -H "x-client-key: your_client_key"   -d '{"prompt":"Halo, tes"}'
```

Jika berhasil, response akan berupa JSON dari OpenAI.
