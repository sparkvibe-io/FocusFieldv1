# iOS Live Activities Implementation Plan

**Status**: Deferred (P1)
**Estimated Effort**: 3-5 days
**iOS Requirement**: iOS 16.1+
**Parity**: Android has ongoing notification; iOS needs Live Activity

---

## Overview

iOS Live Activities provide an always-visible widget on the Lock Screen and Dynamic Island showing session progress, calm percentage, and quick actions. This is the iOS equivalent to Android's ongoing notification.

## Technical Requirements

### 1. **WidgetKit Extension Setup**
- Create new iOS Widget Extension target in Xcode
- Configure App Groups for data sharing between app and widget
- Add ActivityKit framework (iOS 16.1+)

### 2. **Activity Attributes Structure**
```swift
struct FocusSessionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var elapsedSeconds: Int
        var totalSeconds: Int
        var calmPercent: Int
        var isRunning: Bool
    }

    var activityName: String  // e.g., "Study", "Reading"
    var startTime: Date
}
```

### 3. **Live Activity Widget UI**
**Lock Screen (Compact)**:
- Session icon + activity name
- Progress ring
- "Calm 85%" label
- Time remaining

**Lock Screen (Expanded)**:
- Full progress visualization
- Calm percentage with trend
- Two buttons: "Pause" / "End Session"

**Dynamic Island (Compact)**:
- Animated progress arc
- Calm % number

**Dynamic Island (Expanded)**:
- Same as Lock Screen expanded

### 4. **Flutter Integration**

#### Platform Channel
```dart
// lib/services/live_activity_service.dart
class LiveActivityService {
  static const platform = MethodChannel('io.sparkvibe.focusfield/live_activity');

  Future<void> startActivity({
    required String activityName,
    required int durationSeconds,
  }) async {
    await platform.invokeMethod('startActivity', {
      'activityName': activityName,
      'durationSeconds': durationSeconds,
    });
  }

  Future<void> updateActivity({
    required int elapsedSeconds,
    required int calmPercent,
  }) async {
    await platform.invokeMethod('updateActivity', {
      'elapsedSeconds': elapsedSeconds,
      'calmPercent': calmPercent,
    });
  }

  Future<void> endActivity() async {
    await platform.invokeMethod('endActivity');
  }
}
```

#### Swift Implementation (iOS)
```swift
// ios/Runner/LiveActivityPlugin.swift
import ActivityKit
import Flutter

class LiveActivityPlugin: NSObject, FlutterPlugin {
    private var currentActivity: Activity<FocusSessionAttributes>?

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "io.sparkvibe.focusfield/live_activity",
            binaryMessenger: registrar.messenger()
        )
        let instance = LiveActivityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startActivity":
            startActivity(call: call, result: result)
        case "updateActivity":
            updateActivity(call: call, result: result)
        case "endActivity":
            endActivity(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startActivity(call: FlutterMethodCall, result: FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let activityName = args["activityName"] as? String,
              let durationSeconds = args["durationSeconds"] as? Int else {
            result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
            return
        }

        let attributes = FocusSessionAttributes(
            activityName: activityName,
            startTime: Date()
        )
        let initialState = FocusSessionAttributes.ContentState(
            elapsedSeconds: 0,
            totalSeconds: durationSeconds,
            calmPercent: 100,
            isRunning: true
        )

        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                contentState: initialState,
                pushType: nil
            )
            result(nil)
        } catch {
            result(FlutterError(code: "START_FAILED", message: error.localizedDescription, details: nil))
        }
    }

    private func updateActivity(call: FlutterMethodCall, result: FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let elapsedSeconds = args["elapsedSeconds"] as? Int,
              let calmPercent = args["calmPercent"] as? Int else {
            result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
            return
        }

        guard let activity = currentActivity else {
            result(FlutterError(code: "NO_ACTIVITY", message: "No active Live Activity", details: nil))
            return
        }

        let newState = FocusSessionAttributes.ContentState(
            elapsedSeconds: elapsedSeconds,
            totalSeconds: activity.contentState.totalSeconds,
            calmPercent: calmPercent,
            isRunning: true
        )

        Task {
            await activity.update(using: newState)
            result(nil)
        }
    }

    private func endActivity(result: FlutterResult) {
        guard let activity = currentActivity else {
            result(nil)
            return
        }

        Task {
            await activity.end(dismissalPolicy: .immediate)
            currentActivity = nil
            result(nil)
        }
    }
}
```

### 5. **Widget SwiftUI View**
```swift
// FocusSessionWidget/FocusSessionWidgetLiveActivity.swift
import ActivityKit
import WidgetKit
import SwiftUI

struct FocusSessionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocusSessionAttributes.self) { context in
            // Lock screen/banner UI
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded view
                DynamicIslandExpandedRegion(.leading) {
                    ProgressRing(progress: context.state.progress)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text("\(context.state.calmPercent)%")
                            .font(.title)
                        Text("Calm")
                            .font(.caption)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Button("Pause") { /* handle */ }
                        Button("End") { /* handle */ }
                    }
                }
            } compactLeading: {
                ProgressArc(progress: context.state.progress)
            } compactTrailing: {
                Text("\(context.state.calmPercent)%")
            } minimal: {
                ProgressArc(progress: context.state.progress)
            }
        }
    }
}
```

---

## Implementation Steps

### Phase 1: Setup (1 day)
1. Create Widget Extension in Xcode
2. Configure App Groups (`group.io.sparkvibe.focusfield`)
3. Add ActivityKit capability to app and extension
4. Update Info.plist with Live Activity support

### Phase 2: Swift Code (2 days)
1. Implement `FocusSessionAttributes` struct
2. Create SwiftUI views for all Live Activity states
3. Implement `LiveActivityPlugin` in Swift
4. Add button action handlers (pause/end)

### Phase 3: Flutter Integration (1 day)
1. Create `LiveActivityService` in Dart
2. Wire to existing session lifecycle
3. Update session state changes to Live Activity
4. Handle background updates

### Phase 4: Testing & Polish (1 day)
1. Test on physical iOS device (simulator doesn't support Live Activities well)
2. Handle edge cases (app killed, system dismissal)
3. Test Dynamic Island animations
4. Verify battery impact

---

## Fallback Strategy

If Live Activities are not available (iOS <16.1 or user disabled):
- Fall back to local notifications
- Show timer notification when app is backgrounded
- Existing Android notification pattern

---

## Future Enhancements (P2)

- **Push Updates**: Use APNs to update Live Activity when app is suspended
- **Stale State**: Show "Session paused" if no updates for 30s
- **Multiple Sessions**: Support multiple concurrent activities
- **Custom Icons**: Per-activity custom icons in Dynamic Island

---

## Resources

- [Apple: ActivityKit Documentation](https://developer.apple.com/documentation/activitykit)
- [WWDC 2022: Live Activities](https://developer.apple.com/videos/play/wwdc2022/10184/)
- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)

---

**Note**: This is a significant iOS-specific feature. Android already has parity with ongoing notifications. Prioritize after core Quest features are stable.
