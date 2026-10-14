☕ Brew Crew

A modern Flutter + Firebase coffee app built with realtime streams, clean architecture, and smooth user experience.

✨ Preview
Authentication → Realtime Brew Feed → Live Preference Updates

Brew Crew is a minimalist coffee-themed mobile application where users can create an account, manage their brew preferences, and sync everything instantly with Firebase.

Built using:

Flutter
Firebase Auth
Cloud Firestore
Provider
Stream-based architecture
🚀 Features
🔐 Authentication
Email & password sign up
Secure login system
Persistent auth sessions
☁️ Cloud Firestore
Realtime database updates
User-specific brew data
Stream-powered UI refreshes
☕ Brew Personalization

Each user can customize:

Name
Sugar amount (0–4)
Brew strength (100–900)
🎨 Modern UI
Coffee-inspired design
Smooth bottom sheet settings
Clean responsive layout
Loading animations with flutter_spinkit
🧠 Tech Stack
Flutter
Firebase Core
Firebase Authentication
Cloud Firestore
Provider
flutter_spinkit
📂 Project Structure

lib/
│
├── models/
│   ├── brew.dart
│   └── user.dart
│
├── screens/
│   ├── authenticate/
│   ├── home/
│   └── wrapper/
│
├── services/
│   ├── auth.dart
│   └── database.dart
│
├── shared/
│   ├── constants.dart
│   ├── loading.dart
│   └── widgets/
│
└── main.dart

🔥 Firebase Configuration

1️⃣ Create Firebase Project

Open Firebase Console and create a new project.

https://console.firebase.google.com/
2️⃣ Add Android App

Add your Flutter Android package name.

Example:

com.example.brewcrew

Download:

google-services.json

Move it into:

android/app/

3️⃣ Enable Authentication

Firebase Console
→ Authentication
→ Sign-in Method
→ Email/Password
→ Enable

For Android authentication, also add the signing fingerprints for the app registered
as `com.example.pprojec`. For a local debug build, run:

```bash
cd android
./gradlew signingReport
```

In Firebase Console, open **Project settings → Your apps → Android app →
Add fingerprint** and add the reported SHA-1 and SHA-256 values. Then download
the refreshed `google-services.json` into `android/app/` and rebuild the app.
Without the enabled Email/Password provider or the matching fingerprints,
Firebase Auth can fail with `CONFIGURATION_NOT_FOUND` during registration.

4️⃣ Sign release builds

Release APKs must be signed with a non-debug keystore before distribution.
Create `android/key.properties` with these entries:

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=app/upload-keystore.jks
```

Keep `key.properties` and the keystore private. Build ABI-specific release
APKs with:

```bash
flutter build apk --release --split-per-abi
```

5️⃣ Create Firestore Database

Firestore Database
→ Create Database
→ Start in Test Mode
📦 Installation

Clone the repository:

git clone https://github.com/amer-kriany/BrewCrew

Go into the project:

cd brew-crew

Install dependencies:

flutter pub get

Run the app:

flutter run

🧱 Data Models

Brew Model
class Brew {
  final String name;
  final String sugars;
  final int strength;

  Brew({
    required this.name,
    required this.sugars,
    required this.strength,
  });
}
UserData Model
class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({
    required this.uid,
    required this.name,
    required this.sugars,
    required this.strength,
  });
}
⚡ App Flow
Login/Register
        ↓
Realtime Brew List
        ↓
Settings Bottom Sheet
        ↓
Firestore Update
        ↓
Automatic UI Refresh
🎯 Why This Project?

Brew Crew is a great project for learning:

Firebase Authentication
Firestore realtime streams
Provider state management
Flutter architecture
Form handling
Bottom sheets
Clean UI design

Perfect for intermediate Flutter developers who want a real Firebase project.

Contributions are welcome.

Fork → Create Branch → Commit → Pull Request
⭐ Support

If you like this project:

Give it a ⭐ on GitHub
Share it with other Flutter developers
Improve it and build your own version
📄 License

MIT License © 2026 Brew Crew