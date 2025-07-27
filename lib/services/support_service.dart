import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/subscription_tier.dart';

enum SupportPriority {
  standard,
  premium,
  premiumPlus,
}

class SupportTicket {
  final String subject;
  final String description;
  final SupportPriority priority;
  final Map<String, dynamic> deviceInfo;
  final String userTier;

  const SupportTicket({
    required this.subject,
    required this.description,
    required this.priority,
    required this.deviceInfo,
    required this.userTier,
  });
}

class SupportService {
  static SupportService? _instance;
  static SupportService get instance => _instance ??= SupportService._();
  SupportService._();

  static const String supportEmail = 'silencescore@sparkvibe.io';
  static const String premiumSupportEmail = 'silencescore@sparkvibe.io';
  
  // Web URLs
  static const String faqUrl = 'https://sparkvibe.io';
  static const String documentationUrl = 'https://sparkvibe.io';

  /// Get device information for support tickets (no PII)
  Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final DateTime now = DateTime.now();
    
    final appInfo = {
      'app_version': AppConstants.appVersion,
      'app_environment': AppConstants.currentEnvironment,
      'flutter_version': 'Flutter 3.32.5',
      'dart_version': 'Dart 3.6.0',
      'timestamp': now.toIso8601String(),
      'locale': Platform.localeName,
    };

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          ...appInfo,
          'platform': 'Android',
          'device_model': androidInfo.model,
          'device_brand': androidInfo.brand,
          'device_manufacturer': androidInfo.manufacturer,
          'android_version': androidInfo.version.release,
          'sdk_version': androidInfo.version.sdkInt,
          'security_patch': androidInfo.version.securityPatch,
          'supported_abis': androidInfo.supportedAbis.join(', '),
          'is_physical_device': androidInfo.isPhysicalDevice,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          ...appInfo,
          'platform': 'iOS',
          'device_model': iosInfo.model,
          'ios_version': iosInfo.systemVersion,
          'is_physical_device': iosInfo.isPhysicalDevice,
          'system_name': iosInfo.systemName,
        };
      }
    } catch (e) {
      print('Error getting device info: $e');
    }

    return appInfo;
  }

  /// Open email client with pre-filled support information
  Future<void> openEmailSupport(SupportTicket ticket) async {
    final String email = supportEmail;
    
    final String priority = ticket.priority == SupportPriority.premiumPlus 
        ? '[PREMIUM PLUS]' 
        : ticket.priority == SupportPriority.premium 
            ? '[PREMIUM]' 
            : '[STANDARD]';
    
    final String subject = Uri.encodeComponent('$priority ${ticket.subject}');
    final String body = Uri.encodeComponent(_buildEmailBody(ticket));
    
    // Try approach 1: Full email with subject and body
    final Uri fullEmailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');
    print('Trying full email: subject="${ticket.subject}", body length=${body.length}');
    
    try {
      await launchUrl(fullEmailUri, mode: LaunchMode.externalApplication);
      print('Full email launch successful');
      return;
    } catch (e) {
      print('Full email failed: $e');
    }
    
    // Try approach 2: Just subject, no body
    final Uri subjectOnlyUri = Uri.parse('mailto:$email?subject=$subject');
    print('Trying subject only');
    
    try {
      await launchUrl(subjectOnlyUri, mode: LaunchMode.externalApplication);
      print('Subject-only email launch successful');
      return;
    } catch (e) {
      print('Subject-only failed: $e');
    }
    
    // Try approach 3: Basic mailto
    final Uri basicEmailUri = Uri.parse('mailto:$email');
    print('Trying basic mailto');
    
    try {
      await launchUrl(basicEmailUri, mode: LaunchMode.externalApplication);
      print('Basic email launch successful');
      return;
    } catch (e) {
      print('Basic launch failed: $e');
    }
    
    // If all fail, throw an exception
    throw Exception('No email client available. Please install Gmail, Outlook, or another email app.');
  }

  /// Build email body with essential information
  String _buildEmailBody(SupportTicket ticket) {
    final deviceInfo = ticket.deviceInfo;
    final buffer = StringBuffer();
    
    // User's issue description
    buffer.writeln('ISSUE DESCRIPTION:');
    buffer.writeln(ticket.description);
    buffer.writeln();
    
    // Essential system information
    buffer.writeln('SYSTEM INFO:');
    buffer.writeln('User: ${ticket.userTier}');
    buffer.writeln('App: ${deviceInfo['app_version']} (${deviceInfo['app_environment']})');
    buffer.writeln('Platform: ${deviceInfo['platform']}');
    
    if (deviceInfo['platform'] == 'Android') {
      buffer.writeln('Device: ${deviceInfo['device_brand']} ${deviceInfo['device_model']}');
      buffer.writeln('Android: ${deviceInfo['android_version']} API${deviceInfo['sdk_version']}');
    } else if (deviceInfo['platform'] == 'iOS') {
      buffer.writeln('Device: ${deviceInfo['device_model']}');
      buffer.writeln('iOS: ${deviceInfo['ios_version']}');
    }
    
    buffer.writeln('Locale: ${deviceInfo['locale']}');
    buffer.writeln('Time: ${deviceInfo['timestamp']}');
    
    return buffer.toString();
  }

  /// Get support response time based on priority
  String getSupportResponseTime(SupportPriority priority) {
    return 'We aim to respond as quickly as possible';
  }

  /// Get support priority based on subscription tier
  SupportPriority getSupportPriority(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return SupportPriority.standard;
      case SubscriptionTier.premium:
        return SupportPriority.premium;
      case SubscriptionTier.premiumPlus:
        return SupportPriority.premiumPlus;
    }
  }

  /// Launch FAQ website
  Future<void> openFAQ() async {
    final Uri faqUri = Uri.parse(faqUrl);
    print('Launching FAQ: $faqUri');
    try {
      await launchUrl(faqUri, mode: LaunchMode.externalApplication);
      print('FAQ launched successfully');
    } catch (e) {
      print('FAQ launch failed: $e');
      throw Exception('Could not open browser. Please visit $faqUrl manually.');
    }
  }

  /// Launch documentation website
  Future<void> openDocumentation() async {
    final Uri docUri = Uri.parse(documentationUrl);
    print('Launching Documentation: $docUri');
    try {
      await launchUrl(docUri, mode: LaunchMode.externalApplication);
      print('Documentation launched successfully');
    } catch (e) {
      print('Documentation launch failed: $e');
      throw Exception('Could not open browser. Please visit $documentationUrl manually.');
    }
  }
} 