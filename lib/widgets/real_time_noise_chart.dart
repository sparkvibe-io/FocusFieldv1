import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:silence_score/providers/silence_provider.dart';
import 'dart:math' as math;

class RealTimeNoiseChart extends HookConsumerWidget {
  final double threshold;
  final bool isListening;

  const RealTimeNoiseChart({
    super.key,
    required this.threshold,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final silenceDetector = ref.read(silenceDetectorProvider);
    
    // Chart data points (time, decibel)
    final chartData = useState<List<FlSpot>>([]);
    final startTime = useState<DateTime?>(null);
    final currentDecibel = useState<double>(0.0);
    final smoothedDecibel = useState<double>(0.0); // Add smoothed value for display
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
        debugPrint('DEBUG: Chart - Permission status: $permission');
      });
      return null;
    }, []);

    // Subscribe to real-time decibel readings
    useEffect(() {
      StreamSubscription<double>? subscription;
      Timer? ambientTimer;
      Timer? fallbackTimer;
      
      if (isListening) {
        // During session - listen to detector stream
        subscription = silenceDetector.realtimeStream.listen((decibel) {
          debugPrint('DEBUG: Chart - Session decibel: $decibel');
          currentDecibel.value = decibel;
          // Apply smoothing to reduce blinking (exponential moving average)
          smoothedDecibel.value = smoothedDecibel.value * 0.7 + decibel * 0.3;
          _addDataPoint(chartData, startTime, decibel);
        });
      } else {
        // Ambient monitoring when not in session
        ambientTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
          final decibel = silenceDetector.currentDecibel;
          debugPrint('DEBUG: Chart - Ambient decibel: $decibel');
          if (decibel > 0) {
            currentDecibel.value = decibel;
            // Apply smoothing for ambient monitoring too
            smoothedDecibel.value = smoothedDecibel.value * 0.8 + decibel * 0.2; // More aggressive smoothing for ambient
            _addDataPoint(chartData, startTime, decibel);
          }
        });
        
        // Start ambient monitoring
        silenceDetector.startAmbientMonitoring(
          onError: (error) {
            // Handle error silently for ambient monitoring
            debugPrint('DEBUG: Chart - Ambient monitoring error: $error');
          },
        );
        
        // Fallback timer to show some data even without permission
        fallbackTimer = Timer.periodic(const Duration(milliseconds: 2000), (_) {
          if (!hasPermission.value && chartData.value.isEmpty) {
            // Show placeholder data if no permission and no real data
            final now = DateTime.now();
            final timeSinceStart = now.difference(startTime.value ?? now).inSeconds;
            final placeholderDecibel = 35.0 + (math.sin(timeSinceStart * 0.1) * 5); // Simulated data
            
            currentDecibel.value = placeholderDecibel;
            smoothedDecibel.value = placeholderDecibel;
            _addDataPoint(chartData, startTime, placeholderDecibel);
          }
        });
      }
      
      return () {
        subscription?.cancel();
        ambientTimer?.cancel();
        fallbackTimer?.cancel();
        if (!isListening) {
          silenceDetector.stopAmbientMonitoring();
        }
      };
    }, [isListening, hasPermission.value]);

    // Clean up old data points periodically - less frequent
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 5), (_) { // Reduced frequency from 2s to 5s
        _cleanupOldData(chartData, startTime);
      });
      
      return () => timer.cancel();
    }, []);

    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Noise Level',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
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
                  const SizedBox(width: 4),
                  Text(
                    '${smoothedDecibel.value.toStringAsFixed(1)} dB',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: smoothedDecibel.value > threshold 
                          ? theme.colorScheme.error 
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Chart
          Expanded(
            child: chartData.value.isEmpty 
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          hasPermission.value ? Icons.graphic_eq : Icons.mic_off,
                          size: 32,
                          color: hasPermission.value 
                              ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                              : theme.colorScheme.error.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hasPermission.value 
                              ? 'Initializing audio...'
                              : 'Microphone permission required',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hasPermission.value 
                                ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)
                                : theme.colorScheme.error.withValues(alpha: 0.8),
                          ),
                        ),
                        if (!hasPermission.value) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Tap "Start" to grant permission',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              fontSize: 10,
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
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                              : theme.colorScheme.primary).withValues(alpha: 0.8),
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
                                : theme.colorScheme.primary).withValues(alpha: 0.2),
                            (smoothedDecibel.value > threshold 
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary).withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                    ),
                  // Threshold line
                  LineChartBarData(
                    spots: _generateThresholdLine(chartData.value, threshold),
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
    if (startTime.value == null) return;
    if (decibel.isNaN || decibel.isInfinite) return; // Prevent invalid data
    final now = DateTime.now();
    final totalTimeInSeconds = now.difference(startTime.value!).inMilliseconds / 1000.0;
    if (totalTimeInSeconds.isNaN || totalTimeInSeconds.isInfinite || totalTimeInSeconds < 0) return;
    // Clamp decibel to a reasonable range
    final clampedDecibel = decibel.clamp(0.0, 120.0);
    // Create new data point
    final newPoint = FlSpot(totalTimeInSeconds, clampedDecibel);
    var newData = [...chartData.value, newPoint];
    // If we have more than 60 seconds of data, shift the time window
    if (totalTimeInSeconds > 60) {
      // Calculate the time offset to shift all points back
      final timeOffset = totalTimeInSeconds - 60;
      // Shift all points left by the offset and filter out negative/invalid values
      newData = newData
          .map((point) => FlSpot(point.x - timeOffset, point.y))
          .where((point) => point.x >= 0 && !point.x.isNaN && !point.x.isInfinite && !point.y.isNaN && !point.y.isInfinite)
          .toList();
      // Update the start time to reflect the new window
      startTime.value = startTime.value!.add(Duration(milliseconds: (timeOffset * 1000).round()));
    }
    chartData.value = newData;
  }

  void _cleanupOldData(
    ValueNotifier<List<FlSpot>> chartData,
    ValueNotifier<DateTime?> startTime,
  ) {
    // This method is now handled in _addDataPoint for better performance
    // Keep it for backwards compatibility but make it do nothing
  }

  List<FlSpot> _generateThresholdLine(List<FlSpot> dataPoints, double threshold) {
    // Always show threshold line across the full 60-second window
    return [
      FlSpot(0, threshold),
      FlSpot(60, threshold),
    ];
  }
}
