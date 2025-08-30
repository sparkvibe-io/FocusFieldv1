import 'package:flutter/foundation.dart';
import 'package:silence_score/utils/debug_log.dart';
import 'package:flutter/material.dart';

/// Error boundary widget that catches and handles widget build errors gracefully
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String context;
  final Widget? fallback;
  final Function(FlutterErrorDetails)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    required this.context,
    this.fallback,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    
    // Set up error handler for this boundary
    FlutterError.onError = (FlutterErrorDetails details) {
      // Check if this error is related to our context
      if (details.toString().contains(widget.context) || 
          details.stack.toString().contains(widget.context)) {
        setState(() {
          _hasError = true;
        });
        
        // Call custom error handler if provided
        widget.onError?.call(details);
        
        // Log error in debug mode
        if (!kReleaseMode) {
          DebugLog.d('DEBUG: ErrorBoundary caught error in ${widget.context}: ${details.exception}');
        }
      } else {
        // Re-throw if not our error
        FlutterError.presentError(details);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ?? _buildDefaultErrorWidget(context);
    }

    try {
      return widget.child;
    } catch (error) {
      // Catch any synchronous errors during build
      setState(() {
        _hasError = true;
      });
      
      return widget.fallback ?? _buildDefaultErrorWidget(context);
    }
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Error in ${widget.context}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'This component encountered an error and will be restored automatically.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _hasError = false;
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void reset() {
    if (_hasError) {
      setState(() {
        _hasError = false;
      });
    }
  }
}

/// Safe wrapper for potentially error-prone widgets
class SafeWidget extends StatelessWidget {
  final Widget child;
  final String context;
  final Widget? fallback;

  const SafeWidget({
    super.key,
    required this.child,
    required this.context,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      context: this.context,
      fallback: fallback,
      child: child,
      onError: (details) {
        // Log the error for debugging
        if (!kReleaseMode) {
          DebugLog.d('DEBUG: SafeWidget error in ${this.context}: ${details.exception}');
        }
      },
    );
  }
}

/// Extension to make any widget safe
extension SafeWidgetExtension on Widget {
  Widget safe(String context, {Widget? fallback}) {
    return SafeWidget(
      context: context,
      fallback: fallback,
      child: this,
    );
  }
}