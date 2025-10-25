import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:focus_field/utils/debug_log.dart';
import 'package:flutter/material.dart';
import 'package:focus_field/l10n/app_localizations.dart';

/// Specialized error boundary for audio-related widgets that may crash due to native audio buffer issues
class AudioSafeWidget extends StatefulWidget {
  final Widget child;
  final Widget? fallback;
  final String debugContext;

  const AudioSafeWidget({
    super.key,
    required this.child,
    required this.debugContext,
    this.fallback,
  });

  @override
  State<AudioSafeWidget> createState() => _AudioSafeWidgetState();
}

class _AudioSafeWidgetState extends State<AudioSafeWidget> {
  bool _hasError = false;
  int _errorCount = 0;
  DateTime? _lastError;
  Timer? _recoveryTimer;
  FlutterExceptionHandler? _previousOnError; // preserve previous handler

  @override
  void initState() {
    super.initState();

    // Preserve existing handler and install scoped handler for native audio crashes
    _previousOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final errorString = details.exception.toString().toLowerCase();
      final stackString = details.stack.toString().toLowerCase();

      // Check for audio buffer or native audio related errors
      if (_isAudioRelatedError(errorString, stackString)) {
        _handleAudioError(details);
      } else {
        // Delegate to previous if exists otherwise present
        if (_previousOnError != null) {
          _previousOnError!(details);
        } else {
          FlutterError.presentError(details);
        }
      }
    };
  }

  @override
  void dispose() {
    _recoveryTimer?.cancel();
    // Restore previous handler if still ours
    if (FlutterError.onError != _previousOnError) {
      FlutterError.onError = _previousOnError;
    }
    super.dispose();
  }

  bool _isAudioRelatedError(String errorString, String stackString) {
    final audioKeywords = [
      'audio',
      'buffer',
      'noise_meter',
      'audio_streamer',
      'microphone',
      'recording',
      'sound',
      'native',
      'audioreaderror',
      'audiounit',
      'avaudiosession',
    ];

    final contextKeywords = [
      widget.debugContext.toLowerCase(),
      'real_time_noise_chart',
      'silence_detector',
      'chart',
    ];

    // Check if error contains audio-related keywords
    for (final keyword in audioKeywords) {
      if (errorString.contains(keyword) || stackString.contains(keyword)) {
        return true;
      }
    }

    // Check if error is from our audio components
    for (final keyword in contextKeywords) {
      if (errorString.contains(keyword) || stackString.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  void _handleAudioError(FlutterErrorDetails details) {
    if (!mounted) return;

    final now = DateTime.now();

    // Reset error count if enough time has passed (5 minutes window – unchanged despite longer free sessions)
    if (_lastError != null && now.difference(_lastError!).inMinutes > 5) {
      _errorCount = 0;
    }

    _errorCount++;
    _lastError = now;

    DebugLog.d(
      'DEBUG: AudioSafeWidget caught audio error #$_errorCount in ${widget.debugContext}: ${details.exception}',
    );

    setState(() {
      _hasError = true;
    });

    // Auto-recovery after a delay, but with exponential backoff
    _recoveryTimer?.cancel();
    final recoveryDelay = Duration(seconds: (2 * _errorCount).clamp(2, 30));

    _recoveryTimer = Timer(recoveryDelay, () {
      if (mounted && _hasError) {
        DebugLog.d(
          'DEBUG: AudioSafeWidget attempting recovery for ${widget.debugContext} after ${recoveryDelay.inSeconds}s',
        );

        setState(() {
          _hasError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ?? _buildDefaultErrorWidget(context);
    }

    // Wrap child in additional error catching
    return Builder(
      builder: (context) {
        try {
          return widget.child;
        } catch (error, stackTrace) {
          // Catch synchronous audio-related errors
          DebugLog.d(
            'DEBUG: AudioSafeWidget caught synchronous error in ${widget.debugContext}: $error',
          );

          final errorString = error.toString().toLowerCase();
          final stackString = stackTrace.toString().toLowerCase();

          if (_isAudioRelatedError(errorString, stackString)) {
            _handleAudioError(
              FlutterErrorDetails(
                exception: error,
                stack: stackTrace,
                context: ErrorDescription(
                  'Audio error in ${widget.debugContext}',
                ),
              ),
            );
            return widget.fallback ?? _buildDefaultErrorWidget(context);
          } else {
            // Re-throw non-audio errors
            rethrow;
          }
        }
      },
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.volume_off, color: theme.colorScheme.error, size: 24),
          const SizedBox(height: 8),
          Text(
            l10n.audioUnavailable,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _errorCount > 3 ? l10n.audioMultipleErrors : l10n.audioRecovering,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (_errorCount <= 3) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _recoveryTimer?.cancel();
                setState(() {
                  _hasError = false;
                });
              },
              child: Text(l10n.retry),
            ),
          ],
        ],
      ),
    );
  }
}

/// Extension to make any widget audio-safe
extension AudioSafeExtension on Widget {
  Widget audioSafe(String debugContext, {Widget? fallback}) {
    return AudioSafeWidget(
      debugContext: debugContext,
      fallback: fallback,
      child: this,
    );
  }
}
