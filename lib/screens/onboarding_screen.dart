import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_field/l10n/app_localizations.dart';
import '../providers/user_preferences_provider.dart';
import 'home_page_elegant.dart';

/// Onboarding screen shown on first app launch or when replayed from settings
class OnboardingScreen extends ConsumerStatefulWidget {
  final bool isReplay;

  const OnboardingScreen({super.key, this.isReplay = false});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // User selections
  int _selectedEnvironment = 1; // Default: Typical Office (40dB)
  int _selectedGoal = 1; // Default: Building Habit (20 min)
  Set<String> _selectedActivities = {'study', 'reading', 'meditation'};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // Save user preferences
    final prefs = ref.read(userPreferencesProvider);

    // Set threshold based on environment
    final thresholds = [30, 40, 50, 60];
    final threshold = thresholds[_selectedEnvironment];

    // Set goal based on selection
    final goals = [10, 20, 40, 60];
    final goal = goals[_selectedGoal];

    // Update preferences
    await ref
        .read(userPreferencesProvider.notifier)
        .updateUserPreferences(
          prefs.copyWith(
            globalDailyQuietGoalMinutes: goal,
            enabledProfiles: _selectedActivities.toList(),
          ),
        );

    // Save default threshold and onboarding status to SharedPreferences
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt('defaultThreshold', threshold);
    await sharedPrefs.setBool('onboardingCompleted', true);

    if (mounted) {
      if (widget.isReplay) {
        // If replaying, just go back
        Navigator.of(context).pop();
      } else {
        // First time: navigate to home screen with Sessions tab active (index 1)
        // and show a welcome banner
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePageElegant(initialTab: 1),
          ),
        );

        // Show welcome message after navigation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.celebration_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.onboardingWelcomeMessage,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        });
      }
    }
  }

  Future<void> _skipOnboarding() async {
    // Use default settings and mark as completed
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('onboardingCompleted', true);

    if (mounted) {
      if (widget.isReplay) {
        Navigator.of(context).pop();
      } else {
        // Navigate to Sessions tab (index 1) even when skipping
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePageElegant(initialTab: 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (hidden on first page)
                  SizedBox(
                    width: 80,
                    child:
                        _currentPage > 0
                            ? TextButton(
                              onPressed: _previousPage,
                              child: Text(l10n.onboardingBack),
                            )
                            : null,
                  ),
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 6,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: theme.colorScheme.primary,
                      dotColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  // Skip button
                  SizedBox(
                    width: 80,
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        l10n.onboardingSkip,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildWelcomeScreen(theme, l10n),
                  _buildEnvironmentScreen(theme, l10n),
                  _buildGoalScreen(theme, l10n),
                  _buildActivitiesScreen(theme, l10n),
                  _buildPermissionScreen(theme, l10n),
                  _buildQuickTipsScreen(theme, l10n),
                ],
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextPage,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == 5 ? l10n.buttonGetStarted : l10n.buttonNext,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Screen 1: Welcome
  Widget _buildWelcomeScreen(ThemeData theme, AppLocalizations l10n) {
    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Hero icon with solid background
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary,
              ),
              child: Icon(
                Icons.headphones_rounded,
                size: 70,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            // Title with solid color
            Text(
              l10n.onboardingWelcomeTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Subtitle
            Text(
              l10n.onboardingWelcomeSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Key points with colorful cards
            _buildFeatureCard(
              theme,
              Icons.analytics_rounded,
              l10n.onboardingFeatureTrackTitle,
              l10n.onboardingFeatureTrackDesc,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.emoji_events_rounded,
              l10n.onboardingFeatureEarnTitle,
              l10n.onboardingFeatureEarnDesc,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.local_fire_department_rounded,
              l10n.onboardingFeatureBuildTitle,
              l10n.onboardingFeatureBuildDesc,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildFeatureItem(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Screen 2: Environment Assessment
  Widget _buildEnvironmentScreen(ThemeData theme, AppLocalizations l10n) {
    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Icon with solid background
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 45,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingEnvironmentTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingEnvironmentDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildEnvironmentOption(
              theme,
              0,
              Icons.home_rounded,
              l10n.onboardingEnvQuietHome,
              l10n.onboardingEnvQuietHomeDesc,
              l10n.onboardingEnvQuietHomeLevel,
            ),
            const SizedBox(height: 10),
            _buildEnvironmentOption(
              theme,
              1,
              Icons.business_rounded,
              l10n.onboardingEnvOffice,
              l10n.onboardingEnvOfficeDesc,
              l10n.onboardingEnvOfficeLevel,
            ),
            const SizedBox(height: 10),
            _buildEnvironmentOption(
              theme,
              2,
              Icons.local_cafe_rounded,
              l10n.onboardingEnvBusy,
              l10n.onboardingEnvBusyDesc,
              l10n.onboardingEnvBusyLevel,
            ),
            const SizedBox(height: 10),
            _buildEnvironmentOption(
              theme,
              3,
              Icons.public_rounded,
              l10n.onboardingEnvNoisy,
              l10n.onboardingEnvNoisyDesc,
              l10n.onboardingEnvNoisyLevel,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.onboardingAdjustAnytime,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentOption(
    ThemeData theme,
    int index,
    IconData icon,
    String title,
    String subtitle,
    String threshold,
  ) {
    final isSelected = _selectedEnvironment == index;

    return InkWell(
      onTap: () {
        setState(() => _selectedEnvironment = index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    threshold,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // Screen 3: Goal Setting
  Widget _buildGoalScreen(ThemeData theme, AppLocalizations l10n) {
    final advice = [
      l10n.onboardingGoalAdviceGettingStarted,
      l10n.onboardingGoalAdviceBuildingHabit,
      l10n.onboardingGoalAdviceRegularPractice,
      l10n.onboardingGoalAdviceDeepWork,
    ];

    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Goal icon with solid background
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flag_rounded,
                size: 45,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingDailyGoalTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingDailyGoalSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildGoalOption(
              theme,
              l10n,
              0,
              '🌱',
              l10n.onboardingGoalGettingStarted,
              l10n.onboardingDuration10to15,
            ),
            const SizedBox(height: 10),
            _buildGoalOption(theme, l10n, 1, '🎯', l10n.onboardingGoalBuildingHabit, l10n.onboardingDuration20to30),
            const SizedBox(height: 10),
            _buildGoalOption(
              theme,
              l10n,
              2,
              '💪',
              l10n.onboardingGoalRegularPractice,
              l10n.onboardingDuration40to60,
            ),
            const SizedBox(height: 10),
            _buildGoalOption(theme, l10n, 3, '🏆', l10n.onboardingGoalDeepWork, l10n.onboardingDuration60plus),
            const SizedBox(height: 16),
            // Personalized advice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      advice[_selectedGoal],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalOption(
    ThemeData theme,
    AppLocalizations l10n,
    int index,
    String emoji,
    String title,
    String duration,
  ) {
    final isSelected = _selectedGoal == index;

    return InkWell(
      onTap: () {
        setState(() => _selectedGoal = index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    duration,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // Screen 4: Activity Selection
  Widget _buildActivitiesScreen(ThemeData theme, AppLocalizations l10n) {
    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Activity icon with solid background
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 45,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboardingActivitiesTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.onboardingActivitiesSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildActivityOption(
              theme,
              l10n,
              'study',
              Icons.school_rounded,
              l10n.activityStudy,
              l10n.onboardingActivityStudyDesc,
            ),
            const SizedBox(height: 10),
            _buildActivityOption(
              theme,
              l10n,
              'reading',
              Icons.menu_book_rounded,
              l10n.activityReading,
              l10n.onboardingActivityReadingDesc,
            ),
            const SizedBox(height: 10),
            _buildActivityOption(
              theme,
              l10n,
              'meditation',
              Icons.self_improvement_rounded,
              l10n.activityMeditation,
              l10n.onboardingActivityMeditationDesc,
            ),
            const SizedBox(height: 10),
            _buildActivityOption(
              theme,
              l10n,
              'other',
              Icons.star_rounded,
              l10n.activityOther,
              l10n.onboardingActivityOtherDesc,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.onboardingProTip,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityOption(
    ThemeData theme,
    AppLocalizations l10n,
    String id,
    IconData icon,
    String title,
    String description,
  ) {
    final isSelected = _selectedActivities.contains(id);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedActivities.remove(id);
          } else {
            _selectedActivities.add(id);
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedActivities.add(id);
                  } else {
                    _selectedActivities.remove(id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Screen 5: Permission
  Widget _buildPermissionScreen(ThemeData theme, AppLocalizations l10n) {
    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Microphone icon with privacy shield - simplified
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic_rounded,
                    size: 70,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.verified_user_rounded,
                      size: 24,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              l10n.onboardingPrivacyTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingPrivacySubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Privacy assurances
            _buildPrivacyItem(
              theme,
              l10n,
              Icons.mic_off,
              l10n.onboardingPrivacyNoRecording,
              l10n.onboardingPrivacyNoRecordingDesc,
            ),
            const SizedBox(height: 20),
            _buildPrivacyItem(
              theme,
              l10n,
              Icons.phone_android,
              l10n.onboardingPrivacyLocalOnly,
              l10n.onboardingPrivacyLocalOnlyDesc,
            ),
            const SizedBox(height: 20),
            _buildPrivacyItem(
              theme,
              l10n,
              Icons.shield,
              l10n.onboardingPrivacyFirst,
              l10n.onboardingPrivacyFirstDesc,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.onboardingPrivacyNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyItem(
    ThemeData theme,
    AppLocalizations l10n,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Screen 6: Quick Tips
  Widget _buildQuickTipsScreen(ThemeData theme, AppLocalizations l10n) {
    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          96,
        ), // Bottom padding for button (4dp grid)
        child: Column(
          children: [
            const SizedBox(height: 4),
            // Bulb icon with solid background
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tips_and_updates_rounded,
                size: 40,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.onboardingTipsTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.onboardingTipsSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildTipCard(
              theme,
              Icons.timer_rounded,
              l10n.onboardingTip1Title,
              l10n.onboardingTip1Description,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              theme,
              Icons.fullscreen_rounded,
              l10n.onboardingTip2Title,
              l10n.onboardingTip2Description,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              theme,
              Icons.ac_unit_rounded,
              l10n.onboardingTip3Title,
              l10n.onboardingTip3Description,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              theme,
              Icons.trending_up_rounded,
              l10n.onboardingTip4Title,
              l10n.onboardingTip4Description,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.outline, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.rocket_launch_rounded,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboardingLaunchTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.onboardingLaunchDescription,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
