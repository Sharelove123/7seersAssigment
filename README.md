# 7seers Assignment

A Flutter app built for the 7seers take-home assignment — a parenting wellness companion called **Dall**.

## Features

- Time-aware greeting (Morning / Evening)
- First-time user onboarding flow
- Weekly check-in cards with state transitions
- Curated guide cards with image overlays
- Community post feed
- Offline-first architecture with Firebase Firestore
- State simulator for testing all 4 screen states

## Tech Stack

- Flutter 3.x with Dart
- Riverpod for state management
- Cloud Firestore for persistence
- Google Fonts (Newsreader, Work Sans, Caveat)

## Project Structure

```
lib/
├── core/
│   ├── app_colors.dart
│   ├── theme.dart
│   └── services/
│       ├── connectivity_service.dart
│       └── firebase_seeder.dart
├── features/
│   └── home/
│       ├── controller/home_controller.dart
│       ├── repository/home_repository.dart
│       ├── screens/home_screen.dart
│       └── widgets/
│           ├── accent_image.dart
│           ├── check_in_card.dart
│           ├── community_section.dart
│           ├── custom_bottom_nav.dart
│           ├── dev_menu.dart
│           ├── guide_card.dart
│           └── offline_banner.dart
├── models/
│   ├── community_post_model.dart
│   ├── guide_model.dart
│   └── user_model.dart
└── main.dart
```

## Getting Started

1. Clone the repo
2. Add your own `firebase_options.dart`, `google-services.json`, and `GoogleService-Info.plist`
3. Run `flutter pub get`
4. Run `flutter run`

## State Simulator

Long-press the profile avatar (top-right) to open the state simulator. From there you can toggle between:
- Morning / Evening
- First-time / Regular user
- Online / Offline
