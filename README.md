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
- **Data Export**: Export session history and statistics (Premium feature)
- **Cloud Sync**: Cross-device synchronization (Premium Plus - Phase 2)
- **Backup/Restore**: Safeguard your progress with backup functionality (Premium Plus - Phase 2)

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

3. **Configure Environment** (Important):
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your actual API keys
# Get RevenueCat API key from: https://app.revenuecat.com/projects
vim .env
```

4. Run the app:
```bash
# Development build (with mock subscriptions)
./scripts/build-dev.sh

# Or run directly with Flutter
flutter run --dart-define=REVENUECAT_API_KEY=your_key_here
```

### Environment Configuration

The app uses environment variables for secure API key management:

- **Development**: Uses `.env` file and mock subscriptions by default
- **Production**: Requires actual API keys and disables mocks

**Environment Variables:**
- `REVENUECAT_API_KEY`: RevenueCat subscription management
- `FIREBASE_API_KEY`: Firebase services (optional)
- `IS_DEVELOPMENT`: Enable/disable development mode
- `ENABLE_MOCK_SUBSCRIPTIONS`: Use mock payments for testing

### Building for Production

#### Android
```bash
# Using the secure build script (recommended)
export REVENUECAT_API_KEY="your_actual_api_key"
./scripts/build-prod.sh

# Or manually with dart-define
flutter build apk --release --dart-define=REVENUECAT_API_KEY=your_key
flutter build appbundle --release --dart-define=REVENUECAT_API_KEY=your_key
```

#### iOS
```bash
# Set environment variables
export REVENUECAT_API_KEY="your_actual_api_key"

# Build for iOS
flutter build ios --release \
  --dart-define=REVENUECAT_API_KEY="$REVENUECAT_API_KEY" \
  --dart-define=IS_DEVELOPMENT=false \
  --dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false
```

#### Development Builds
```bash
# Quick development build with environment file
./scripts/build-dev.sh

# Or run in debug mode
flutter run
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

See [CHANGELOG.md](docs/CHANGELOG.md) for detailed version history and updates.

### Recent Major Updates (v0.1.1 - Stability Release)

#### 🛡️ **Critical Stability Fixes**
- ✅ **Memory Leak Resolution**: Fixed chart widget memory leaks and resource cleanup
- ✅ **Data Validation**: Comprehensive NaN/infinite value handling prevents crashes
- ✅ **Stream Management**: Resolved concurrent stream conflicts in audio processing
- ✅ **Error Boundaries**: Added graceful error handling for critical components
- ✅ **App Initialization**: Fixed race conditions and permission flow timing
- ✅ **Resource Disposal**: Proper cleanup of audio resources and timers

#### 🎯 **Performance Improvements**
- ✅ **Chart Optimization**: Reduced update frequency and memory usage
- ✅ **Audio Processing**: Improved microphone access reliability and error handling
- ✅ **State Management**: Better concurrent operation handling and cleanup
- ✅ **UI Responsiveness**: Error boundaries prevent widget crashes from affecting app

#### 📱 **User Experience Enhancements**
- ✅ **Permission Handling**: More user-friendly permission requests and guidance
- ✅ **Error Recovery**: Automatic component recovery from temporary failures
- ✅ **Graceful Degradation**: App continues functioning even with component errors
- ✅ **Debug Improvements**: Better error reporting for development troubleshooting

### Previous Updates (v0.1.0)
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

### Phase 1 Features (Premium Tier - $1.99/month)
- [x] Extended sessions (up to 60 minutes)
- [x] Advanced analytics and trends
- [x] Data export functionality (CSV/PDF)
- [x] Premium themes and customization
- [x] Priority support

### Phase 2 Features (Premium Plus Tier - $3.99/month)
- [ ] Cloud synchronization and backup
- [ ] AI-powered insights and recommendations
- [ ] Multi-environment profiles (Home, Office, Travel)
- [ ] Social features and community challenges
- [ ] Team collaboration features
- [ ] Advanced customization options

### Future Enhancements
- [ ] Sound visualization with waveform display
- [ ] Multiple challenge modes (endurance, precision, etc.)
- [ ] Social sharing and leaderboards
- [ ] Advanced achievement system with unlockable content
- [ ] Background noise calibration wizard
- [ ] Integration with health apps (Apple Health, Google Fit)
- [ ] Custom notification schedules
- [ ] Multi-language support
- [ ] Advanced analytics dashboard

### Technical Improvements
- [ ] Flutter Sound integration for enhanced audio processing
- [ ] Machine learning for adaptive threshold adjustment
- [ ] Cloud backup and cross-device sync
- [ ] Performance optimizations for older devices
- [ ] Enhanced accessibility features
- [ ] Comprehensive integration testing

## 🔧 Troubleshooting

### Common Issues and Solutions

#### App Crashes on Startup
- **Cause**: Usually related to permission handling or initialization
- **Solution**: Clear app data, restart device, ensure microphone permissions are granted
- **Prevention**: v0.1.1 includes comprehensive fixes for startup crashes

#### Real-Time Chart Not Working
- **Cause**: Memory issues or invalid data processing
- **Solution**: Chart will show "temporarily unavailable" and auto-recover
- **Prevention**: v0.1.1 includes chart stability improvements and error boundaries

#### Microphone Permission Issues
- **iOS**: Settings > Privacy & Security > Microphone > Silence Score
- **Android**: Settings > Apps > Silence Score > Permissions > Microphone
- **Note**: App now provides better guidance for permission setup

#### Audio Processing Errors & Native Buffer Crashes
- **Cause**: Native audio buffer errors from underlying noise_meter package
- **Symptoms**: App crashes with "AudioReaderError" or similar native errors
- **Solution**: App now includes automatic recovery - chart shows "recovering" message
- **Prevention**: v0.1.1 includes comprehensive audio crash protection with:
  - Native error detection and graceful handling
  - Automatic component recovery with exponential backoff
  - Audio resource management and cleanup
  - Fallback UI when audio processing fails

#### Memory Usage
- **Optimized**: Chart data is now limited and cleaned up automatically
- **Background**: Ambient monitoring uses reduced frequency updates
- **Resources**: Proper disposal prevents memory leaks

### Development Issues

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### Permission Testing
```bash
# Reset app permissions (iOS Simulator)
xcrun simctl privacy booted reset all com.sparkvibe.silencescore

# Reset app data (Android)
adb shell pm clear com.sparkvibe.silencescore
```

### Getting Help

## 🆘 Support

- **Documentation**: Check this README and [docs folder](docs/)
- **Issues**: Report bugs and feature requests via GitHub Issues
- **Troubleshooting**: See troubleshooting section above for common solutions
- **Discussions**: Join community discussions for help and ideas
- **Privacy**: Review our privacy policy for data handling details

### Reporting Issues

When reporting issues, please include:
- Device model and OS version
- Flutter version (`flutter --version`)
- Steps to reproduce
- Expected vs actual behavior
- Error messages or logs if available

---

**Silence Score** - Transform your environment into a sanctuary of focus and mindfulness. 🧘‍♀️✨ 

## 💰 Monetization & Subscription System

### Implementation Status: ✅ **READY FOR LAUNCH**

SilenceScore features a complete subscription monetization system:

#### ✅ **Fully Implemented Infrastructure**
- **RevenueCat Integration**: Complete IAP system with purchase flows
- **Three-Tier System**: Free, Premium ($1.99/month), Premium Plus ($3.99/month)
- **Feature Gating**: Premium features properly restricted with upgrade prompts
- **Professional Paywall**: Beautiful subscription purchase interface
- **State Management**: Riverpod providers for subscription state
- **Mock Mode**: Development testing without real payments

#### ✅ **Current Configuration**
- **Package ID**: `io.sparkvibe.silencescore` (iOS & Android)
- **RevenueCat API Key**: Configured and verified ✅
- **Development Mode**: Mock subscriptions enabled for testing
- **Build Verification**: Android APK builds successfully with full monetization

#### 📋 **Next Steps for Launch**
1. **App Store Connect**: Configure subscription products (Premium & Premium Plus)
2. **Google Play Console**: Configure subscription products
3. **Production Switch**: Set `ENABLE_MOCK_SUBSCRIPTIONS=false` for live payments

#### 💎 **Premium Features (Phase 1 - Ready)**
- Extended sessions (60 minutes vs 5 minutes free)
- Advanced analytics and trend visualization
- Data export functionality (CSV/PDF)
- Premium themes and customization
- Priority support system

#### 🚀 **Premium Plus Features (Phase 2 - Planned)**
- Cloud synchronization and backup
- AI-powered insights and recommendations
- Multi-environment profiles
- Social features and challenges
- Team collaboration features

### Revenue Strategy
- **Target Markets**: US, Canada, UK, Australia
- **Year 1 Goal**: 15,000 downloads, 8% Premium conversion ($28,656 ARR)
- **Launch Timeline**: 6 weeks to live app stores
- **Current Status**: Week 1 complete, ahead of schedule

## 🔧 Project Status & Development Progress

### ✅ **Completed Core Features**
- **Silence Detection**: Advanced noise monitoring with `noise_meter` integration
- **Real-Time UI**: Interactive progress ring, live noise charts, countdown timers
- **Session Management**: Configurable durations, point scoring, streak tracking
- **Analytics**: Session history, performance metrics, visual trends
- **Settings System**: Tabbed interface with Basic/Advanced/About sections
- **Theme System**: System/Light/Dark modes with quick switching
- **Data Persistence**: Local storage with SharedPreferences
- **Permissions**: Intelligent microphone access management

### ✅ **Completed Monetization System**
- **Subscription Service**: RevenueCat integration with purchase flows
- **Feature Gating**: Premium access control with `FeatureGate` widgets
- **Paywall UI**: Professional subscription interface with billing toggles
- **State Management**: Riverpod providers for subscription state
- **Product Configuration**: Premium ($1.99) and Premium Plus ($3.99) tiers
- **Development Testing**: Mock subscription flows working

### ✅ **Completed Technical Infrastructure**
- **Package Updates**: Bundle ID changed to `io.sparkvibe.silencescore`
- **Build System**: Production-ready with environment variable management
- **API Integration**: RevenueCat, Firebase, notification services
- **Code Quality**: Comprehensive linting, testing, documentation
- **Platform Support**: iOS and Android builds verified

### 📋 **Pending Platform Configuration**
- **App Store Connect**: Subscription product configuration
- **Google Play Console**: Subscription product configuration
- **Store Assets**: App icons, screenshots, metadata preparation
- **Legal Documents**: Privacy policy and terms of service finalization

### 🎯 **Next Immediate Priorities**
1. **Platform Setup** (This Week): Configure App Store and Play Console subscriptions
2. **Visual Assets** (Next Week): Create app icons and store screenshots
3. **Legal Documents** (Next Week): Finalize privacy policy and terms
4. **Store Submission** (Week 3): Submit for app store review
5. **Launch Marketing** (Week 4-6): Execute go-to-market strategy

## Last Updated
July 27, 2025 - Monetization infrastructure complete, ready for platform configuration 