import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:focus_field/utils/debug_log.dart';

/// Service for generating and sharing visual cards from app data.
/// Supports weekly summaries, achievements, streaks, and activity rings.
/// Privacy-first: all data stays on device, shared as static images.
class ShareService {
  static final ShareService _instance = ShareService._internal();
  static ShareService get instance => _instance;
  ShareService._internal();

  /// Captures a widget as an image and shares it.
  /// 
  /// [key] - GlobalKey attached to RepaintBoundary wrapping the widget
  /// [filename] - Name for the saved image file
  /// [text] - Optional text to accompany the image
  /// [subject] - Optional subject line (used in emails)
  /// 
  /// Returns true if share was initiated successfully.
  Future<bool> shareWidget({
    required GlobalKey key,
    required String filename,
    String? text,
    String? subject,
  }) async {
    try {
      // Capture the widget as an image
      final imageBytes = await _captureWidget(key);
      if (imageBytes == null) {
        DebugLog.d('❌ ShareService: Failed to capture widget');
        return false;
      }

      // Save image to temporary directory
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/$filename.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      // Share using native platform dialog
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath)],
          text: text ?? '',
          subject: subject,
        ),
      );

      DebugLog.d('✅ ShareService: Share initiated successfully - $result');
      return true;

    } catch (e, st) {
      DebugLog.d('❌ ShareService: Error sharing widget: $e\n$st');
      return false;
    }
  }

  /// Captures a widget as PNG image bytes.
  /// Uses RepaintBoundary to render widget to image.
  Future<Uint8List?> _captureWidget(GlobalKey key) async {
    try {
      // Wait a frame to ensure widget is fully rendered
      await Future.delayed(const Duration(milliseconds: 100));

      // Find the RenderRepaintBoundary
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        DebugLog.d('❌ ShareService: RenderObject not found');
        return null;
      }

      // Convert to image at high resolution (2x for crisp sharing)
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        DebugLog.d('❌ ShareService: Failed to convert image to bytes');
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e, st) {
      DebugLog.d('❌ ShareService: Error capturing widget: $e\n$st');
      return null;
    }
  }

  /// Shares plain text (no image).
  /// Useful for simple stats or quotes.
  Future<bool> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
        ),
      );
      return true;
    } catch (e) {
      DebugLog.d('❌ ShareService: Error sharing text: $e');
      return false;
    }
  }

  /// Generates a shareable message for weekly summary.
  /// Example: "This week on Focus Field: 147 quiet minutes across 12 sessions 🚀"
  String generateWeeklySummaryText({
    required int totalMinutes,
    required int sessionCount,
    required double successRate,
  }) {
    return 'This week on Focus Field:\n'
        '• $totalMinutes quiet minutes\n'
        '• $sessionCount focus sessions\n'
        '• ${successRate.toStringAsFixed(0)}% success rate\n'
        '🚀 Building deeper focus, one session at a time.';
  }

  /// Generates a shareable message for achievements.
  /// Example: "I just earned 147 quiet minutes on Focus Field! 🎯"
  String generateAchievementText({
    required String achievement,
    int? value,
  }) {
    if (value != null) {
      return 'I just earned $value quiet minutes on Focus Field! 🎯\n\n'
          '#FocusField #DeepWork #Productivity';
    }
    return '$achievement on Focus Field! 🎯\n\n'
        '#FocusField #DeepWork #Productivity';
  }

  /// Generates a shareable message for streaks.
  /// Example: "7-day focus streak on Focus Field! 🔥"
  String generateStreakText({
    required int streakDays,
  }) {
    final emoji = streakDays >= 30 ? '🏆' : streakDays >= 7 ? '🔥' : '⚡';
    return '$streakDays-day focus streak on Focus Field! $emoji\n\n'
        'Consistency is key. Building the habit one day at a time.\n\n'
        '#FocusField #Streaks #ConsistencyIsKey';
  }
}
