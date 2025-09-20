
CHUENLAY Belajar - Flutter Skeleton (Starter)
============================================

This is a starter Flutter project that loads offline_data.json and provides a minimal UI for:
- Dashboard (Materi, Soal, Sunda, Komik)
- Loading offline data from assets/offline_data.json
- Points demo and profile persistence via SharedPreferences

How to build APK:
1. Install Flutter SDK: https://flutter.dev/docs/get-started/install
2. Unzip this project and open folder in terminal.
3. Run: flutter pub get
4. Run on device: flutter run  (or use VS Code / Android Studio)
5. To build release APK: flutter build apk --release
6. Replace assets/images/*.png and assets/audio/* with real assets later.
7. Integrate online sync, ChatGPT proxy, YouTube WebView, and other features as per THUNKABLE_INSTRUCTIONS.md provided earlier.

Notes:
- This skeleton is a starting point. It includes simple UI and logic; please expand and style as desired.
- The app uses Provider for state and SharedPreferences for simple local storage.
