import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                        'Welcome! Ready to start your first session? 🚀',
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
                              child: const Text('Back'),
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
                        'Skip',
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
                  _buildWelcomeScreen(theme),
                  _buildEnvironmentScreen(theme),
                  _buildGoalScreen(theme),
                  _buildActivitiesScreen(theme),
                  _buildPermissionScreen(theme),
                  _buildQuickTipsScreen(theme),
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
                    _currentPage == 5 ? 'Get Started' : 'Next',
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
  Widget _buildWelcomeScreen(ThemeData theme) {
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
              'Welcome to\nFocus Field! 🎯',
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
              'Your journey to better focus starts here!\nLet\'s build habits that stick 💪',
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
              'Track Your Focus',
              'See your progress in real-time as you build your focus superpower! 📊',
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.emoji_events_rounded,
              'Earn Rewards',
              'Every quiet minute counts! Collect points and celebrate your wins 🏆',
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              theme,
              Icons.local_fire_department_rounded,
              'Build Streaks',
              'Keep the momentum going! Our compassionate system keeps you motivated 🔥',
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
  Widget _buildEnvironmentScreen(ThemeData theme) {
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
              'Where\'s Your Focus Zone? 🎯',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your typical environment so we can optimize for your space!',
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
              'Quiet Home',
              'Bedroom, quiet home office',
              '30 dB - Very quiet',
            ),
            const SizedBox(height: 10),
            _buildEnvironmentOption(
              theme,
              1,
              Icons.business_rounded,
              'Typical Office',
              'Standard office, library',
              '40 dB - Library quiet (Recommended)',
            ),
            const SizedBox(height: 10),
            _buildEnvironmentOption(
              theme,
              2,
              Icons.local_cafe_rounded,
              'Busy Space',
              'Coffee shop, shared workspace',
              '50 dB - Moderate noise',
            ),
            const SizedBox(height: 10),
            _buildEnvironmentOption(
              theme,
              3,
              Icons.public_rounded,
              'Noisy Environment',
              'Open office, public space',
              '60 dB - Higher noise',
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'You can adjust this anytime in Settings',
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
  Widget _buildGoalScreen(ThemeData theme) {
    final advice = [
      'Perfect start! 🌟 Small steps lead to big wins. You\'ve got this!',
      'Excellent choice! 🎯 This sweet spot builds lasting habits!',
      'Ambitious! 💪 You\'re ready to level up your focus game!',
      'Wow! 🏆 Deep work mode activated! Remember to take breaks!',
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
              'Set Your Daily Goal! 🎯',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'How much focused time feels right for you?\n(You can adjust this anytime!)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildGoalOption(
              theme,
              0,
              '🌱',
              'Getting Started',
              '10-15 minutes',
            ),
            const SizedBox(height: 10),
            _buildGoalOption(theme, 1, '🎯', 'Building Habit', '20-30 minutes'),
            const SizedBox(height: 10),
            _buildGoalOption(
              theme,
              2,
              '💪',
              'Regular Practice',
              '40-60 minutes',
            ),
            const SizedBox(height: 10),
            _buildGoalOption(theme, 3, '🏆', 'Deep Work', '60+ minutes'),
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
  Widget _buildActivitiesScreen(ThemeData theme) {
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
              'Choose Your Activities! ✨',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pick all that resonate with you!\n(You can always add more later)',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildActivityOption(
              theme,
              'study',
              Icons.school_rounded,
              'Study',
              'Learning, coursework, research',
            ),
            const SizedBox(height: 10),
            _buildActivityOption(
              theme,
              'reading',
              Icons.menu_book_rounded,
              'Reading',
              'Deep reading, articles, books',
            ),
            const SizedBox(height: 10),
            _buildActivityOption(
              theme,
              'meditation',
              Icons.self_improvement_rounded,
              'Meditation',
              'Mindfulness, breathing exercises',
            ),
            const SizedBox(height: 10),
            _buildActivityOption(
              theme,
              'other',
              Icons.star_rounded,
              'Other',
              'Any focus-requiring activity',
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
                      'Pro tip: Focus Field shines when quiet = focused! 🤫✨',
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
  Widget _buildPermissionScreen(ThemeData theme) {
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
              'Your Privacy Matters! 🔒',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'We need microphone access to measure ambient noise and help you focus better',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Privacy assurances
            _buildPrivacyItem(
              theme,
              Icons.mic_off,
              'No Recording',
              'We only measure noise levels, never record audio',
            ),
            const SizedBox(height: 20),
            _buildPrivacyItem(
              theme,
              Icons.phone_android,
              'Local Only',
              'All data stays on your device',
            ),
            const SizedBox(height: 20),
            _buildPrivacyItem(
              theme,
              Icons.shield,
              'Privacy First',
              'Your conversations are completely private',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'You can grant permission on the next screen when starting your first session',
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
  Widget _buildQuickTipsScreen(ThemeData theme) {
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
              'Pro Tips for Success! 💡',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'These will help you make the most of Focus Field!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildTipCard(
              theme,
              Icons.timer_rounded,
              'Start Small, Win Big! 🌱',
              'Begin with 5-10 minute sessions. Consistency beats perfection!',
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              theme,
              Icons.fullscreen_rounded,
              'Activate Focus Mode! 🎯',
              'Tap Focus Mode for immersive, distraction-free experience.',
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              theme,
              Icons.ac_unit_rounded,
              'Freeze Token = Safety Net! ❄️',
              'Use your monthly token on busy days to protect your streak.',
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              theme,
              Icons.trending_up_rounded,
              'The 70% Rule Rocks! 📈',
              'Aim for 70% quiet time - perfect silence not required!',
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
                          'You\'re Ready to Launch! 🚀',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Let\'s start your first session and build amazing habits!',
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
