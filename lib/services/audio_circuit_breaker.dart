import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

/// Circuit breaker states
enum CircuitState {
  closed,    // Normal operation
  open,      // Failing fast, blocking all calls
  halfOpen   // Testing if service has recovered
}

/// Circuit breaker pattern for audio access to prevent native crashes
class AudioCircuitBreaker {
  static const int _maxFailures = 3;
  static const Duration _resetTimeout = Duration(minutes: 2);

  int _failureCount = 0;
  DateTime? _lastFailureTime;
  DateTime? _nextResetTime;
  CircuitState _state = CircuitState.closed;

  /// Check if the circuit breaker allows the call
  bool canExecute() {
    final now = DateTime.now();
    
    switch (_state) {
      case CircuitState.closed:
        return true;
        
      case CircuitState.open:
        if (_nextResetTime != null && now.isAfter(_nextResetTime!)) {
          _state = CircuitState.halfOpen;
          if (!kReleaseMode) print('DEBUG: Audio circuit breaker: OPEN -> HALF_OPEN');
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
      if (!kReleaseMode) print('DEBUG: Audio circuit breaker: HALF_OPEN -> CLOSED (success)');
    } else if (_state == CircuitState.closed) {
      // Gradually reduce failure count on success
      if (_failureCount > 0) {
        _failureCount = math.max(0, _failureCount - 1);
      }
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
      if (!kReleaseMode) print('DEBUG: Audio circuit breaker: HALF_OPEN -> OPEN (failed)');
    } else if (_failureCount >= _maxFailures) {
      // Too many failures, open the circuit
      _state = CircuitState.open;
      _nextResetTime = now.add(_resetTimeout);
      if (!kReleaseMode) print('DEBUG: Audio circuit breaker: CLOSED -> OPEN (max failures)');
    }
  }

  /// Reset the circuit breaker to normal operation
  void reset() {
    _failureCount = 0;
    _lastFailureTime = null;
    _nextResetTime = null;
    _state = CircuitState.closed;
  }

  /// Get current state information
  Map<String, dynamic> getState() {
    return {
      'state': _state.toString(),
      'failureCount': _failureCount,
      'lastFailureTime': _lastFailureTime?.toIso8601String(),
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
        print('DEBUG: SafeAudioExecutor: $operation blocked by circuit breaker (state: ${_circuitBreaker._state})');
      }
      return null;
    }
    
    try {
      if (!kReleaseMode) {
        print('DEBUG: SafeAudioExecutor: executing $operation');
      }
      
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
      
      _circuitBreaker.recordFailure();
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
      return await execute(
        () => audioFunction().timeout(timeout),
        operation,
      );
    } on TimeoutException {
      if (!kReleaseMode) {
        print('DEBUG: SafeAudioExecutor: $operation timed out after ${timeout.inMilliseconds}ms');
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

  /// Get time until audio operations might be allowed again
  Duration? get timeUntilRetry => _circuitBreaker.timeUntilReset;
}