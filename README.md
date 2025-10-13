# Glauk — AI-Powered Study Coach

A Flutter app that helps students learn from course slides by generating quizzes, tracking scores, and visualizing learning analytics, all in the quest of coaching them to excel in their academics.

## Overview
- **Entry point:** `lib/main.dart` using `MaterialApp.router` with `go_router`
- **State management:** Riverpod (`flutter_riverpod`)
- **Routing:** `go_router` (`glauk/routes/app_router.dart`)
- **Theming:** `glauk/core/theme/theme.dart`
- **Sample screens:** Quiz results view in `lib/screens/quiz/quiz_results_screen.dart`
- **Sample data:** `lib/data/` contains `course_data.dart`, `analytics_data.dart`, `student_data.dart`, `user_data.dart`

## Features
- **Quiz results & review:** Score summary, correct/incorrect counts, progress bar, and per-question review
- **Learning analytics:** GPA trend, scores trend, streaks, and leaderboards (sample data)
- **Courses & slides:** Example course list with slide-based questions
- **Beautiful UI:** Custom fonts and assets included (Inter, Roboto, Cormorant Garamond)

## Tech Stack
- **Flutter** with Material 3 theming
- **Dart SDK:** `^3.7.2` (see `pubspec.yaml` → `environment`)
- **Packages:**
  - Navigation: `go_router`
  - State: `flutter_riverpod`
  - UI: `cupertino_icons`, `convex_bottom_bar`, `glassmorphism_ui`, `step_progress_indicator`, `percent_indicator`, `font_awesome_flutter`, `confetti`
  - Media/Storage: `cached_network_image`, `image_picker`, `file_picker`, `path_provider`, `share_plus`
  - Charts: `syncfusion_flutter_charts`

## Getting Started
### Prerequisites
- Flutter SDK installed and set up
- Dart SDK compatible with `^3.7.2`

### Install
```bash
flutter pub get
```

### Run
```bash
# Choose a device from flutter devices, then
flutter run
```

### Build
```bash
# Android APK
flutter build apk

# iOS (requires macOS)
flutter build ios

# Web
flutter build web
```

## Project Structure
```
lib/
  core/
    theme/theme.dart            # App theme
  routes/
    app_router.dart             # go_router configuration
  screens/
    quiz/quiz_results_screen.dart
  data/
    course_data.dart            # Courses and slide questions (sample)
    analytics_data.dart         # GPA/scores/streaks/users (sample)
    student_data.dart           # Student courses/grades (sample)
    user_data.dart              # User profile (sample)
  main.dart                     # App entrypoint
```

## Data Shapes (samples)
Example slide item from `CourseData.courseSlides` in `lib/data/course_data.dart`:
```dart
{
  'slideTitle': 'Computer Security Basics',
  'pointsEarned': 20,
  'difficultyLevel': 'easy',
  'courseField': 'science',
  'rightAnswers': 1,
  'questionsReview': 'The questions were great',
  'completeTime': 30, // minutes
  'courseId': 1,
  'slideId': 1,
  'slideUploadTime': '2025-08-22',
  'solutionStatus': 'pending',
  'scores': 85.5,
  'questions': [
    {
      'query': 'What is the primary goal of computer security?',
      'answer': 1,
      'options': [
        {'option': 'Confidentiality, Integrity, and Availability', 'optionId': 1},
        {'option': 'High performance and speed', 'optionId': 2},
        {'option': 'User interface design', 'optionId': 3},
        {'option': 'Data compression', 'optionId': 4},
      ],
    },
  ],
}
```

## Assets and Fonts
Defined in `pubspec.yaml` under `flutter:`
- **Assets:** `lib/assets/images/…`, `lib/assets/animations/…`
- **Fonts:** Inter, Roboto, Cormorant Garamond

Ensure assets are present and paths remain consistent when adding/removing files. After asset changes, run:
```bash
flutter pub get
```

## Notable Packages Used
- `go_router`: Declarative routing and deep linking
- `flutter_riverpod`: Scalable state management
- `cached_network_image`: Cached image loading
- `image_picker`, `file_picker`: File/media selection
- `path_provider`: Safe file system locations
- `share_plus`: Native sharing
- `syncfusion_flutter_charts`: Charts for analytics
- `confetti`, `percent_indicator`, `step_progress_indicator`, `convex_bottom_bar`, `glassmorphism_ui`: UI/UX enhancements

## Platform Notes
- Some packages (e.g., `image_picker`, `file_picker`) may require additional setup per platform (Android/iOS permissions, Info.plist/AndroidManifest.xml updates). Refer to each package README for the latest steps.

## Troubleshooting
- Run `flutter clean && flutter pub get` if you see asset or dependency issues
- Verify your Dart/Flutter SDK versions align with `pubspec.yaml`
- If routing errors occur, check `app_router.dart` and that your routes exist

---
If you need a detailed contribution guide, CI/CD, or release notes, let me know and I will extend this README.
