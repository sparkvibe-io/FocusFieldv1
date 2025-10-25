import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

/// Simple service to perform ambient noise calibration.
/// Collects microphone readings for a fixed duration and returns a
/// recommended decibel threshold (ambient average + margin).
class NoiseCalibrationService {
  NoiseCalibrationService._();
  static final NoiseCalibrationService instance = NoiseCalibrationService._();

  Future<double?> calibrate({
    Duration duration = const Duration(seconds: 5),
    double marginDb = 5,
  }) async {
    if (Platform.isAndroid) {
      final status = await Permission.microphone.status;
      if (status != PermissionStatus.granted) {
        final req = await Permission.microphone.request();
        if (req != PermissionStatus.granted) return null;
      }
    }
    final noiseMeter = NoiseMeter();
    final readings = <double>[];
    StreamSubscription? sub;
    final completer = Completer<double?>();
    Timer? timer;

    try {
      sub = noiseMeter.noise.listen(
        (reading) {
          final db = reading.meanDecibel;
          if (db.isFinite) readings.add(db);
        },
        onError: (e) {
          if (!completer.isCompleted) completer.complete(null);
        },
      );

      timer = Timer(duration, () {
        sub?.cancel();
        if (readings.isEmpty) {
          if (!completer.isCompleted) completer.complete(null);
          return;
        }
        final avg = readings.reduce((a, b) => a + b) / readings.length;
        final recommended =
            (avg + marginDb).clamp(20, 80).toDouble(); // sanity bounds
        if (!kReleaseMode) {
          // ignore: avoid_print
          // print('NoiseCalibration: avg=$avg -> recommended=$recommended');
        }
        if (!completer.isCompleted) completer.complete(recommended);
      });

      return await completer.future;
    } catch (e) {
      if (!kReleaseMode) {
        // ignore: avoid_print
        // print('NoiseCalibration: error $e');
      }
      return null;
    } finally {
      await sub?.cancel();
      timer?.cancel();
    }
  }
}
