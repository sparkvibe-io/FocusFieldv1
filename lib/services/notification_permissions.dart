import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Isolated permission handler for notification-related permissions.
class NotificationPermissionHandler {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _hasPermission = false;

  NotificationPermissionHandler(this._plugin);

  bool get hasPermission => _hasPermission;

  Future<void> initialize() async {
    if (_isInTestEnvironment()) {
      _hasPermission = false; // treat as no permission in tests
      return;
    }
    await refreshStatus();
  }

  Future<void> refreshStatus() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        _hasPermission = status.isGranted;
      } else {
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.checkPermissions();
        _hasPermission = granted?.isEnabled ?? false;
      }
    } catch (e) {
      if (!kReleaseMode) debugPrint('NotificationPermissionHandler: error checking permission: $e');
      _hasPermission = false;
    }
  }

  Future<bool> request() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        _hasPermission = status.isGranted;
        if (status.isGranted) {
          final granted = await _plugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();
          _hasPermission = granted ?? false;
        }
      } else {
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        _hasPermission = granted ?? false;
      }
      return _hasPermission;
    } catch (e) {
      if (!kReleaseMode) debugPrint('NotificationPermissionHandler: error requesting permission: $e');
      return false;
    }
  }

  bool _isInTestEnvironment() {
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }
}
