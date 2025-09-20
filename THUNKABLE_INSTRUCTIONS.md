
CHUENLAY Belajar - Thunkable Setup Instructions (Step-by-step)
--------------------------------------------------------------

1) Prepare
- Create a free Thunkable account at https://thunkable.com and login.
- Download the assets folder or have the CSV files and offline_data.json ready.

2) Create Project
- New Project -> name: CHUENLAY Belajar
- Set global theme: gradient background (blue -> purple), custom font if desired.

3) Add Screens
- Add screens: Splash, Home, Materi, Soal, Sunda, Komik, Music, Chat, Profile, Rewards, MiniGame.
- Add a persistent header component: image (profile), labels (name, class, progress).

4) Storage Components
- Add LocalDB / LocalStorage component for offline data.
- Add Web API components: one for fetching published Google Sheets JSON/CSV, one for proxy ChatGPT endpoint.

5) Import Offline Data
- Upload offline_data.json to Thunkable assets.
- On Splash.start: call LocalDB.set('offline_data', loadAsset('offline_data.json')) or parse JSON into local variables.

6) Sync Online
- Use Web API to GET your published Google Sheet CSV/JSON URL.
- On success, merge and update LocalDB keys (materials, soal, vocab, comics).
- Always fallback to local data if offline.

7) Bank Soal Logic
- Use List Viewer to show questions.
- On selecting answer -> check against 'jawaban' -> update score, show animation, increment user points.
- For Simulasi mode: implement timer using Clock component; at timeout, auto-submit and show results.

8) ChatGPT Integration (via proxy)
- In Settings screen, allow admin to input `client_key` (the key to call your proxy).
- When user sends chat message, POST to your proxy endpoint '/api/chat' with JSON { "prompt": "<user message>" } and header 'x-client-key': CLIENT_KEY
- Parse response.data.choices[0].message.content and append to chat UI.

9) Music & YouTube
- Use Audio component for mp3 playback. For streaming links, test CORS and compatibility.
- For YouTube, use WebViewer to open video URL.

10) Avatar & Animations
- Add floating avatar image; onClick show motivational bubble (Label or Dialog).
- Use Lottie (if available) or animated GIFs for transitions.

11) Reward System
- Maintain user.poin in LocalDB. Update on events (finish bab, correct answer...).
- Create Shop screen to redeem items for points (toggle flags in LocalDB for unlocked items).

12) Export & Test
- Test thoroughly in Thunkable Live app on device.
- Export signed APK when ready.

Notes:
- Do NOT store OpenAI API key in the client app. Use the proxy approach for security.
- Large images (comics) are best hosted online (CDN or Google Drive public link) to reduce APK size.
