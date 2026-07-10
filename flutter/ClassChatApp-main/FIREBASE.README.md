---
# ClassChatApp - Firebase Setup Guide

This guide explains how to connect the Flutter ClassChatApp to Firebase Authentication and Firebase Realtime Database.

---

# Requirements

Before starting, install:

- Flutter SDK
- Android Studio
- VS Code (Optional)
- Node.js (for Firebase CLI)

Check installation:

```bash
flutter doctor
```

Resolve any issues before proceeding.

---

# Step 1 - Create a Firebase Project

Open:

https://console.firebase.google.com

1. Click **Create Project**
2. Give the project a name

Example:

```
ClassChatApp
```

3. Continue
4. Google Analytics is optional
5. Wait for the project to finish creating

---

# Step 2 - Install Firebase CLI

Install Node.js first if it is not already installed.

Download:

https://nodejs.org

Verify installation:

```bash
node -v
npm -v
```

---

Install Firebase CLI

```bash
npm install -g firebase-tools
```

Verify:

```bash
firebase --version
```

---

Login to Firebase

```bash
firebase login
```

Your browser will open.

Login using the same Google account used for Firebase Console.

---

# Step 3 - Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

If Windows cannot find flutterfire, run instead:

```bash
dart pub global run flutterfire_cli:flutterfire configure
```

---

# Step 4 - Configure FlutterFire

Inside your Flutter project run:

```bash
flutterfire configure
```

Select:

- Android
- Web

FlutterFire will generate

```
firebase_options.dart
```

inside

```
lib/
```

---

# Step 5 - Initialize Firebase

main.dart

```dart
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ClassChatApp(),
  );
}
```

Do NOT use

```dart
Firebase.initializeApp();
```

without options after using FlutterFire.

---

# Step 6 - Enable Authentication

Firebase Console

Authentication

↓

Get Started

↓

Sign-in Method

↓

Enable

```
Email / Password
```

Save.

---

# Step 7 - Create Realtime Database

Firebase Console

↓

Build

↓

Realtime Database

↓

Create Database

Choose any region.

Start in

```
Test Mode
```

Finish.

---

# Step 8 - Database Rules

For classroom testing only

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

Publish.

Later these rules should be secured before deploying a real application.

---

# Step 9 - Verify firebase_options.dart

The generated file should contain

```dart
databaseURL:
'https://your-project-default-rtdb.firebaseio.com'
```

If it is missing,

run

```bash
flutterfire configure
```

again.

---

# Step 10 - Install Packages

pubspec.yaml

```yaml
dependencies:

  firebase_core:

  firebase_auth:

  firebase_database:
```

Then

```bash
flutter pub get
```

---

# Common Errors

---

## Error

```
flutterfire is not recognized
```

### Solution

Run

```bash
dart pub global run flutterfire_cli:flutterfire configure
```

or add

```
C:\Users\<username>\AppData\Local\Pub\Cache\bin
```

to Windows PATH.

---

## Error

```
Cannot parse Firebase url
```

### Cause

Realtime Database has not been created.

OR

databaseURL is missing.

### Solution

Create Realtime Database

Run

```bash
flutterfire configure
```

again.

Verify

```
databaseURL
```

exists in

```
firebase_options.dart
```

---

## Error

```
configuration-not-found
```

### Cause

Email/Password Authentication is disabled.

### Solution

Enable Email/Password Authentication from Firebase Console.

---

## Error

```
invalid-email
```

### Cause

Email format is incorrect.

Example

```
student1@gmail.com
```

---

## Error

```
invalid-credential
```

### Cause

The account has not been registered.

### Solution

Register first.

Then login.

---

## Error

```
_auth is undefined
```

### Cause

Firebase was not initialized correctly.

### Solution

Check

```dart
await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform,
);
```

---

## Error

```
Running Gradle task assembleDebug...
```

taking a very long time.

### Solution

The first Android build downloads many dependencies.

Wait several minutes.

If necessary

```bash
flutter clean

flutter pub get

flutter run
```

---

## Error

```
Target URI doesn't exist
```

### Cause

Import path is incorrect.

Example

```dart
import '../widgets/chat_bubble.dart';
```

Verify that the file exists inside

```
lib/widgets/
```

---

## Error

Chrome works but Android does not.

### Solution

This is usually an Android/Gradle issue and is unrelated to Firebase.

Continue testing using Chrome or Edge while resolving Android build issues.

---

# Testing the Application

Open two browsers.

Chrome

```
flutter run -d chrome
```

Edge

```
flutter run -d edge
```

Register two different users.

Example

```
student1@gmail.com
```

and

```
student2@gmail.com
```

Login using both accounts.

Send messages.

Messages should appear instantly on both browsers.

---

# Project Architecture

```
lib/

models/
    chat_message.dart

services/
    auth_service.dart
    chat_service.dart

screens/
    login_screen.dart
    register_screen.dart
    chat_screen.dart

widgets/
    chat_bubble.dart

firebase_options.dart

main.dart
```

---

