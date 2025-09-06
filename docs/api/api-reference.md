# API Reference

## Overview

SilenceScore uses a modular architecture with clear separation between data models, services, and UI components. This document provides a comprehensive reference for all public APIs.

## Models

### SilenceData

Core data model representing silence measurement data.

**File**: `lib/models/silence_data.dart`

```dart
class SilenceData {
  final double noiseLevel;
  final Duration duration;
  final DateTime timestamp;
  final bool isSilent;
  final double score;
  
  const SilenceData({
    required this.noiseLevel,
    required this.duration,
    required this.timestamp,
    required this.isSilent,
    required this.score,
  });
}
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `noiseLevel` | `double` | Current noise level in decibels (dB) |
| `duration` | `Duration` | Duration of current measurement period |
| `timestamp` | `DateTime` | When this measurement was taken |
| `isSilent` | `bool` | Whether current environment is considered silent |
| `score` | `double` | Calculated silence score (0.0 - 100.0) |

#### Methods

##### `copyWith`
Creates a copy with updated values.

```dart
SilenceData copyWith({
  double? noiseLevel,
  Duration? duration,
  DateTime? timestamp,
  bool? isSilent,
  double? score,
}) → SilenceData
```

##### `toJson`
Converts to JSON representation.

```dart
Map<String, dynamic> toJson() → Map<String, dynamic>
```

##### `fromJson`
Creates instance from JSON.

```dart
static SilenceData fromJson(Map<String, dynamic> json) → SilenceData
```

## Services

### SilenceDetector

Core service for audio monitoring and silence detection.

**File**: `lib/services/silence_detector.dart`

#### Public Methods

##### `initialize`
Initializes the audio recording system.

```dart
Future<bool> initialize() → Future<bool>
```

**Returns**: `true` if initialization successful, `false` otherwise.

**Throws**: 
- `AudioPermissionException` if microphone permission denied
- `AudioInitializationException` if audio system unavailable

##### `startMonitoring`
Begins continuous audio monitoring.

```dart
void startMonitoring()
```

**Preconditions**: Must call `initialize()` first.

##### `stopMonitoring`
Stops audio monitoring and releases resources.

```dart
void stopMonitoring()
```

##### `dispose`
Cleans up all resources. Call when service no longer needed.

```dart
void dispose()
```

#### Properties

##### `currentData`
Real-time silence data stream.

```dart
Stream<SilenceData> get currentData → Stream<SilenceData>
```

##### `isMonitoring`
Current monitoring state.

```dart
bool get isMonitoring → bool
```

##### `silenceThreshold`
Noise level threshold for silence detection (in dB).

```dart
double get silenceThreshold → double
set silenceThreshold(double value)
```

**Default**: `-40.0` dB

### StorageService

Handles data persistence and retrieval.

**File**: `lib/services/storage_service.dart`

#### Public Methods

##### `initialize`
Sets up local storage system.

```dart
Future<void> initialize() → Future<void>
```

##### `saveSession`
Saves a monitoring session.

```dart
Future<void> saveSession(List<SilenceData> sessionData) → Future<void>
```

**Parameters**:
- `sessionData`: List of silence measurements from session

##### `loadSessions`
Retrieves all saved sessions.

```dart
Future<List<List<SilenceData>>> loadSessions() → Future<List<List<SilenceData>>>
```

**Returns**: List of sessions, each containing silence data points.

##### `clearAllData`
Removes all stored data.

```dart
Future<void> clearAllData() → Future<void>
```

## Providers (State Management)

### SilenceProvider

Riverpod provider managing silence detection state.

**File**: `lib/providers/silence_provider.dart`

#### Provider Types

##### `silenceServiceProvider`
Provides SilenceDetector instance.

```dart
final silenceServiceProvider = Provider<SilenceDetector>((ref) => SilenceDetector());
```

##### `currentSilenceDataProvider`
Stream of current silence measurements.

```dart
final currentSilenceDataProvider = StreamProvider<SilenceData>((ref) {
  final service = ref.read(silenceServiceProvider);
  return service.currentData;
});
```

##### `sessionDataProvider`
Accumulates session data points.

```dart
final sessionDataProvider = StateNotifierProvider<SessionDataNotifier, List<SilenceData>>((ref) {
  return SessionDataNotifier();
});
```

#### SessionDataNotifier

State notifier for managing session data.

##### Methods

```dart
void addDataPoint(SilenceData data)
void clearSession()
void endSession()
List<SilenceData> get currentSession
```

### ThemeProvider

Manages app theme and visual settings.

**File**: `lib/providers/theme_provider.dart`

#### Provider Types

##### `themeProvider`
Current theme state.

```dart
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
```

##### `isDarkModeProvider`
Dark mode toggle state.

```dart
final isDarkModeProvider = StateProvider<bool>((ref) => false);
```

### TipService

Contextual help system that provides intelligent tips to users.

**File**: `lib/services/tip_service.dart`

#### Overview
The TipService manages a collection of 30 contextual tips that help users understand and utilize app features effectively. Tips are shown with smart scheduling and respect user preferences.

#### Key Features
- **Manual-Only Display**: Tips only show when user actively clicks the lightbulb icon
- **Smart Scheduling**: 6-hour cooldown between tips, maximum 1 tip per day
- **Session Awareness**: Never interrupts active silence sessions
- **Premium Integration**: Tips can reference premium features with visual indicators
- **User Control**: Users can mute tips entirely
- **Internationalization**: All content localized in 7 languages
- **Lightbulb Icon**: Intuitive lightbulb icon with amber glow effect for new tips
- **Smart Timing**: Same tip shown for 5 minutes, updates only when user has seen it
- **Session Tracking**: Prevents showing same tip twice in one session
- **Muted Override**: Info button works even when tips are muted
- **No Interruptions**: Tips never appear automatically, respecting user workflow

#### Provider
```dart
final tipServiceProvider = Provider<TipService>((ref) => TipService(ref));
```

#### Methods

##### `getEnabled`
Check if tips are currently enabled.

```dart
Future<bool> getEnabled() → Future<bool>
```

##### `setEnabled`
Enable or disable tips.

```dart
Future<void> setEnabled(bool value) → Future<void>
```

##### `maybeShowOnAppStart`
**DISABLED**: Automatic tip display on app start is disabled. Tips now only show when user actively clicks the lightbulb icon.

```dart
Future<void> maybeShowOnAppStart(BuildContext context) → Future<void>
```

##### `maybeShowAfterSession`
**DISABLED**: Automatic tip display after sessions is disabled. Tips now only show when user actively clicks the lightbulb icon.

```dart
Future<void> maybeShowAfterSession(BuildContext context, {required bool success}) → Future<void>
```

##### `showCurrentTip`
Show the current tip (bypasses mute status, used by info button).

```dart
Future<void> showCurrentTip(BuildContext context) → Future<void>
```

##### `markCurrentTipAsSeen`
Mark the current tip as seen by the user.

```dart
Future<void> markCurrentTipAsSeen() → Future<void>
```

##### `hasNewTips`
Check if there are new tips available that haven't been seen.

```dart
Future<bool> hasNewTips() → Future<bool>
```

#### Tip Content
- **30 Tips**: Covering all major app features and usage patterns
- **Contextual Instructions**: Each tip includes specific guidance
- **Premium Integration**: Tips reference premium features when relevant
- **Localized Content**: All tips available in 7 languages

#### Localization Keys
- `tipsTitle`: Window title
- `muteTips`: Mute button text
- `tipsMuted`: Toast confirmation message
- `tip01`-`tip30`: Individual tip content
- `tipInstruction*`: Contextual help text for each tip

## Widgets

### ProgressRing

Circular progress indicator for silence score.

**File**: `lib/widgets/progress_ring.dart`

#### Constructor

```dart
const ProgressRing({
  Key? key,
  required this.progress,
  this.size = 200.0,
  this.strokeWidth = 12.0,
  this.backgroundColor = Colors.grey,
  this.progressColor = Colors.blue,
}) : super(key: key);
```

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `progress` | `double` | required | Progress value (0.0 - 1.0) |
| `size` | `double` | `200.0` | Ring diameter |
| `strokeWidth` | `double` | `12.0` | Ring thickness |
| `backgroundColor` | `Color` | `Colors.grey` | Background ring color |
| `progressColor` | `Color` | `Colors.blue` | Progress ring color |

### RealTimeNoiseChart

Line chart showing noise level over time.

**File**: `lib/widgets/real_time_noise_chart.dart`

#### Constructor

```dart
const RealTimeNoiseChart({
  Key? key,
  required this.dataPoints,
  this.height = 200.0,
  this.maxDataPoints = 100,
}) : super(key: key);
```

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `dataPoints` | `List<SilenceData>` | required | Data to display |
| `height` | `double` | `200.0` | Chart height |
| `maxDataPoints` | `int` | `100` | Maximum points to show |

### ScoreCard

Displays current silence score with visual feedback.

**File**: `lib/widgets/score_card.dart`

#### Constructor

```dart
const ScoreCard({
  Key? key,
  required this.score,
  required this.isSilent,
  this.onTap,
}) : super(key: key);
```

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `score` | `double` | required | Current score (0-100) |
| `isSilent` | `bool` | required | Whether environment is silent |
| `onTap` | `VoidCallback?` | `null` | Tap handler |

### TipInfoIcon

Lightbulb icon widget with glow effect for displaying tip availability.

**File**: `lib/widgets/tip_info_icon.dart`

#### Constructor

```dart
const TipInfoIcon({
  Key? key,
  required VoidCallback onTap,
  required bool hasNewTips,
  required bool isEnabled,
});

const TipInfoIconWithAnimation({
  Key? key,
  required VoidCallback onTap,
  required bool hasNewTips,
  required bool isEnabled,
});
```

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `onTap` | `VoidCallback` | required | Tap handler for showing tip |
| `hasNewTips` | `bool` | required | Whether new tips are available |
| `isEnabled` | `bool` | required | Whether tips are enabled |

#### Features
- **Lightbulb Icon**: Intuitive lightbulb metaphor for tips
- **Glow Effect**: Subtle amber glow animation for new tips
- **Theme Adaptive**: Works well in both light and dark themes
- **Gentle Animation**: 3-second smooth pulsing effect
- **Accessibility**: Screen reader support and proper tooltips

#### Animation
- **Duration**: 3 seconds for smooth, gentle pulsing
- **Effect**: Background glow with main icon color variation
- **Colors**: Amber shades (shade600 to shade400)
- **Opacity**: 20% background glow with smooth transitions

### TipOverlay

Contextual help overlay that displays tips with internationalized content.

**File**: `lib/widgets/tip_overlay.dart`

#### Constructor

```dart
const TipOverlay({
  Key? key,
  required String text,
  String? instructions,
  bool isPremium = false,
  required VoidCallback onClose,
  required VoidCallback onMute,
});
```

#### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `text` | `String` | required | Main tip content |
| `instructions` | `String?` | `null` | Contextual instructions |
| `isPremium` | `bool` | `false` | Show premium badge |
| `onClose` | `VoidCallback` | required | Close button handler |
| `onMute` | `VoidCallback` | required | Mute button handler |

#### Features
- **Internationalized UI**: All text elements use localization keys
- **Premium Integration**: Visual indicator for premium-related tips
- **Contextual Instructions**: Additional guidance for each tip
- **User Control**: Close and mute functionality
- **Responsive Design**: Adapts to different screen sizes

#### Localization
- Uses `AppLocalizations` for all text content
- Fallback to English if localization fails
- Consistent with app-wide localization system

### SettingsSheet

Configuration interface with optimized layout for accessibility.

**File**: `lib/screens/settings_sheet.dart`

#### Constructor
```dart
const SettingsSheet({super.key});
```

#### Features
- **Space-Efficient Layout**: Values displayed inline with titles using parentheses format
- **Accessibility Optimized**: Designed for large text mode with compact layout
- **Consistent UI**: Uniform parentheses style across all value displays
- **Tabbed Interface**: Basic, Advanced, and About tabs for organized settings

#### Layout Optimizations
- **Decibel Threshold**: "Decibel Threshold (60dB)" format
- **Duration**: "Duration (1min)" format
- **Space Savings**: Removes redundant value displays below sliders
- **Accessibility**: Better support for large text and screen readers

#### Value Display Format
```dart
// Before optimization
"Decibel Threshold"
[Slider with value below]

// After optimization  
"Decibel Threshold (60dB)"
[Slider only]
```

## Constants

### AppConstants

Application-wide constants and configuration.

**File**: `lib/constants/app_constants.dart`

```dart
class AppConstants {
  // Audio Configuration
  static const double defaultSilenceThreshold = -40.0;
  static const int sampleRate = 44100;
  static const Duration measurementInterval = Duration(milliseconds: 100);
  
  // UI Configuration
  static const double maxScore = 100.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Storage Keys
  static const String sessionsKey = 'silence_sessions';
  static const String settingsKey = 'app_settings';
  
  // Scoring Thresholds
  static const double excellentThreshold = 90.0;
  static const double goodThreshold = 70.0;
  static const double fairThreshold = 50.0;
}
```

## Error Handling

### Custom Exceptions

#### AudioPermissionException
Thrown when microphone permission is denied.

```dart
class AudioPermissionException implements Exception {
  final String message;
  const AudioPermissionException(this.message);
}
```

#### AudioInitializationException
Thrown when audio system cannot be initialized.

```dart
class AudioInitializationException implements Exception {
  final String message;
  final dynamic originalError;
  const AudioInitializationException(this.message, [this.originalError]);
}
```

### Error Handling Patterns

#### Service Initialization
```dart
try {
  await silenceDetector.initialize();
} on AudioPermissionException catch (e) {
  // Handle permission denial
} on AudioInitializationException catch (e) {
  // Handle initialization failure
} catch (e) {
  // Handle unexpected errors
}
```

#### Stream Error Handling
```dart
ref.listen(currentSilenceDataProvider, (previous, next) {
  next.when(
    data: (silenceData) {
      // Handle successful data
    },
    error: (error, stackTrace) {
      // Handle stream errors
    },
    loading: () {
      // Handle loading state
    },
  );
});
```

## Performance Considerations

### Memory Management
- Services automatically dispose resources
- Streams are canceled when providers are disposed
- Large session data is persisted to storage, not memory

### Battery Optimization
- Audio monitoring uses efficient sampling
- UI updates are throttled to reasonable intervals
- Background processing is minimized

### Platform-Specific Notes

#### Android
- Requires `RECORD_AUDIO` permission
- Uses `AudioRecord` API for low-level access
- Supports background monitoring with foreground service

#### iOS
- Requires `NSMicrophoneUsageDescription` in Info.plist
- Uses `AVAudioEngine` for audio capture
- Background monitoring limited by iOS policies

---

**Last Updated**: July 25, 2025  
**Version**: 1.0.0
