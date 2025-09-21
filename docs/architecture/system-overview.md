# Focus Field Architecture Overview

## System Architecture

Focus Field is built using Flutter with a clean, modular architecture that emphasizes separation of concerns and maintainability.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    UI Layer (Screens)                      │
├─────────────────────────────────────────────────────────────┤
│                Widget Layer (Components)                   │
├─────────────────────────────────────────────────────────────┤
│              State Management (Riverpod)                   │
├─────────────────────────────────────────────────────────────┤
│                Service Layer (Business Logic)              │
├─────────────────────────────────────────────────────────────┤
│             Platform Layer (Plugins & APIs)                │
└─────────────────────────────────────────────────────────────┘
```

## Layer Details

### UI Layer (`lib/screens/`)
- **Purpose**: Main application screens and navigation
- **Key Files**:
  - `home_page.dart` - Main application interface
  - `app_initializer.dart` - App initialization and setup
  - `splash_screen.dart` - Loading screen
  - `settings_sheet.dart` - Configuration interface with optimized layout

### Settings UI Optimizations
- **Space Efficiency**: Values displayed inline with titles using parentheses format
- **Accessibility**: Optimized for large text mode with compact layout
- **Consistency**: Uniform parentheses style across all value displays
- **Examples**:
  - "Decibel Threshold (60dB)" instead of separate value display
  - "Duration (1min)" instead of separate value display
- **Benefits**: Saves vertical space, improves readability, enhances accessibility

### Widget Layer (`lib/widgets/`)
- **Purpose**: Reusable UI components
- **Key Components**:
  - `ProgressRing` - Interactive session control with countdown
  - `RealTimeNoiseChart` - Live decibel visualization
  - `SessionHistoryGraph` - Historical performance tracking
  - `CompactPointsDisplay` - Statistics overview
  - `ScoreCard` - Detailed metrics display
  - `TipOverlay` - Contextual help system with internationalized tips
  - `TipInfoIcon` - Lightbulb icon with glow effect for tip availability

### State Management (`lib/providers/`)
- **Technology**: Riverpod with Hooks
- **Key Providers**:
  - `SilenceDataNotifier` - Session data and statistics
  - `SilenceStateProvider` - Real-time session state
  - `SettingsNotifier` - App configuration
  - `ThemeProvider` - UI theme management

### Service Layer (`lib/services/`)
- **Purpose**: Business logic and external integrations
- **Key Services**:
  - `SilenceDetector` - Core noise monitoring
  - `StorageService` - Data persistence
  - `TipService` - Contextual help system with smart scheduling
  - Permission handling and management

### Platform Layer
- **Plugins Used**:
  - `noise_meter` - Audio level monitoring
  - `shared_preferences` - Local data storage
  - `permission_handler` - System permissions
  - `confetti` - Celebration animations

## Data Flow

```
Audio Input → SilenceDetector → SilenceStateProvider → UI Updates
     ↓
Data Processing → SilenceDataNotifier → Statistics Update
     ↓
Persistence → StorageService → SharedPreferences
```

## Key Design Patterns

### State Management Pattern
- **Immutable State**: All state objects are immutable
- **Reactive Updates**: UI automatically updates on state changes
- **Async Handling**: Robust error handling for async operations

### Service Pattern
- **Single Responsibility**: Each service handles one concern
- **Dependency Injection**: Services are provided through Riverpod
- **Interface Segregation**: Clean abstractions for testability

### Widget Composition
- **Atomic Components**: Small, focused widgets
- **Composition over Inheritance**: Building complex UIs from simple parts
- **Stateless Preference**: Favor stateless widgets with Riverpod

## Performance Considerations

### Audio Processing
- **Optimized Sampling**: 200ms intervals for real-time monitoring
- **Background Efficiency**: Reduced frequency (1Hz) when not in session
- **Memory Management**: Efficient audio buffer handling

### UI Rendering
- **Smooth Animations**: 60fps progress ring updates
- **Noise Smoothing**: Exponential moving average for stable visuals
- **Lazy Loading**: Efficient chart rendering for large datasets

### Data Persistence
- **Batch Operations**: Efficient bulk data operations
- **JSON Serialization**: Fast data encoding/decoding
- **Cache Strategy**: In-memory caching for frequently accessed data

## Security & Privacy

### Data Privacy
- **Local Storage**: All data remains on device
- **No Audio Recording**: Only decibel levels are measured
- **Permission Handling**: Graceful permission management

### Platform Security
- **iOS Security**: Follows iOS privacy guidelines
- **Android Security**: Minimal permission requirements
- **Data Encryption**: Platform-provided encryption for stored data

## Tip System Architecture

### Overview
The tip system provides contextual help and guidance to users through an intelligent overlay system that appears at appropriate moments during app usage.

### Components
- **TipService**: Manages tip scheduling, rotation, and user preferences
- **TipOverlay**: UI component displaying tips with internationalized content
- **TipInfoIcon**: Lightbulb icon with glow effect for tip availability
- **Localization**: 30 tips + instructions in 7 languages (EN, ES, FR, DE, PT, PT-BR, JA)

### Key Features
- **Manual-Only Display**: Tips only show when user actively clicks the lightbulb icon
- **Smart Scheduling**: 6-hour cooldown between tips, daily limit of 1 tip
- **Session Awareness**: Never shows tips during active silence sessions
- **Premium Integration**: Tips can reference premium features with visual indicators
- **User Control**: Users can mute tips entirely with persistent preference storage
- **Contextual Instructions**: Each tip includes specific guidance on how to access related features
- **Lightbulb Icon**: Intuitive lightbulb metaphor with amber glow effect for new tips
- **Smart Timing**: Same tip shown for 5 minutes, updates only when user has seen it
- **Session Tracking**: Prevents showing same tip twice in one session
- **Muted Override**: Info button works even when tips are muted
- **No Interruptions**: Tips never appear automatically, respecting user workflow

### Internationalization
- **Complete Coverage**: All tip content, buttons, and messages are localized
- **Consistent Keys**: `tipsTitle`, `muteTips`, `tipsMuted` for UI elements
- **Dynamic Content**: 30 tips (`tip01`-`tip30`) with contextual instructions
- **Fallback Support**: English fallbacks ensure functionality even with missing translations

## Testing Strategy

### Unit Testing
- **Service Logic**: Comprehensive business logic testing
- **Data Models**: Serialization and validation testing
- **State Management**: Provider behavior testing

### Widget Testing
- **Component Testing**: Individual widget validation
- **Integration Testing**: Widget interaction testing
- **Accessibility Testing**: Screen reader and accessibility validation

### Performance Testing
- **Memory Profiling**: Memory usage optimization
- **Battery Testing**: Power consumption analysis
- **Audio Performance**: Real-time processing efficiency

## Platform Specific Considerations

### iOS
- **Minimum Version**: iOS 13.0+
- **Privacy**: NSMicrophoneUsageDescription required
- **Background**: Audio monitoring limitations
- **Performance**: Optimized for Metal rendering

### Android
- **Minimum SDK**: API 21 (Android 5.0)
- **Permissions**: RECORD_AUDIO permission
- **Background**: Service-based monitoring
- **Performance**: Vulkan support where available

## Scalability Considerations

### Future Enhancements
- **Cloud Sync**: Designed for future cloud integration
- **Multi-User**: Architecture supports user management
- **Advanced Analytics**: Framework for complex data analysis
- **Plugin System**: Extensible architecture for features

### Performance Scaling
- **Large Datasets**: Efficient handling of extensive session history
- **Real-time Processing**: Scalable audio processing pipeline
- **UI Responsiveness**: Maintained across different device capabilities

---

**Last Updated**: July 25, 2025  
**Version**: 1.0.0
