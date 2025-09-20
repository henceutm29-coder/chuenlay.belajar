
OpenAI Proxy README
-------------------

Purpose:
- The proxy forwards client requests to OpenAI while keeping the OpenAI API key on the server side.
- This prevents distributing the API key inside the APK.

Setup:
1) Copy .env.example to .env and fill OPENAI_API_KEY and API_KEY_CLIENT.
2) Install dependencies: npm install express axios dotenv cors
3) Start server: node server.js (or use pm2 / systemd for production)
4) Secure the server: restrict access via HTTPS, add rate limiting, and consider IP allowlist.
5) In the Thunkable app, set Web API URL to https://yourserver.example.com/api/chat
   Send header 'x-client-key' with the API_KEY_CLIENT value.

Security Notes:
- Do NOT commit your .env to public repos.
- Use HTTPS and proper auth for production.
- Monitor usage to avoid unexpected charges.
