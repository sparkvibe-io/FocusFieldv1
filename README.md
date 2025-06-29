# Silence Score

A Flutter app that measures one minute of true silence, awards points, and stores streak history locally. Perfect for mindfulness, focus sessions, or quiet time challenges.

## Features

- **Silence Detection**: Measures ambient noise levels using your device's microphone
- **60-Second Timer**: Visual progress ring showing countdown
- **Point System**: Earn +1 point for each successful silence session
- **Streak Tracking**: Maintain daily streaks and track your best performance
- **Customizable Threshold**: Adjust the decibel threshold (20-60 dB) to match your environment
- **Beautiful UI**: Material 3 design with light/dark mode support
- **Confetti Celebration**: Animated celebration when you achieve silence
- **Local Storage**: All data stored locally on your device

## Screenshots

*[Screenshots will be added here]*

## Getting Started

### Prerequisites

- Flutter 3.x or higher
- Dart 3.x or higher
- iOS 12.0+ or Android API level 21+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/silence-score.git
cd silence-score
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## Permissions

The app requires microphone access to measure ambient noise levels:

- **iOS**: Added `NSMicrophoneUsageDescription` in Info.plist
- **Android**: Added `RECORD_AUDIO` permission in AndroidManifest.xml

No audio is recorded or stored - the app only measures decibel levels in real-time.

## Architecture

- **State Management**: Riverpod with hooks_riverpod
- **Silence Detection**: noise_meter plugin (samples every 200ms)
- **Persistence**: shared_preferences for local data storage
- **UI**: Material 3 with custom progress ring and confetti animations
- **Testing**: Unit tests for silence detection logic and widget tests

## Configuration

### Decibel Threshold
- Default: 38 dB (quiet library level)
- Range: 20-60 dB
- Adjustable in Settings

### Duration
- Fixed: 60 seconds
- Configurable in `AppConstants.silenceDurationSeconds`

### Sample Rate
- Fixed: 200ms intervals
- Configurable in `AppConstants.sampleIntervalMs`

## Development

### Project Structure
```
lib/
├── constants/          # App constants and strings
├── models/            # Data models
├── providers/         # Riverpod providers
├── screens/           # UI screens
├── services/          # Business logic
├── theme/             # App theming
├── widgets/           # Reusable widgets
└── main.dart          # App entry point
```

### Running Tests
```bash
# Unit tests
flutter test test/silence_detector_test.dart

# Widget tests
flutter test test/widget_test.dart

# All tests
flutter test
```

### Code Style
The project follows Dart formatting standards:
```bash
flutter format .
flutter analyze
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

## TODO

- [ ] Add sound visualization
- [ ] Implement different challenge modes
- [ ] Add social sharing features
- [ ] Create achievement system
- [ ] Add background noise calibration
- [ ] Implement flutter_sound integration (currently using noise_meter) 