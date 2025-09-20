
// server.js - Simple proxy for OpenAI requests (do NOT expose this without auth!)
// Install: npm init -y && npm install express axios dotenv cors
// Run: node server.js
require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());

// Simple API key check (set API_KEY_CLIENT in .env to control access)
const CLIENT_KEY = process.env.API_KEY_CLIENT || 'changeme_client_key';

app.post('/api/chat', async (req, res) => {
  try {
    const clientKey = req.headers['x-client-key'] || req.body.client_key;
    if (!clientKey || clientKey !== CLIENT_KEY) {
      return res.status(401).json({ error: 'Unauthorized: invalid client key' });
    }
    const prompt = req.body.prompt;
    if (!prompt) return res.status(400).json({ error: 'Missing prompt' });

    // Forward to OpenAI
    const openaiKey = process.env.OPENAI_API_KEY;
    if (!openaiKey) return res.status(500).json({ error: 'Server misconfigured: missing OPENAI_API_KEY' });

    const response = await axios.post('https://api.openai.com/v1/chat/completions', {
      model: process.env.OPENAI_MODEL || 'gpt-4o-mini',
      messages: [
        { role: 'system', content: 'Kamu adalah asisten tutor ramah yang menjelaskan singkat, jelas, dan sopan.' },
        { role: 'user', content: prompt }
      ],
      max_tokens: 400
    }, {
      headers: {
        'Authorization': `Bearer ${openaiKey}`,
        'Content-Type': 'application/json'
      }
    });

    const assistant = response.data;
    res.json(assistant);
  } catch (err) {
    console.error(err && err.response ? err.response.data || err.message : err);
    res.status(500).json({ error: 'Proxy error', details: err && err.response ? err.response.data : err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log('Proxy server running on port', PORT));
