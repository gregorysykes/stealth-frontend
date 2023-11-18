# Frontend

A Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

How to Use?
1. Install Flutter & Android Studio
2. Open Android Virtual Device (AVD)
3. Open Terminal and go to the directory of the codes
4. Run "flutter run"
5. Results

For this test, I made 2 modes: Offline Mode and Server Mode
Offline Mode:
1. User Registration data is saved locally in the app (FlutterSecureStorage)
2. Login, OTP is also saved locally
3. Every error/prompt is shown using print() function -> printed in the console

Server Mode:
1. Data is stored to a PostgreSQL database
2. Validation done 100% on backend
3. OTP is generated randomly and is only available for 30 seconds
4. Other steps to run the server is available on the backend git repo
