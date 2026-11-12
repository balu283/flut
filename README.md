# Roadmap Quest - setup (Windows)

1. Create a fresh Flutter project:
   flutter create --org com.roadmapquest --platforms android roadmap_quest
2. Copy this zip's `pubspec.yaml` and `lib/` folder into that project, replacing the originals.
   (Delete the default test/widget_test.dart, it references the old counter app.)
3. cd roadmap_quest
   flutter pub get
   flutter run                 # emulator or USB phone
4. Build APK:
   flutter build apk --release
   Output: build/app/outputs/flutter-apk/app-release.apk
