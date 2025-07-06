# Silence Score

A sophisticated Flutter app that measures silence, tracks progress, and provides detailed analytics for mindfulness and focus sessions. Features real-time noise monitoring, comprehensive statistics, achievement system, and advanced customization options.

## 🌟 Features

### Core Functionality
- **Real-Time Silence Detection**: Advanced ambient noise monitoring using device microphone
- **Interactive Progress Ring**: Large, always-visible countdown control with MM:SS timer and session progress
- **Real-Time Noise Chart**: Live decibel visualization with threshold indicators and smoothing algorithms
- **Smart Point System**: Earn 1 point per minute of successful silence sessions
- **Streak Analytics**: Track daily streaks, best performances, and comprehensive session history
- **Achievement System**: Visual feedback with confetti celebrations for successful sessions

### Advanced Analytics
- **Live Noise Visualization**: Real-time decibel level chart with ambient monitoring
- **Session History Graph**: Visual representation of your silence journey over time
- **Compact Statistics Display**: Streamlined overview of total points, streaks, and session counts
- **Detailed Session Records**: Complete history with timestamps, noise levels, and completion status
- **Performance Metrics**: Success rates, average scores, and progress tracking

### Customization & Settings
- **Tabbed Settings Interface**: Organized Basic, Advanced, and About sections
- **Adjustable Threshold**: Fine-tune decibel sensitivity (20-60 dB) for your environment
- **Session Duration**: Customizable session length (1-60 minutes) with minute-based selection
- **Advanced Theme System**: System, Light, and Dark modes with quick toggle
- **Real-Time Configuration**: Settings apply immediately without restart
- **Visual Feedback**: Intuitive sliders with live value indicators

### User Experience
- **Interactive Progress Control**: Large, always-visible progress ring serves as main session control
- **Smooth Visual Updates**: Optimized rendering with noise smoothing algorithms
- **Confetti Celebrations**: Animated rewards for successful silence sessions
- **Intelligent Permission Management**: Clear microphone access guidance with settings shortcuts
- **Compact Design**: Optimized layout fitting all controls on one screen
- **Accessibility Features**: High contrast support and scalable typography

### Data & Privacy
- **Local Storage**: All data stored securely on your device
- **No Audio Recording**: Only measures decibel levels, no audio is stored
- **Data Export**: Export session history and statistics
- **Backup/Restore**: Safeguard your progress with backup functionality

## 📱 Screenshots

*[Screenshots will be added here]*

## 🚀 Getting Started

### Prerequisites

- Flutter 3.x or higher
- Dart 3.x or higher
- iOS 13.0+ or Android API level 21+

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

## 🔐 Permissions

The app requires microphone access to measure ambient noise levels:

- **iOS**: Added `NSMicrophoneUsageDescription` in Info.plist
- **Android**: Added `RECORD_AUDIO` permission in AndroidManifest.xml

**Privacy Note**: No audio is recorded or stored - the app only measures decibel levels in real-time for silence detection.

## 🏗️ Architecture

### State Management
- **Riverpod**: Modern state management with hooks_riverpod
- **Provider Pattern**: Clean separation of concerns with dedicated providers
- **Async State Handling**: Robust error handling and loading states

### Core Services
- **Silence Detection**: Advanced noise_meter integration with ambient monitoring
- **Data Persistence**: Shared preferences with JSON serialization
- **Permission Handling**: Intelligent permission management with fallback strategies

### UI Components
- **Material 3**: Latest Material Design with dynamic color support
- **Custom Widgets**: Progress rings, charts, score cards, and session displays
- **Responsive Layout**: Adaptive design for various screen sizes
- **Animation System**: Smooth transitions and celebratory animations

### Testing
- **Unit Tests**: Comprehensive silence detection logic testing
- **Widget Tests**: UI component validation
- **Integration Testing**: End-to-end user flow validation

## ⚙️ Configuration

### Default Settings
- **Decibel Threshold**: 38 dB (quiet library level)
- **Session Duration**: 60 seconds (configurable 1-60 minutes)
- **Sample Rate**: 200ms intervals for real-time monitoring (system constant)
- **Points System**: 1 point per minute of successful session
- **Chart Smoothing**: Exponential moving average for stable visual feedback
- **Theme**: System default (auto-switching based on device settings)

### Advanced Configuration
- **Noise Smoothing**: Intelligent filtering to reduce visual noise and blinking
- **Session Duration**: Minute-based selection from 1 to 60 minutes
- **Threshold Sensitivity**: Fine-grained control over silence detection
- **Ambient Monitoring**: Background noise tracking when not in active session
- **Theme Cycling**: Quick switching between System, Light, and Dark modes
- **Performance Optimization**: Reduced update frequencies for better battery life

## 🛠️ Development

### Project Structure
```
lib/
├── constants/          # App constants and configuration
├── models/            # Data models and serialization
├── providers/         # Riverpod state management
├── screens/           # Main UI screens and navigation
├── services/          # Business logic and external integrations
├── theme/             # App theming and design system
├── widgets/           # Reusable UI components
└── main.dart          # App entry point and initialization
```

### Key Components

#### Widgets
- `ProgressRing`: Interactive countdown control with MM:SS timer and session progress
- `RealTimeNoiseChart`: Live decibel visualization with smoothing and threshold indicators
- `SessionHistoryGraph`: Historical performance tracking with visual trends
- `CompactPointsDisplay`: Streamlined statistics overview with points, streaks, and totals
- `SessionHistoryCard`: Detailed session records with achievements (legacy)
- `ScoreCard`: Comprehensive statistics display (legacy)

#### Services
- `SilenceDetector`: Core noise monitoring and analysis
- `StorageService`: Data persistence and management
- `PermissionHandler`: Microphone access management

#### Providers
- `SilenceDataNotifier`: Session data and statistics management
- `SilenceStateProvider`: Real-time session state and progress tracking
- `SettingsNotifier`: Configuration and preferences with tabbed interface
- `ThemeProvider`: Dynamic theme switching (System/Light/Dark modes)

### Running Tests
```bash
# Unit tests for silence detection
flutter test test/silence_detector_test.dart

# Widget tests for UI components
flutter test test/widget_test.dart

# All tests with coverage
flutter test --coverage
```

### Code Quality
The project follows Dart and Flutter best practices:
```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run linter
flutter analyze --no-fatal-infos
```

## 🎯 Advanced Features

### Real-Time Monitoring
- **Ambient Noise Tracking**: Continuous background monitoring when not in session
- **Live Visualization**: Real-time decibel level charts with intelligent smoothing algorithms
- **Visual Noise Reduction**: Exponential moving average prevents flickering and provides stable feedback
- **Threshold Indicators**: Dynamic visual feedback for noise level status with color-coded responses
- **Performance Optimized**: Reduced update frequencies (1Hz ambient, 5Hz active) for better battery life

### Interactive Controls
- **Primary Progress Ring**: Large, always-visible control serving as main session interface
- **Countdown Timer**: Real-time MM:SS display showing remaining session time
- **Visual Session State**: Clear start/stop indicators with dynamic sizing and spacing
- **One-Touch Control**: Single tap to start/stop sessions with immediate visual feedback
- **Gesture Optimization**: Entire progress ring area is touch-responsive

### Interactive Controls
- **Primary Progress Ring**: Large, always-visible control serving as main session interface
- **Countdown Timer**: Real-time MM:SS display showing remaining session time
- **Visual Session State**: Clear start/stop indicators with dynamic sizing and spacing
- **One-Touch Control**: Single tap to start/stop sessions with immediate visual feedback
- **Gesture Optimization**: Entire progress ring area is touch-responsive

### User Interface
- **Tabbed Settings**: Organized interface with Basic, Advanced, and About sections
- **Theme Management**: Quick theme cycling with visual feedback (System/Light/Dark)
- **Compact Layout**: Single-screen design eliminating scroll requirements
- **Modern Controls**: Visual sliders with live value indicators and smooth animations
- **Intelligent Spacing**: Optimized component positioning for better user interaction

### Analytics & Insights
- **Performance Metrics**: Success rates, average scores, and trends
- **Session Analytics**: Detailed breakdown of each silence session
- **Progress Tracking**: Visual representation of improvement over time

### Achievement System
- **Milestone Badges**: Unlock achievements for consistent practice
- **Streak Rewards**: Special recognition for maintaining daily habits
- **Progress Celebrations**: Animated rewards for accomplishments

### Data Management
- **Export Functionality**: Download session history and statistics
- **Backup/Restore**: Safeguard your progress with cloud backup
- **Data Reset**: Clear all data with confirmation dialogs

### Accessibility
- **Screen Reader Support**: Full accessibility for visually impaired users
- **High Contrast Mode**: Enhanced visibility options
- **Large Text Support**: Scalable typography for better readability

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following the existing code style
4. Add comprehensive tests for new functionality
5. Run the test suite and ensure all tests pass
6. Update documentation for any new features
7. Submit a pull request with detailed description

### Development Guidelines
- Follow Dart formatting standards
- Write comprehensive tests for new features
- Update documentation for API changes
- Ensure accessibility compliance
- Test on both iOS and Android platforms

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and updates.

### Recent Major Updates (v0.1.0)
- ✅ **Enhanced Progress Ring**: Always-visible interactive control with real-time countdown
- ✅ **Real-Time Noise Chart**: Live visualization with smoothing algorithms
- ✅ **Advanced Theme System**: System/Light/Dark modes with quick switching
- ✅ **Tabbed Settings**: Organized interface with Basic, Advanced, and About sections
- ✅ **Performance Optimization**: Reduced blinking and improved battery efficiency
- ✅ **Compact UI Design**: Single-screen layout with optimized spacing

### Development Files
**Legacy/Backup Files Created During Development:**
- `lib/screens/home_page_backup.dart` - Original home page before major redesign
- `lib/widgets/progress_ring_old.dart` - Previous progress ring implementation

*These backup files are maintained for reference and can be safely removed in production builds.*

## 🗺️ Roadmap

### Planned Features
- [ ] Sound visualization with waveform display
- [ ] Multiple challenge modes (endurance, precision, etc.)
- [ ] Social sharing and leaderboards
- [ ] Advanced achievement system with unlockable content
- [ ] Background noise calibration wizard
- [ ] Integration with health apps (Apple Health, Google Fit)
- [ ] Custom notification schedules
- [ ] Offline mode with sync capabilities
- [ ] Multi-language support
- [ ] Advanced analytics dashboard

### Technical Improvements
- [ ] Flutter Sound integration for enhanced audio processing
- [ ] Machine learning for adaptive threshold adjustment
- [ ] Cloud backup and cross-device sync
- [ ] Performance optimizations for older devices
- [ ] Enhanced accessibility features
- [ ] Comprehensive integration testing

## 🆘 Support

- **Documentation**: Check this README and inline code comments
- **Issues**: Report bugs and feature requests via GitHub Issues
- **Discussions**: Join community discussions for help and ideas
- **Privacy**: Review our privacy policy for data handling details

---

**Silence Score** - Transform your environment into a sanctuary of focus and mindfulness. 🧘‍♀️✨ 