import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focus_field/providers/silence_provider.dart';
import 'dart:math' as math;
import 'package:focus_field/utils/throttled_logger.dart';
import 'package:focus_field/utils/debug_log.dart';

class RealTimeNoiseChart extends HookConsumerWidget {
  final double threshold;
  final bool isListening;
  final bool showHeader;

  const RealTimeNoiseChart({
    super.key,
    required this.threshold,
    required this.isListening,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final silenceDetector = ref.read(silenceDetectorProvider);
    final noiseController = ref.watch(realTimeNoiseControllerProvider);

    // Chart data points (time, decibel)
    final chartData = useState<List<FlSpot>>([]);
    final startTime = useState<DateTime?>(null);
    final currentDecibel = useState<double>(0.0);
    final smoothedDecibel = useState<double>(
      0.0,
    ); // Add smoothed value for display
    final hasPermission = useState<bool>(false); // Track permission status

    // Initialize start time when chart is first built
    useEffect(() {
      startTime.value = DateTime.now();
      return null;
    }, []);

    // Check permission status
    useEffect(() {
      silenceDetector.hasPermission().then((permission) {
        hasPermission.value = permission;
        DebugLog.d('DEBUG: Chart - Permission status: $permission');
      });
      return null;
    }, []);

    // Subscribe to real-time decibel readings with proper error handling
    useEffect(() {
      // Common update logic used by aggregated controller and ambient fallback.
      bool isDisposed = false;
      Timer? ambientTimer;
      Timer? fallbackTimer;

      void safeUpdateDecibel(double decibel) {
        if (isDisposed) return;
        if (decibel.isNaN ||
            decibel.isInfinite ||
            decibel < 0 ||
            decibel > 150) {
          if (!kReleaseMode) {
            sensorLogger.log('DEBUG: Chart - Invalid decibel value: $decibel');
          }
          return;
        }
        final clamped = decibel.clamp(0.0, 120.0);
        currentDecibel.value = clamped;
        final currentSmoothed = smoothedDecibel.value;
        smoothedDecibel.value =
            (!currentSmoothed.isNaN && !currentSmoothed.isInfinite)
                ? currentSmoothed * 0.7 + clamped * 0.3
                : clamped;
        _addDataPoint(chartData, startTime, clamped);
      }

      // Session or ambient: subscribe to aggregated stream (already throttled to 1Hz)
      final sub = noiseController.stream.listen(
        (d) {
          if (!kReleaseMode) {
            sensorLogger.log(
              'DEBUG: Chart - Aggregated dB: ${d.toStringAsFixed(1)}',
            );
          }
          safeUpdateDecibel(d);
        },
        onError: (e) {
          if (!kReleaseMode) {
            sensorLogger.log('DEBUG: Chart - Aggregated stream error: $e');
          }
        },
      );

      if (!isListening) {
        // Start ambient monitoring (still needed to keep _currentDecibel updated)
        try {
          silenceDetector.startAmbientMonitoring(
            onError: (error) {
              if (!kReleaseMode) {
                sensorLogger.log(
                  'DEBUG: Chart - Ambient monitoring error: $error',
                );
              }
            },
          );
        } catch (e) {
          if (!kReleaseMode) {
            sensorLogger.log(
              'DEBUG: Chart - Failed to start ambient monitoring: $e',
            );
          }
        }

        // Lightweight ambient sampling (lower frequency than before)
        ambientTimer = Timer.periodic(const Duration(seconds: 2), (_) {
          if (isDisposed) return;
          final d = silenceDetector.currentDecibel;
          if (d > 0) safeUpdateDecibel(d);
        });

        // Fallback animation before permission granted
        fallbackTimer = Timer.periodic(const Duration(seconds: 2), (_) {
          if (isDisposed || hasPermission.value || chartData.value.isNotEmpty) {
            return;
          }
          final now = DateTime.now();
          final timeSinceStart =
              now.difference(startTime.value ?? now).inSeconds;
          final placeholderDecibel =
              35.0 + (math.sin(timeSinceStart * 0.1) * 5);
          safeUpdateDecibel(placeholderDecibel);
        });
      }

      return () {
        isDisposed = true;
        sub.cancel();
        ambientTimer?.cancel();
        fallbackTimer?.cancel();
        if (!isListening) {
          try {
            silenceDetector.stopAmbientMonitoring();
          } catch (_) {}
        }
      };
    }, [isListening, hasPermission.value]);  // Removed noiseController - stream subscription handles updates

    // Clean up old data points periodically with error handling
    useEffect(() {
      Timer? cleanupTimer;

      try {
        cleanupTimer = Timer.periodic(const Duration(seconds: 10), (_) {
          try {
            _cleanupOldData(chartData, startTime);
          } catch (e) {
            DebugLog.d('DEBUG: Chart - Cleanup error: $e');
          }
        });
      } catch (e) {
        DebugLog.d('DEBUG: Chart - Failed to create cleanup timer: $e');
      }

      return () {
        cleanupTimer?.cancel();
      };
    }, []);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          // Header - just threshold line indicator (hidden when showHeader is false)
          if (showHeader) ...[
            Row(
              children: [
                Icon(
                  Icons.rule,
                  size: 12,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Threshold: ${threshold.toStringAsFixed(0)} dB',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: smoothedDecibel.value > threshold
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
          ],

          // Chart
          Expanded(
            child:
                chartData.value.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasPermission.value
                                ? Icons.graphic_eq
                                : Icons.mic_off,
                            size: 24, // Reduced from 32 to save space
                            color:
                                hasPermission.value
                                    ? theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.5)
                                    : theme.colorScheme.error.withValues(
                                      alpha: 0.7,
                                    ),
                          ),
                          const SizedBox(height: 2),
                          Flexible(
                            child: Text(
                              hasPermission.value
                                  ? 'Initializing audio...'
                                  : 'Microphone permission required',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    hasPermission.value
                                        ? theme.colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.7)
                                        : theme.colorScheme.error.withValues(
                                          alpha: 0.8,
                                        ),
                                fontSize: 11, // Slightly smaller text
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!hasPermission.value) ...[
                            const SizedBox(height: 2),
                            Flexible(
                              child: Text(
                                'Tap "Start" to grant permission',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                  fontSize: 9, // Reduced from 10 to save space
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                    : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                              strokeWidth: 0.5,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 10,
                                  ),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 60, // Always show 60 seconds
                        minY: 20,
                        maxY: 80,
                        lineBarsData: [
                          // Main noise line
                          if (chartData.value.isNotEmpty)
                            LineChartBarData(
                              spots: chartData.value,
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [
                                  smoothedDecibel.value > threshold
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.primary,
                                  (smoothedDecibel.value > threshold
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.primary)
                                      .withValues(alpha: 0.8),
                                ],
                              ),
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    (smoothedDecibel.value > threshold
                                            ? theme.colorScheme.error
                                            : theme.colorScheme.primary)
                                        .withValues(alpha: 0.2),
                                    (smoothedDecibel.value > threshold
                                            ? theme.colorScheme.error
                                            : theme.colorScheme.primary)
                                        .withValues(alpha: 0.05),
                                  ],
                                ),
                              ),
                            ),
                          // Threshold line
                          LineChartBarData(
                            spots: _generateThresholdLine(
                              chartData.value,
                              threshold,
                            ),
                            isCurved: false,
                            color: theme.colorScheme.outline,
                            barWidth: 1,
                            dashArray: [4, 4],
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  void _addDataPoint(
    ValueNotifier<List<FlSpot>> chartData,
    ValueNotifier<DateTime?> startTime,
    double decibel,
  ) {
    try {
      // Comprehensive validation
      if (startTime.value == null) return;
      if (decibel.isNaN || decibel.isInfinite || decibel < 0 || decibel > 150) {
        DebugLog.d('DEBUG: Chart - Invalid decibel in _addDataPoint: $decibel');
        return;
      }

      final now = DateTime.now();
      final timeDiff = now.difference(startTime.value!);
      final totalTimeInSeconds = timeDiff.inMilliseconds / 1000.0;

      // Validate time calculation
      if (totalTimeInSeconds.isNaN ||
          totalTimeInSeconds.isInfinite ||
          totalTimeInSeconds < 0) {
        DebugLog.d(
          'DEBUG: Chart - Invalid time calculation: $totalTimeInSeconds',
        );
        return;
      }

      // Clamp values to safe ranges
      final clampedDecibel = decibel.clamp(0.0, 120.0);
      final clampedTime = totalTimeInSeconds.clamp(
        0.0,
        1800.0,
      ); // Max 30 minutes

      // Create new data point with validation
      final newPoint = FlSpot(clampedTime, clampedDecibel);

      // Validate the new point before adding
      if (newPoint.x.isNaN ||
          newPoint.x.isInfinite ||
          newPoint.y.isNaN ||
          newPoint.y.isInfinite) {
        DebugLog.d(
          'DEBUG: Chart - Invalid FlSpot created: ${newPoint.x}, ${newPoint.y}',
        );
        return;
      }

      // Get current data and validate
      var currentData = chartData.value;
      if (currentData.length > 1800) {
        // Limit total data points to prevent memory issues (approx 1 point/sec)
        currentData = currentData.sublist(
          currentData.length - 1200,
        ); // Keep last 20 minutes
      }

      var newData = [...currentData, newPoint];

      // Handle sliding window for data older than 60 seconds
      if (totalTimeInSeconds > 60) {
        final timeOffset = totalTimeInSeconds - 60;

        // Validate time offset
        if (timeOffset.isNaN || timeOffset.isInfinite || timeOffset <= 0) {
          DebugLog.d('DEBUG: Chart - Invalid time offset: $timeOffset');
          return;
        }

        // Shift all points and filter out invalid ones
        newData =
            newData
                .map((point) {
                  final newX = point.x - timeOffset;
                  return FlSpot(newX, point.y);
                })
                .where(
                  (point) =>
                      point.x >= 0 &&
                      point.x <= 60 &&
                      !point.x.isNaN &&
                      !point.x.isInfinite &&
                      !point.y.isNaN &&
                      !point.y.isInfinite &&
                      point.y >= 0 &&
                      point.y <= 120,
                )
                .toList();

        // Update start time safely
        try {
          final offsetMs = (timeOffset * 1000).round().abs();
          if (offsetMs > 0 && offsetMs < 86400000) {
            // Reasonable offset (< 24 hours)
            startTime.value = startTime.value!.add(
              Duration(milliseconds: offsetMs),
            );
          }
        } catch (e) {
          DebugLog.d('DEBUG: Chart - Error updating start time: $e');
        }
      }

      // Final validation before updating chart data
      if (newData.isNotEmpty &&
          newData.every(
            (point) =>
                !point.x.isNaN &&
                !point.x.isInfinite &&
                !point.y.isNaN &&
                !point.y.isInfinite &&
                point.x >= 0 &&
                point.y >= 0,
          )) {
        // Ensure the graph always starts at the left edge (x=0) so users
        // don't see the line beginning mid‑chart when starting a session
        // or after window shifts. If the earliest point is offset, insert
        // an anchor using its y value at x=0 without disturbing ordering.
        if (newData.first.x > 0) {
          final anchor = FlSpot(0, newData.first.y);
          newData = [anchor, ...newData.map((p) => FlSpot(p.x, p.y))];
        }
        chartData.value = newData;
      } else {
        DebugLog.d(
          'DEBUG: Chart - Filtered data contains invalid points, skipping update',
        );
      }
    } catch (e) {
      DebugLog.d('DEBUG: Chart - Error in _addDataPoint: $e');
      // Don't crash the app on chart data errors
    }
  }

  void _cleanupOldData(
    ValueNotifier<List<FlSpot>> chartData,
    ValueNotifier<DateTime?> startTime,
  ) {
    try {
      final currentData = chartData.value;
      if (currentData.isEmpty) return;

      // Remove invalid data points
      final validData =
          currentData
              .where(
                (point) =>
                    !point.x.isNaN &&
                    !point.x.isInfinite &&
                    !point.y.isNaN &&
                    !point.y.isInfinite &&
                    point.x >= 0 &&
                    point.x <= 60 &&
                    point.y >= 0 &&
                    point.y <= 120,
              )
              .toList();

      // Limit data points to prevent memory issues
      if (validData.length > 300) {
        final trimmedData = validData.sublist(validData.length - 250);
        chartData.value = trimmedData;
      } else if (validData.length != currentData.length) {
        // Only update if we actually removed invalid data
        chartData.value = validData;
      }
    } catch (e) {
      DebugLog.d('DEBUG: Chart - Error in cleanup: $e');
    }
  }

  List<FlSpot> _generateThresholdLine(
    List<FlSpot> dataPoints,
    double threshold,
  ) {
    // Always show threshold line across the full 60-second window
    return [FlSpot(0, threshold), FlSpot(60, threshold)];
  }
}
