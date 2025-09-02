import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Simple container for frequently needed app metadata.
class AppInfo {
  final String appName;
  final String packageName;
  final String version; // Semantic version e.g. 0.3.1
  final String buildNumber; // Build number e.g. 3
  const AppInfo({required this.appName, required this.packageName, required this.version, required this.buildNumber});
  @override
  String toString() => 'AppInfo(version=$version+$buildNumber, package=$packageName)';
}

/// FutureProvider that fetches PackageInfo once.  
/// Consumers can watch this provider to display current version dynamically.
final appInfoProvider = FutureProvider<AppInfo>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return AppInfo(
    appName: info.appName,
    packageName: info.packageName,
    version: info.version,
    buildNumber: info.buildNumber,
  );
});
