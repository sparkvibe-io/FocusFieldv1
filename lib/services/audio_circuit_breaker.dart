import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

/// Circuit breaker states
enum CircuitState {
  closed, // Normal operation
  open, // Failing fast, blocking all calls
  halfOpen, // Testing if service has recovered
}

/// Audio buffer crash detection states
enum AudioBufferState {
  stable, // Normal operation
  unstable, // Experiencing buffer issues
  crashed, // Complete failure, needs restart
}

/// Flutter engine crash detection states
enum FlutterEngineState {
  stable, // Normal operation
  unstable, // Experiencing communication issues
  crashed, // Complete failure, needs app restart
}

/// Circuit breaker pattern for audio access to prevent native crashes
class AudioCircuitBreaker {
  static const int _maxFailures = 3;
  static const Duration _resetTimeout = Duration(minutes: 2);
  static const Duration _bufferRecoveryTimeout = Duration(seconds: 30);
  static const Duration _flutterRecoveryTimeout = Duration(minutes: 1);
  static const Duration _immediateBlockTimeout = Duration(
    seconds: 5,
  ); // Immediate block after any audio activity

  int _failureCount = 0;
  DateTime? _lastFailureTime;
  DateTime? _nextResetTime;
  CircuitState _state = CircuitState.closed;

  // Audio buffer specific tracking
  int _bufferErrorCount = 0;
  DateTime? _lastBufferError;
  AudioBufferState _bufferState = AudioBufferState.stable;

  // Flutter engine specific tracking
  int _flutterErrorCount = 0;
  DateTime? _lastFlutterError;
  FlutterEngineState _flutterState = FlutterEngineState.stable;

  // Immediate crash prevention
  DateTime? _lastAudioActivity;
  bool _immediateBlockActive = false;

  /// Check if the circuit breaker allows the call
  bool canExecute() {
    final now = DateTime.now();

    // IMMEDIATE BLOCK: Block audio access for 5 seconds after any audio activity
    if (_lastAudioActivity != null && !_immediateBlockActive) {
      final timeSinceActivity = now.difference(_lastAudioActivity!);
      if (timeSinceActivity.compareTo(_immediateBlockTimeout) < 0) {
        if (!kReleaseMode) {
          print(
            'DEBUG: Audio access blocked by immediate protection (${_immediateBlockTimeout.inSeconds - timeSinceActivity.inSeconds}s remaining)',
          );
        }
        return false;
      }
    }

    // Check Flutter engine state first (highest priority)
    if (_flutterState == FlutterEngineState.crashed) {
      if (_lastFlutterError != null &&
          now
                  .difference(_lastFlutterError!)
                  .compareTo(_flutterRecoveryTimeout) >
              0) {
        _flutterState = FlutterEngineState.unstable;
        if (!kReleaseMode)
          print(
            'DEBUG: Flutter engine: CRASHED -> UNSTABLE (recovery timeout)',
          );
      } else {
        return false;
      }
    }

    // Check buffer state
    if (_bufferState == AudioBufferState.crashed) {
      if (_lastBufferError != null &&
          now.difference(_lastBufferError!).compareTo(_bufferRecoveryTimeout) >
              0) {
        _bufferState = AudioBufferState.unstable;
        if (!kReleaseMode)
          print('DEBUG: Audio buffer: CRASHED -> UNSTABLE (recovery timeout)');
      } else {
        return false;
      }
    }

    switch (_state) {
      case CircuitState.closed:
        return true;

      case CircuitState.open:
        if (_nextResetTime != null && now.isAfter(_nextResetTime!)) {
          _state = CircuitState.halfOpen;
          if (!kReleaseMode)
            print('DEBUG: Audio circuit breaker: OPEN -> HALF_OPEN');
          return true;
        }
        return false;

      case CircuitState.halfOpen:
        return true;
    }
  }

  /// Record a successful execution
  void recordSuccess() {
    if (_state == CircuitState.halfOpen) {
      reset();
      if (!kReleaseMode)
        print('DEBUG: Audio circuit breaker: HALF_OPEN -> CLOSED (success)');
    } else if (_state == CircuitState.closed) {
      // Gradually reduce failure count on success
      if (_failureCount > 0) {
        _failureCount = math.max(0, _failureCount - 1);
      }
    }

    // Buffer recovery on success
    if (_bufferState == AudioBufferState.unstable) {
      _bufferState = AudioBufferState.stable;
      _bufferErrorCount = 0;
      if (!kReleaseMode)
        print('DEBUG: Audio buffer: UNSTABLE -> STABLE (recovered)');
    }

    // Flutter engine recovery on success
    if (_flutterState == FlutterEngineState.unstable) {
      _flutterState = FlutterEngineState.stable;
      _flutterErrorCount = 0;
      if (!kReleaseMode)
        print('DEBUG: Flutter engine: UNSTABLE -> STABLE (recovered)');
    }
  }

  /// Record a failed execution
  void recordFailure() {
    final now = DateTime.now();
    _failureCount++;
    _lastFailureTime = now;

    if (!kReleaseMode) {
      print('DEBUG: Audio circuit breaker: failure #$_failureCount');
    }

    if (_state == CircuitState.halfOpen) {
      // Failure during half-open means service is still failing
      _state = CircuitState.open;
      _nextResetTime = now.add(_resetTimeout);
      if (!kReleaseMode)
        print('DEBUG: Audio circuit breaker: HALF_OPEN -> OPEN (failed)');
    } else if (_failureCount >= _maxFailures) {
      // Too many failures, open the circuit
      _state = CircuitState.open;
      _nextResetTime = now.add(_resetTimeout);
      if (!kReleaseMode)
        print('DEBUG: Audio circuit breaker: CLOSED -> OPEN (max failures)');
    }
  }

  /// Record an audio buffer specific error
  void recordBufferError(String errorType) {
    final now = DateTime.now();
    _bufferErrorCount++;
    _lastBufferError = now;

    if (!kReleaseMode) {
      print(
        'DEBUG: Audio buffer error: $errorType (count: $_bufferErrorCount)',
      );
    }

    // Check for buffer synchronization issues
    if (errorType.contains('releaseBuffer') ||
        errorType.contains('mUnreleased') ||
        errorType.contains('BufferSizeInFrames')) {
      if (_bufferErrorCount >= 2) {
        _bufferState = AudioBufferState.crashed;
        if (!kReleaseMode)
          print('DEBUG: Audio buffer: STABLE -> CRASHED (buffer sync issues)');
      } else {
        _bufferState = AudioBufferState.unstable;
        if (!kReleaseMode)
          print(
            'DEBUG: Audio buffer: STABLE -> UNSTABLE (buffer issues detected)',
          );
      }
    }
  }

  /// Record a Flutter engine specific error
  void recordFlutterError(String errorType) {
    final now = DateTime.now();
    _flutterErrorCount++;
    _lastFlutterError = now;

    if (!kReleaseMode) {
      print(
        'DEBUG: Flutter engine error: $errorType (count: $_flutterErrorCount)',
      );
    }

    // Check for Flutter communication issues
    if (errorType.contains('nativeDispatchPlatformMessage') ||
        errorType.contains('EventChannel') ||
        errorType.contains('FlutterJNI') ||
        errorType.contains('DartMessenger') ||
        errorType.contains('Runtime aborting')) {
      if (_flutterErrorCount >= 1) {
        // Lower threshold for Flutter crashes
        _flutterState = FlutterEngineState.crashed;
        if (!kReleaseMode)
          print(
            'DEBUG: Flutter engine: STABLE -> CRASHED (communication issues)',
          );
      } else {
        _flutterState = FlutterEngineState.unstable;
        if (!kReleaseMode)
          print(
            'DEBUG: Flutter engine: STABLE -> UNSTABLE (communication issues detected)',
          );
      }
    }
  }

  /// Record audio activity to trigger immediate protection
  void recordAudioActivity() {
    final now = DateTime.now();
    _lastAudioActivity = now;
    _immediateBlockActive = true;

    if (!kReleaseMode) {
      print(
        'DEBUG: Audio activity detected - immediate protection activated for ${_immediateBlockTimeout.inSeconds}s',
      );
    }

    // Schedule deactivation of immediate block
    Timer(_immediateBlockTimeout, () {
      _immediateBlockActive = false;
      if (!kReleaseMode) {
        print('DEBUG: Immediate audio protection deactivated');
      }
    });
  }

  /// Reset the circuit breaker to normal operation
  void reset() {
    _failureCount = 0;
    _lastFailureTime = null;
    _nextResetTime = null;
    _state = CircuitState.closed;

    // Also reset buffer and Flutter states
    _bufferErrorCount = 0;
    _lastBufferError = null;
    _bufferState = AudioBufferState.stable;

    _flutterErrorCount = 0;
    _lastFlutterError = null;
    _flutterState = FlutterEngineState.stable;

    // Reset immediate protection
    _lastAudioActivity = null;
    _immediateBlockActive = false;
  }

  /// Get current state information
  Map<String, dynamic> getState() {
    return {
      'state': _state.toString(),
      'bufferState': _bufferState.toString(),
      'flutterState': _flutterState.toString(),
      'failureCount': _failureCount,
      'bufferErrorCount': _bufferErrorCount,
      'flutterErrorCount': _flutterErrorCount,
      'lastFailureTime': _lastFailureTime?.toIso8601String(),
      'lastBufferError': _lastBufferError?.toIso8601String(),
      'lastFlutterError': _lastFlutterError?.toIso8601String(),
      'nextResetTime': _nextResetTime?.toIso8601String(),
      'canExecute': canExecute(),
    };
  }

  /// Check if we're in a failing state
  bool get isOpen => _state == CircuitState.open;

  /// Check if we're testing recovery
  bool get isHalfOpen => _state == CircuitState.halfOpen;

  /// Check if we're in normal operation
  bool get isClosed => _state == CircuitState.closed;

  /// Check buffer state
  bool get isBufferStable => _bufferState == AudioBufferState.stable;
  bool get isBufferCrashed => _bufferState == AudioBufferState.crashed;

  /// Check Flutter engine state
  bool get isFlutterStable => _flutterState == FlutterEngineState.stable;
  bool get isFlutterCrashed => _flutterState == FlutterEngineState.crashed;

  /// Get time until next reset attempt
  Duration? get timeUntilReset {
    if (_nextResetTime == null) return null;
    final now = DateTime.now();
    if (now.isAfter(_nextResetTime!)) return Duration.zero;
    return _nextResetTime!.difference(now);
  }
}

/// Safe audio execution wrapper with circuit breaker protection
class SafeAudioExecutor {
  final AudioCircuitBreaker _circuitBreaker = AudioCircuitBreaker();

  /// Execute audio-related function with circuit breaker protection
  Future<T?> execute<T>(
    Future<T> Function() audioFunction,
    String operation,
  ) async {
    if (!_circuitBreaker.canExecute()) {
      if (!kReleaseMode) {
        print(
          'DEBUG: SafeAudioExecutor: $operation blocked by circuit breaker (state: ${_circuitBreaker._state}, buffer: ${_circuitBreaker._bufferState}, flutter: ${_circuitBreaker._flutterState})',
        );
      }
      return null;
    }

    try {
      if (!kReleaseMode) {
        print('DEBUG: SafeAudioExecutor: executing $operation');
      }

      // Record audio activity to trigger immediate protection
      _circuitBreaker.recordAudioActivity();

      final result = await audioFunction();
      _circuitBreaker.recordSuccess();

      if (!kReleaseMode) {
        print('DEBUG: SafeAudioExecutor: $operation completed successfully');
      }

      return result;
    } catch (e) {
      if (!kReleaseMode) {
        print('DEBUG: SafeAudioExecutor: $operation failed: $e');
      }

      // Check for specific audio buffer errors and handle them appropriately
      final errorString = e.toString();
      if (errorString.contains('releaseBuffer') ||
          errorString.contains('mUnreleased') ||
          errorString.contains('BufferSizeInFrames') ||
          errorString.contains('AudioRecord') ||
          errorString.contains('AudioTrack')) {
        _circuitBreaker.recordBufferError(errorString);
      } else if (errorString.contains('nativeDispatchPlatformMessage') ||
          errorString.contains('EventChannel') ||
          errorString.contains('FlutterJNI') ||
          errorString.contains('DartMessenger') ||
          errorString.contains('Runtime aborting')) {
        _circuitBreaker.recordFlutterError(errorString);
      } else {
        _circuitBreaker.recordFailure();
      }

      rethrow;
    }
  }

  /// Execute audio function with timeout and circuit breaker protection
  Future<T?> executeWithTimeout<T>(
    Future<T> Function() audioFunction,
    String operation,
    Duration timeout,
  ) async {
    try {
      return await execute(() => audioFunction().timeout(timeout), operation);
    } on TimeoutException {
      if (!kReleaseMode) {
        print(
          'DEBUG: SafeAudioExecutor: $operation timed out after ${timeout.inMilliseconds}ms',
        );
      }
      _circuitBreaker.recordFailure();
      return null;
    }
  }

  /// Get circuit breaker state information
  Map<String, dynamic> getState() {
    return _circuitBreaker.getState();
  }

  /// Reset circuit breaker (for testing or manual recovery)
  void reset() {
    _circuitBreaker.reset();
    if (!kReleaseMode) {
      print('DEBUG: SafeAudioExecutor: circuit breaker manually reset');
    }
  }

  /// Check if audio operations are currently blocked
  bool get isBlocked => !_circuitBreaker.canExecute();

  /// Check if buffer is stable
  bool get isBufferStable => _circuitBreaker.isBufferStable;

  /// Check if Flutter engine is stable
  bool get isFlutterStable => _circuitBreaker.isFlutterStable;

  /// Check if immediate protection is active
  bool get isImmediateProtectionActive => _circuitBreaker._immediateBlockActive;

  /// Get time until audio operations might be allowed again
  Duration? get timeUntilRetry => _circuitBreaker.timeUntilReset;
}
