# User Guide

## Getting Started

SilenceScore is an ambient noise monitoring application that helps you track and improve the quietness of your environment. Whether you're working from home, studying, or simply want to monitor noise levels, SilenceScore provides real-time feedback and historical tracking.

## Installation

### System Requirements

#### Minimum Requirements
- **iOS**: 13.0 or later
- **Android**: API level 21 (Android 5.0) or later
- **Device**: Smartphone or tablet with microphone

#### Recommended
- Device with good microphone quality for accurate measurements
- Stable environment for consistent readings

### Download and Install

1. **Download** the app from your device's app store
2. **Install** following standard installation procedures
3. **Grant permissions** when prompted (microphone access required)

## First Launch

### Permission Setup

When you first open SilenceScore, you'll be asked to grant microphone permission:

1. **Tap "Allow"** when prompted for microphone access
2. **Enable** if you want background monitoring (optional)

> **Note**: Without microphone permission, the app cannot function. This permission is only used for noise level measurement and no audio is recorded or stored.

### Initial Calibration

Use the Noise Calibration tool (available in Settings > Advanced) to establish a baseline:
1. Open Settings > Advanced > Noise Calibration
2. Stay still & quiet for ~5 seconds
3. The app sets an initial decibel threshold based on ambient noise
4. If ambient noise is high (≥ 70 dB) you’ll see a warning suggesting a quieter space

You can recalibrate anytime. Calibration values are clamped to the supported range (20–80 dB).

## Main Interface

### Home Screen Overview

The main screen displays:

#### 1. Session Progress Ring
- **Large circular countdown** showing remaining session time (MM:SS)
- Tap to start or stop the current session
- Outer ring progress reflects percentage of session completed

#### 2. Real-Time Chart
- **Live decibel graph** showing recent measurements
- Includes current threshold indicator
- Smoothed for readability (exponential moving average)

#### 3. Current Status
- **Noise Level**: Current decibel reading
- **Elapsed / Remaining** session time
- **State**: Running / Stopped indicator

#### 4. Control / Access
- **Tap ring** to start/stop
- **Settings**: Adjust decibel threshold, duration, advanced options
- **History / Analytics**: View recent sessions and weekly trends

## Using SilenceScore

### Starting a Session

1. Tap the progress ring (or Start button if shown)
2. Device can stay on a stable surface nearby
3. Track progress visually; session auto-completes at 100%

### Understanding Silence Tracking

A session counts “quiet time” when ambient noise stays below your configured decibel threshold.

#### Key Factors
- **Threshold**: Lower threshold = more sensitive to noise
- **Consistency**: Fewer spikes above threshold improves uninterrupted quiet stretches
- **Duration**: Longer sessions help build streaks & points

### Real-Time Feedback

#### Visual Indicators
- **Ring Progress**: Session completion percentage
- **Chart Line**: Smoothed decibel readings
- **Threshold Marker**: Context for what counts as noise
- **Warning Banner (Settings)**: Displays when threshold is set very high (≥ 70 dB)

### Stopping a Session

1. Tap the ring again to stop early
2. Completed or stopped sessions record duration & quiet performance (points, streak logic)
3. Refresh analytics/views to see updated cumulative stats

## Settings and Customization

### Accessing Settings

1. Tap the gear icon (or menu action)
2. Use tabs: **Basic**, **Advanced**, **About**
3. Changes apply instantly; no restart needed

### Key Settings

#### Decibel Threshold
- **Range**: 20–80 dB
- **Default**: 38 dB
- **Purpose**: Maximum ambient noise level considered “quiet”
- **Guidance**:
  - 20–30 dB: Very sensitive (library / night)
  - 31–45 dB: Typical quiet workspace
  - 46–60+ dB: Tolerates more background hum
- Setting ≥ 70 dB triggers a high-threshold warning (may ignore meaningful noise)
- Use Calibration first, then fine-tune manually if needed

#### Session Duration
- **Free Tier**: Up to 5 minutes
- **Premium**: Up to 120 minutes
- Adjustable in whole minutes via slider

#### Theme
- System / Light / Dark modes
- Applies immediately

#### Accessibility
Available (Advanced > Accessibility):
- **Vibration Feedback**: Haptic indicators for key events (if supported)
- **Voice Announcements**: (Future expansion placeholder – may not be active yet)
- **High Contrast Mode**: Increased contrast for text & key UI regions
- **Large Text**: Scales typography for readability

#### Notifications
- Reminders & milestone celebration (if enabled in Notification settings sheet)

#### Data & Export (Premium)
- Export session data as **CSV** or **PDF** report
- Includes summary statistics & historical overview

### Calibration (Advanced)
- Opens a dialog performing a ~5 second ambient measurement
- Shows previous vs new threshold when available
- Clamps extreme values to 20–80 dB range
- Warns on high ambient baseline (≥ 70 dB)
- Indicates if no significant change detected

### Reset
- Full reset clears settings & historical data (confirmation required)

## Session History & Analytics

### Recent Sessions
- Shows last sessions (rolling window) with time & high-level result

### Weekly Trends
- Aggregated points / quiet performance over past week
- Smoothed moving average for readability

### Export (Premium)
- Choose CSV for raw analysis or PDF for formatted report

## Tips for Better Quiet Time

### Environment Optimization
- Close windows & isolate mechanical hum sources
- Use soft furnishings to absorb reflections
- Track time-of-day patterns via weekly trends

### Device Placement
- Keep device stationary and unobstructed
- Consistent location improves comparative analysis

### Threshold Strategy
- Start with Calibration
- Lower threshold gradually if sessions rarely complete
- Raise threshold only if minor background hum causes excessive noise events

## Troubleshooting

### No Decibel Readings
1. Confirm microphone permission in system settings
2. Force close & reopen the app
3. Test device microphone with a voice memo

### High Readings in Quiet Room
1. Re-run Calibration
2. Ensure phone isn’t touching vibrating surfaces
3. Clean microphone port gently
4. Lower threshold a few dB and observe

### Sessions End Too Quickly
1. Threshold might be too low for environment
2. Re-calibrate and compare difference
3. Reduce transient noises (fans, keyboards)

### Battery Concerns
- Continuous monitoring uses modest resources (optimized sampling)
- Avoid unnecessary very long sessions on low battery

### Data Export Issues (Premium)
- Ensure at least one recorded session
- Retry if share sheet was dismissed prematurely

## Privacy & Data
- Only decibel numeric values are processed; no audio stored
- All data remains on-device unless you export
- Reset removes all stored history

---
**Last Updated**: August 29, 2025  
**Version**: 1.0.0
