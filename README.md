☕ Brew Crew

A modern Flutter + Firebase application for managing personalized coffee brew preferences with real-time cloud sync.

📱 Overview

Brew Crew is a clean and simple Flutter mobile application that demonstrates authentication, real-time Firestore integration, and state management using Provider.

Users can:

Create an account or sign in
View a live list of coffee brews
Customize their brew preferences
Update profile settings in real time
Sync data securely with Firebase

The project follows a scalable Flutter architecture and is perfect for learning:

Firebase Authentication
Cloud Firestore
Stream-based state management
Flutter UI composition
Provider architecture
✨ Features
🔐 Email & Password Authentication
☁️ Cloud Firestore Integration
⚡ Real-time Data Streams
👤 User-specific Brew Preferences
🎛️ Bottom Sheet Settings Panel
☕ Coffee-themed Modern UI
⏳ Loading Indicators using flutter_spinkit
🧠 Provider State Management
📱 Responsive Mobile Layout
🛠️ Tech Stack
Technology	Purpose
Flutter	Cross-platform mobile framework
Firebase Core	Firebase initialization
Firebase Auth	User authentication
Cloud Firestore	Realtime database
Provider	State management
flutter_spinkit	Loading animations
🧱 Architecture

The app follows a layered Flutter architecture:

lib/
├── models/
├── screens/
│   ├── authentication/
│   ├── home/
│   └── wrapper/
├── services/
├── shared/
└── main.dart
📂 Data Models
Brew

Represents a coffee brew item shown in the home screen.

class Brew {
  final String name;
  final String sugars;
  final int strength;
}
UserData

Stores user-specific preferences in Firestore.

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;
}
🔄 User Flow
Authentication
      ↓
Home Screen (Brew List)
      ↓
Settings Bottom Sheet
      ↓
Update Firestore Data
      ↓
Realtime UI Refresh
🔥 Firebase Setup
1. Create Firebase Project

Go to:

https://console.firebase.google.com/

Create a new Firebase project.

2. Add Android App

Register your Android package name.

Example:

com.example.brewcrew

Download:

google-services.json

Place it inside:

android/app/
3. Enable Authentication

In Firebase Console:

Authentication → Sign-in method → Email/Password → Enable
4. Create Firestore Database
Firestore Database → Create Database

Start in test mode for development.

5. Install Dependencies
dependencies:
  flutter:
    sdk: flutter

  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  provider: ^latest
  flutter_spinkit: ^latest

Run:

flutter pub get
▶️ Running the Project
Clone the repository
git clone https://github.com/your-username/brew-crew.git
Navigate into the project
cd brew-crew
Run the app
flutter run
📸 Screenshots
Authentication	Home Screen	Settings
Login & Register UI	Live Brew List	Update Brew Preferences

Add your screenshots here later.

☕ Brew Settings

Users can customize:

Setting	Range
Sugars	0 – 4
Strength	100 – 900

Changes update instantly in Firestore and reflect in the UI through streams.

🧠 Learning Goals

This project is excellent for practicing:

Firebase Authentication workflows
Firestore CRUD operations
StreamProvider & reactive UI
Flutter form validation
Clean project structure
Stateful + Stateless widget patterns
🚀 Future Improvements
🌙 Dark Mode
🖼️ Profile Pictures
🔔 Push Notifications
📊 Brew Analytics
🌐 Multi-language Support
🍎 iOS Optimization
🧪 Unit & Widget Testing
🤝 Contributing

Pull requests are welcome.

If you'd like to improve the project:

Fork the repository
Create a feature branch
Commit your changes
Open a pull request
📜 License

This project is licensed under the MIT License.

👨‍💻 Author

Built with Flutter & Firebase ☕🔥

If you like this project, consider giving it a ⭐ on GitHub.