# Focus Mode P2/P3 Enhancements (Post-MVP)

**Status**: Deferred to post-MVP releases
**Current P1 Implementation**: Fully functional and MVP-ready
**Estimated Timeline**: 3 weeks (1 week P2, 2 weeks P3 + testing)

---

## 🎯 Overview

Focus Mode P1 (current implementation) provides a minimal, distraction-free full-screen overlay for focus sessions with:
- ✅ Black background with glowing cyan progress ring
- ✅ Adaptive countdown timer (updates at smart intervals)
- ✅ Long-press Pause/Stop controls
- ✅ Session completion state (check icon + message)
- ✅ Exit button (X) in top-right
- ✅ Pause icon overlay when paused
- ✅ Audio circuit breaker protection (500ms timeout)

This document outlines **future enhancements** for P2 (Enhanced UX) and P3 (Premium Features).

---

## 🌬️ P2 Enhancement 1: Breathing Animation

### Purpose
Meditation-style breathing guide to help users maintain calm during focus sessions.

### Design
- **Animation**: Circular ring behind progress ring that scales in/out
- **Cycle**: 8 seconds total (4s inhale, 4s exhale)
- **Behavior**: Pauses when session is paused, resumes when unpaused
- **Placement**: Concentric circle outside main progress ring

### Implementation
```dart
// lib/widgets/focus_mode_breathing.dart
class BreathingAnimation extends StatefulWidget {
  final bool isActive; // Only animate when session running, not paused

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 8-second cycle: 4s inhale (scale up), 4s exhale (scale down)
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95, // Minimum scale (exhale)
      end: 1.05,   // Maximum scale (inhale)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(BreathingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 320,  // Slightly larger than progress ring (280px)
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### User Preferences
```dart
// lib/models/user_preferences.dart
final bool focusModeBreathingGuide;

// Default: false (opt-in feature)
```

### Settings UI
```dart
// lib/screens/settings_sheet.dart - Basic Tab > Focus Section
SwitchListTile(
  title: const Text('Breathing Guide'),
  subtitle: const Text('Show breathing animation during focus sessions'),
  value: userPrefs.focusModeBreathingGuide,
  onChanged: (value) async {
    await ref.read(userPreferencesProvider.notifier)
        .updateUserPreferences(
          userPrefs.copyWith(focusModeBreathingGuide: value),
        );
  },
)
```

### Integration
```dart
// lib/widgets/focus_mode_overlay.dart
Stack(
  alignment: Alignment.center,
  children: [
    // Breathing animation behind progress ring
    if (userPrefs.focusModeBreathingGuide && !isPaused)
      BreathingAnimation(isActive: isListening && !isPaused),

    // Main progress ring
    _FocusModeRing(
      progress: progress,
      size: 280,
    ),
  ],
)
```

### Acceptance Criteria
- [ ] Animation cycles smoothly at 8-second intervals
- [ ] Animation pauses when session is paused
- [ ] Animation resumes when session is resumed
- [ ] Toggle in Settings persists across app restarts
- [ ] No performance impact (smooth 60fps)
- [ ] Animation stops when session completes or exits

---

## 🎨 P2 Enhancement 2: Icon Buttons

### Purpose
Replace text-based Pause/Stop buttons with icon-only circular buttons for cleaner minimal aesthetic.

### Design
- **Shape**: Circular buttons with subtle white background
- **Icons**: Material Icons (pause, play_arrow, stop)
- **Size**: 48px diameter (32px icon)
- **Background**: `Colors.white.withValues(alpha: 0.1)`
- **Spacing**: 48px between buttons
- **Hint**: "Long press to pause or stop" text below button row

### Implementation
```dart
// lib/widgets/focus_mode_overlay.dart
// Replace existing text button row

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Pause/Resume button - icon only
    GestureDetector(
      onLongPress: onPause,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isPaused ? Icons.play_arrow : Icons.pause,
          color: Colors.white,
          size: 32,
        ),
      ),
    ),
    const SizedBox(width: 48),
    // Stop button - icon only
    GestureDetector(
      onLongPress: onStop,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.stop,
          color: Colors.white,
          size: 32,
        ),
      ),
    ),
  ],
),
const SizedBox(height: 12),
// Hint text below buttons
Text(
  'Long press to pause or stop',
  style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.white.withValues(alpha: 0.4),
    letterSpacing: 0.5,
  ),
),
```

### Acceptance Criteria
- [ ] Circular buttons render cleanly
- [ ] Long-press gestures work correctly
- [ ] Icons change appropriately (pause ↔ play_arrow)
- [ ] Hint text is visible and readable
- [ ] Touch targets are ≥48x48dp (accessible)
- [ ] Visual feedback on long-press (consider ripple effect)

---

## 🎉 P2 Enhancement 3: Enhanced Completion Celebration

### Purpose
More engaging and celebratory success feedback when session completes.

### Design
- **Check Icon**: Animated with elastic bounce effect
- **Size**: 80px (larger than current 64px)
- **Color**: Cyan (`Color(0xFF00F5FF)`) to match ring
- **Ambient Score**: Display percentage in completion message
- **Animations**:
  - Check icon: 600ms elastic bounce
  - Text: 400ms fade-in
  - Staggered timing for visual hierarchy

### Implementation
```dart
// lib/widgets/focus_mode_overlay.dart - Enhanced completion state

if (remainingSeconds <= 0 && progress >= 0.99)
  Column(
    children: [
      // Animated check icon with elastic bounce
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF00F5FF), // Cyan to match ring
                size: 80,
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 24),

      // Success message with fade-in (staggered)
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Column(
              children: [
                const Text(
                  'Session Complete!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Show ambient score if available
                if (ambientScore != null)
                  Text(
                    '${(ambientScore! * 100).round()}% Ambient Score',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF00F5FF),
                      letterSpacing: 0.8,
                    ),
                  ),

                const SizedBox(height: 8),
                Text(
                  'Great focus session',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  )
```

### Parameters Required
```dart
// Add to FocusModeOverlay constructor
final double? ambientScore; // Pass from session state (0.0 to 1.0)
```

### Acceptance Criteria
- [ ] Check icon animates with elastic bounce
- [ ] Text fades in smoothly after icon
- [ ] Ambient score displays correctly (0-100%)
- [ ] Animations feel polished and celebratory
- [ ] No janky frame drops during animation
- [ ] Works correctly even if ambientScore is null

---

## 🔒 P3 Premium Feature 1: Lock Mode

### Purpose
Prevent exiting Focus Mode until session completes - for users who want maximum commitment.

### Design
- **Behavior**: X button hidden, back button disabled during session
- **Lock Indicator**: Lock icon in top-right (where X normally is)
- **Safety**: Always allow exit when session completes (`remainingSeconds <= 0`)
- **Premium**: Feature gated behind Premium tier subscription

### Implementation
```dart
// lib/models/user_preferences.dart
final bool focusModeLockEnabled;

// lib/widgets/focus_mode_overlay.dart
// Conditional X button / lock indicator

// Show lock icon when locked and session active
if (isLockMode && remainingSeconds > 0)
  Positioned(
    top: MediaQuery.of(context).padding.top + 8,
    right: 16,
    child: Icon(
      Icons.lock,
      color: Colors.white.withValues(alpha: 0.5),
      size: 28,
    ),
  ),

// Show X button when NOT locked OR session completed (safety)
if (!isLockMode || remainingSeconds <= 0)
  Positioned(
    top: MediaQuery.of(context).padding.top + 8,
    right: 16,
    child: IconButton(
      onPressed: onExit,
      icon: const Icon(Icons.close, color: Colors.white, size: 28),
      padding: const EdgeInsets.all(12),
    ),
  ),

// Also disable back button during locked session
@override
Widget build(BuildContext context, WidgetRef ref) {
  return WillPopScope(
    onWillPop: () async {
      // Allow back button only if not locked OR session complete
      return !isLockMode || remainingSeconds <= 0;
    },
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      // ... rest of overlay
    ),
  );
}
```

### Settings UI (Premium Gated)
```dart
// lib/screens/settings_sheet.dart - Basic Tab > Focus Section

FeatureGate(
  feature: 'focus_mode_lock',
  child: SwitchListTile(
    title: Row(
      children: [
        const Text('Lock Mode'),
        const SizedBox(width: 8),
        // Premium badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'PREMIUM',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    subtitle: const Text('Prevent exiting Focus Mode until session completes'),
    value: userPrefs.focusModeLockEnabled,
    onChanged: (value) async {
      await ref.read(userPreferencesProvider.notifier)
          .updateUserPreferences(
            userPrefs.copyWith(focusModeLockEnabled: value),
          );
    },
  ),
)
```

### Feature Gating
```dart
// lib/services/subscription_service.dart
// Add to feature list
static const String focusModeLock = 'focus_mode_lock';

// Check in SubscriptionService.hasFeature()
case 'focus_mode_lock':
  return tier == SubscriptionTier.premium ||
         tier == SubscriptionTier.premiumPlus;
```

### Acceptance Criteria
- [ ] Lock mode only available to Premium users
- [ ] X button hidden during locked session
- [ ] Lock icon displays when active
- [ ] Back button disabled during locked session
- [ ] Exit always allowed when session completes
- [ ] Setting persists across app restarts
- [ ] Upgrade prompt shown for free users

---

## 🎨 P3 Premium Feature 2: Color Themes

### Purpose
Personalized Focus Mode aesthetics with 4 curated color schemes.

### Themes
1. **Midnight** (default): Black + Cyan
2. **Ocean**: Deep Blue + Ocean Blue
3. **Forest**: Dark Green + Green
4. **Sunset**: Dark Red + Coral

### Implementation
```dart
// lib/models/focus_mode_theme.dart

class FocusModeTheme {
  final String id;
  final String name;
  final Color backgroundColor;
  final Color ringColor;
  final Color glowColor;
  final Color textColor;

  const FocusModeTheme({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.ringColor,
    required this.glowColor,
    required this.textColor,
  });

  static const midnight = FocusModeTheme(
    id: 'midnight',
    name: 'Midnight',
    backgroundColor: Color(0xFF000000),
    ringColor: Color(0xFF00F5FF),
    glowColor: Color(0xFF00D4FF),
    textColor: Colors.white,
  );

  static const ocean = FocusModeTheme(
    id: 'ocean',
    name: 'Ocean',
    backgroundColor: Color(0xFF001F3F),
    ringColor: Color(0xFF0074D9),
    glowColor: Color(0xFF7FDBFF),
    textColor: Color(0xFFE0F7FF),
  );

  static const forest = FocusModeTheme(
    id: 'forest',
    name: 'Forest',
    backgroundColor: Color(0xFF0A1F0A),
    ringColor: Color(0xFF2ECC40),
    glowColor: Color(0xFF3D9970),
    textColor: Color(0xFFE0FFE0),
  );

  static const sunset = FocusModeTheme(
    id: 'sunset',
    name: 'Sunset',
    backgroundColor: Color(0xFF1F0A0A),
    ringColor: Color(0xFFFF6B6B),
    glowColor: Color(0xFFFF851B),
    textColor: Color(0xFFFFE0E0),
  );

  static const List<FocusModeTheme> all = [
    midnight,
    ocean,
    forest,
    sunset,
  ];

  static FocusModeTheme fromId(String id) {
    return all.firstWhere(
      (theme) => theme.id == id,
      orElse: () => midnight,
    );
  }
}

// lib/models/user_preferences.dart
final String focusModeThemeId; // Default: 'midnight'
```

### Theme Selector Widget
```dart
// lib/widgets/focus_theme_selector.dart

class FocusThemeSelector extends ConsumerWidget {
  const FocusThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPrefs = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Focus Mode Theme',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              // Premium badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: FocusModeTheme.all.map((focusTheme) {
            final isSelected = userPrefs.focusModeThemeId == focusTheme.id;

            return InkWell(
              onTap: () async {
                await ref.read(userPreferencesProvider.notifier)
                    .updateUserPreferences(
                      userPrefs.copyWith(focusModeThemeId: focusTheme.id),
                    );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: focusTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mini progress ring preview
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: focusTheme.ringColor,
                          width: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      focusTheme.name,
                      style: TextStyle(
                        color: focusTheme.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
```

### Integration in Overlay
```dart
// lib/widgets/focus_mode_overlay.dart

@override
Widget build(BuildContext context, WidgetRef ref) {
  final userPrefs = ref.watch(userPreferencesProvider);
  final focusTheme = FocusModeTheme.fromId(userPrefs.focusModeThemeId);

  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: Material(
      color: focusTheme.backgroundColor, // Use theme background
      child: Stack(
        children: [
          // ... rest uses focusTheme colors
          Text(
            _getDiscretTimeDisplay(),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: focusTheme.textColor, // Use theme text color
              letterSpacing: 2.0,
            ),
          ),

          _FocusModeRing(
            progress: progress,
            size: 280,
            ringColor: focusTheme.ringColor,   // Use theme ring color
            glowColor: focusTheme.glowColor,   // Use theme glow color
          ),
        ],
      ),
    ),
  );
}
```

### Settings Integration
```dart
// lib/screens/settings_sheet.dart - Basic Tab > Focus Section

FeatureGate(
  feature: 'focus_mode_themes',
  child: FocusThemeSelector(),
)
```

### Acceptance Criteria
- [ ] 4 themes available and visually distinct
- [ ] Theme selector shows preview cards
- [ ] Selected theme highlights correctly
- [ ] Theme persists across app restarts
- [ ] All colors update in overlay (background, ring, glow, text)
- [ ] Premium users can access all themes
- [ ] Free users see upgrade prompt
- [ ] Themes look good in both light/dark mode (settings)

---

## 🌑 P3 Premium Feature 3: Ultra-Minimal Mode

### Purpose
Maximum distraction reduction - ring-only display with no text or buttons.

### Design
- **Display**: Only progress ring visible
- **No Timer**: No countdown text
- **No Buttons**: Pause/Stop hidden by default
- **Gesture**: Long-press anywhere on screen to reveal controls (5s timeout)
- **Controls Overlay**: Semi-transparent panel with timer + buttons
- **Premium**: Requires Premium tier subscription

### Implementation
```dart
// lib/models/user_preferences.dart
final bool focusModeUltraMinimal;

// lib/widgets/focus_mode_overlay.dart

class FocusModeOverlay extends ConsumerStatefulWidget {
  // ... existing parameters

  @override
  ConsumerState<FocusModeOverlay> createState() => _FocusModeOverlayState();
}

class _FocusModeOverlayState extends ConsumerState<FocusModeOverlay> {
  bool _showControlsOverlay = false;
  Timer? _controlsTimer;

  void _toggleControlsOverlay() {
    setState(() {
      _showControlsOverlay = true;
    });

    // Hide controls after 5 seconds
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControlsOverlay = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPrefs = ref.watch(userPreferencesProvider);
    final isUltraMinimal = userPrefs.focusModeUltraMinimal;
    final focusTheme = FocusModeTheme.fromId(userPrefs.focusModeThemeId);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        color: focusTheme.backgroundColor,
        child: GestureDetector(
          // Long-press anywhere to reveal controls
          onLongPress: isUltraMinimal ? _toggleControlsOverlay : null,
          child: Stack(
            children: [
              // Center: Progress ring (always visible)
              Center(
                child: _FocusModeRing(
                  progress: widget.progress,
                  size: 280,
                  ringColor: focusTheme.ringColor,
                  glowColor: focusTheme.glowColor,
                ),
              ),

              // Timer text (hidden in ultra-minimal mode)
              if (!isUltraMinimal || _showControlsOverlay)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDiscretTimeDisplay(),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                          color: focusTheme.textColor,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),

              // Controls overlay (temporary in ultra-minimal mode)
              if (!isUltraMinimal || _showControlsOverlay)
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _showControlsOverlay || !isUltraMinimal ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        // Pause/Stop buttons
                        if (widget.remainingSeconds > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Pause button
                              GestureDetector(
                                onLongPress: widget.onPause,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    widget.isPaused ? Icons.play_arrow : Icons.pause,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                              // Stop button
                              GestureDetector(
                                onLongPress: widget.onStop,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        // Hint text
                        Text(
                          isUltraMinimal
                              ? 'Long press anywhere to show controls'
                              : 'Long press to pause or stop',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withValues(alpha: 0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Exit button (top-right) - always visible unless ultra-minimal
              if (!isUltraMinimal || _showControlsOverlay)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 16,
                  child: IconButton(
                    onPressed: widget.onExit,
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Settings UI (Premium Gated)
```dart
// lib/screens/settings_sheet.dart - Basic Tab > Focus Section

FeatureGate(
  feature: 'focus_mode_ultra_minimal',
  child: SwitchListTile(
    title: Row(
      children: [
        const Text('Ultra-Minimal Mode'),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'PREMIUM',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    subtitle: const Text(
      'Ring-only display. Long press anywhere to show controls.',
    ),
    value: userPrefs.focusModeUltraMinimal,
    onChanged: (value) async {
      await ref.read(userPreferencesProvider.notifier)
          .updateUserPreferences(
            userPrefs.copyWith(focusModeUltraMinimal: value),
          );
    },
  ),
)
```

### Acceptance Criteria
- [ ] Ultra-minimal mode hides timer text by default
- [ ] Long-press anywhere reveals controls overlay
- [ ] Controls overlay auto-hides after 5 seconds
- [ ] Exit button hidden in ultra-minimal (revealed with controls)
- [ ] Gesture hint text updates correctly
- [ ] Premium users can enable ultra-minimal mode
- [ ] Free users see upgrade prompt
- [ ] Overlay fades in/out smoothly

---

## 📁 Files to Create/Modify

### New Files
```
lib/models/focus_mode_theme.dart           # Theme color configurations (P3)
lib/widgets/focus_mode_breathing.dart      # Breathing animation widget (P2)
lib/widgets/focus_theme_selector.dart      # Premium theme picker UI (P3)
```

### Modified Files
```
lib/widgets/focus_mode_overlay.dart        # All P2/P3 feature integration
lib/models/user_preferences.dart           # New preference fields (all features)
lib/providers/user_preferences_provider.dart # Persistence logic (all features)
lib/screens/settings_sheet.dart            # Focus Mode settings section (all features)
lib/services/subscription_service.dart     # Feature gating for P3 features
```

---

## 🧪 Testing Plan

### Unit Tests
```dart
// test/widgets/focus_mode_breathing_test.dart
- Breathing animation lifecycle (start/pause/resume)
- 8-second cycle timing verification
- Controller disposal on widget dispose

// test/models/focus_mode_theme_test.dart
- Theme fromId() lookup
- Color value correctness
- Default theme fallback

// test/providers/user_preferences_test.dart
- Focus Mode preference persistence
- Default value handling
```

### Widget Tests
```dart
// test/widgets/focus_mode_overlay_test.dart
- Icon button rendering and interaction
- Long-press gesture detection
- Ultra-minimal mode overlay toggle
- Theme color application
- Lock mode X button visibility
- Completion celebration animations
```

### Integration Tests
```dart
// integration_test/focus_mode_test.dart
- Full session flow with breathing animation
- Theme switching during session
- Lock mode prevention + completion exit
- Ultra-minimal controls reveal/hide
- Premium feature gating checks
```

---

## 🎯 Implementation Timeline

### Week 1: P2 Foundation
- **Day 1-2**: Breathing animation implementation + unit tests
- **Day 3**: Icon buttons redesign in overlay
- **Day 4-5**: Completion celebration animations + widget tests

### Week 2: P2 Polish + P3 Start
- **Day 1**: Auto-enter Focus Mode settings toggle (UI only, logic exists)
- **Day 2-3**: Lock Mode implementation + safety tests
- **Day 4-5**: Color themes system + theme selector UI

### Week 3: P3 Completion
- **Day 1-2**: Ultra-minimal mode implementation
- **Day 3**: Feature gating integration (Premium check for all P3 features)
- **Day 4**: Comprehensive testing (all themes, modes, combinations)
- **Day 5**: Documentation updates + user guide

---

## ✅ Acceptance Criteria Summary

### P2 (Enhanced UX)
- [ ] Breathing animation cycles smoothly (8s, pauses when paused)
- [ ] Icon buttons replace text buttons cleanly
- [ ] Long-press hint text is clear and visible
- [ ] Completion celebration shows ambient score with animations
- [ ] Auto-enter Focus Mode toggle in Settings (UI + persistence)
- [ ] All animations are smooth (60fps, no janky frames)

### P3 (Premium Features)
- [ ] Lock Mode prevents exit during session
- [ ] Lock Mode always allows exit on completion (safety)
- [ ] 4 color themes available and working
- [ ] Theme selector shows preview cards
- [ ] Ultra-minimal mode hides all text/buttons
- [ ] Long-press reveals controls temporarily (5s timeout)
- [ ] All P3 features behind Premium gate
- [ ] Upgrade prompt shown for free users

---

## 📋 Settings Organization

**Settings > Basic Tab > Focus Section**:
```
┌─ Focus Mode ────────────────────────┐
│ ☑ Enable Focus Mode                 │
│ ☑ Auto Focus Mode                   │  // P2
│ ☐ Breathing Guide                   │  // P2
│                                      │
│ ☐ Lock Mode [PREMIUM]               │  // P3
│ Theme: Midnight ▼ [PREMIUM]         │  // P3 (shows theme selector on tap)
│ ☐ Ultra-Minimal [PREMIUM]           │  // P3
└──────────────────────────────────────┘
```

---

## 🚀 Launch Considerations

**Current P1 Status**:
- ✅ Fully functional and MVP-ready
- ✅ No P2/P3 features required for launch
- ✅ All essential Focus Mode functionality complete

**Post-MVP Rollout Strategy**:
1. **Release 1.1** (P2): Enhanced UX improvements (breathing, icons, celebration)
   - Non-premium features
   - Incremental polish without monetization
2. **Release 1.2** (P3): Premium Features (lock, themes, ultra-minimal)
   - Premium tier value-add
   - Supports Premium Plus upsell

**Why This Matters**:
- P1 provides complete core value (minimal distractions, long-press controls, completion feedback)
- P2/P3 are "nice-to-have" enhancements that can be iterative improvements
- Allows validating core Focus Mode usage before investing in advanced features
- P3 features provide clear Premium tier differentiation for monetization

---

## 📞 Questions/Decisions Needed

Before implementing P2/P3, consider:

1. **Breathing Animation**: Should we add sound option? (e.g., subtle breathing chime)
2. **Lock Mode**: Should there be a "panic exit" gesture? (e.g., triple-tap to override lock)
3. **Color Themes**: Should themes be global (app-wide) or Focus Mode-specific?
4. **Ultra-Minimal**: Should we add haptic feedback when revealing controls?
5. **Premium Tier**: Which features go to Premium vs Premium Plus?

---

**Last Updated**: October 17, 2025
**Status**: Documentation complete, awaiting post-MVP prioritization
