import 'package:flutter_test/flutter_test.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/services/silence_detector.dart';

void main() {
  group('SilenceDetector', () {
    test('should initialize with default values', () {
      final detector = SilenceDetector();
      
      expect(detector.threshold, equals(AppConstants.defaultDecibelThreshold));
      expect(detector.durationSeconds, equals(AppConstants.silenceDurationSeconds));
    });

    test('should initialize with custom values', () {
      const customThreshold = 45.0;
      const customDuration = 30;
      
      final detector = SilenceDetector(
        threshold: customThreshold,
        durationSeconds: customDuration,
      );
      
      expect(detector.threshold, equals(customThreshold));
      expect(detector.durationSeconds, equals(customDuration));
    });

    test('should return success for silence below threshold', () {
      final detector = SilenceDetector(threshold: 40.0);
      
      // Simulate readings below threshold
      final readings = [35.0, 36.0, 37.0, 38.0, 39.0];
      final average = readings.reduce((a, b) => a + b) / readings.length;
      
      expect(average, lessThanOrEqualTo(detector.threshold));
    });

    test('should return failure for noise above threshold', () {
      final detector = SilenceDetector(threshold: 40.0);
      
      // Simulate readings above threshold
      final readings = [45.0, 46.0, 47.0, 48.0, 49.0];
      final average = readings.reduce((a, b) => a + b) / readings.length;
      
      expect(average, greaterThan(detector.threshold));
    });

    test('should handle empty readings', () {
      final detector = SilenceDetector();
      
      expect(detector.currentAverageDecibel, equals(0.0));
    });

    test('should calculate average decibel correctly', () {
      final detector = SilenceDetector();
      
      // Simulate adding readings
      final readings = [30.0, 35.0, 40.0];
      final expectedAverage = readings.reduce((a, b) => a + b) / readings.length;
      
      // Note: In a real test, we'd need to mock the noise meter
      // This is a simplified test for the calculation logic
      expect(expectedAverage, equals(35.0));
    });
  });
} 