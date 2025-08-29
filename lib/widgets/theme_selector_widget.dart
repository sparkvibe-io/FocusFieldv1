import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:silence_score/providers/theme_provider.dart';
import 'package:silence_score/providers/subscription_provider.dart';
import 'package:silence_score/widgets/feature_gate.dart';

class ThemeSelectorWidget extends ConsumerWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final hasPremiumAccess = ref.watch(premiumAccessProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App Theme',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // All themes in a single compact wrap
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            // Free themes
            _buildCompactThemeOption(
              context,
              AppThemeMode.system,
              currentTheme,
              themeNotifier,
              isPremium: false,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.light,
              currentTheme,
              themeNotifier,
              isPremium: false,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.dark,
              currentTheme,
              themeNotifier,
              isPremium: false,
              hasPremiumAccess: hasPremiumAccess,
            ),
            // Premium themes
            _buildCompactThemeOption(
              context,
              AppThemeMode.oceanBlue,
              currentTheme,
              themeNotifier,
              isPremium: true,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.forestGreen,
              currentTheme,
              themeNotifier,
              isPremium: true,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.purpleNight,
              currentTheme,
              themeNotifier,
              isPremium: true,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.goldLuxury,
              currentTheme,
              themeNotifier,
              isPremium: true,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.solarSunrise,
              currentTheme,
              themeNotifier,
              isPremium: true,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.midnightTeal,
              currentTheme,
              themeNotifier,
              isPremium: true,
              hasPremiumAccess: hasPremiumAccess,
            ),
            _buildCompactThemeOption(
              context,
              AppThemeMode.cyberNeon,
              currentTheme,
              themeNotifier,
              isPremium: true,
              hasPremiumAccess: hasPremiumAccess,
            ),
          ],
        ),
      ],
    );
  }

  // (Old expanded theme option widget removed – compact variant in use)

  Widget _buildCompactThemeOption(
    BuildContext context,
    AppThemeMode themeMode,
    AppThemeMode currentTheme,
    ThemeNotifier themeNotifier,
    {required bool isPremium, required bool hasPremiumAccess}
  ) {
    final isSelected = currentTheme == themeMode;
    final isAccessible = !isPremium || hasPremiumAccess;
    
    return GestureDetector(
      onTap: () {
        if (isAccessible) {
          themeNotifier.setTheme(themeMode);
        } else {
          showPaywall(
            context,
            featureDescription: 'Unlock premium themes',
          );
        }
      },
      child: Container(
        width: 64,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Theme color preview with optional lock/check overlay
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: themeMode.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    themeMode.icon,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                // Premium lock overlay
                if (isPremium && !hasPremiumAccess)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                // Selection indicator
                if (isSelected)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            // Theme name - handle two words
            _buildThemeName(
              context,
              themeMode.displayName,
              isSelected,
              isAccessible,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeName(
    BuildContext context,
    String displayName,
    bool isSelected,
    bool isAccessible,
  ) {
    final words = displayName.split(' ');
    
    if (words.length == 1) {
      return Text(
        displayName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isAccessible 
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
      );
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          words[0],
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isAccessible 
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            height: 1.0,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          words.skip(1).join(' '),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isAccessible 
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            height: 1.0,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 