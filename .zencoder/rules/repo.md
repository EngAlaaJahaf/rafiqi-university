---
description: Repository Information Overview
alwaysApply: true
---

# Rafiqi University Information

## Summary
A Flutter mobile application for university management, providing features for managing departments, levels, subjects, teachers, classes, lectures, assignments, and exams. The app uses SQLite for local data storage and follows a modular architecture.

## Structure
- **lib/**: Main source code directory
  - **layout/**: UI layout components (app drawer, navigation bar, main layout)
  - **model/**: Data models and repositories
  - **modules/**: Feature-specific screens (admin, dashboard, login, etc.)
  - **services/**: Core services (database, JSON file handling)
  - **shared/**: Reusable components and styles
- **assets/**: Application resources (images)
- **android/**: Android platform-specific code
- **test/**: Testing directory

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.8.1
**Framework**: Flutter
**Build System**: Flutter build system
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- flutter: SDK
- cupertino_icons: ^1.0.8
- shared_preferences: ^2.5.3
- sqflite: ^2.4.2
- path_provider: ^2.1.5
- animated_notch_bottom_bar: ^1.0.3
- intl: ^0.20.2
- get: ^4.6.6
- provider: ^6.1.5+1

**Development Dependencies**:
- flutter_launcher_icons: ^0.13.1
- flutter_lints: ^5.0.0

## Build & Installation
```bash
flutter pub get
flutter build apk
```

## Database
**Type**: SQLite
**Service**: DatabaseService (singleton pattern)
**Tables**:
- sem_departments, sem_levels, sem_semesters, sem_subjects
- sem_teachers, sem_time_slots, sem_class, sem_lect_type
- sem_user, sem_enrollments, sem_lectures, sem_assignments
- sem_exams, sem_notifications

## Main Entry Point
**File**: lib/main.dart
**App Class**: MyApp (StatefulWidget)
**Initial Screen**: LoginScreen

## State Management
**Approaches**:
- Provider pattern (FabViewModel)
- GetX for navigation and state management

## Testing
**Framework**: flutter_test
**Test Location**: test/widget_test.dart
**Run Command**:
```bash
flutter test
```