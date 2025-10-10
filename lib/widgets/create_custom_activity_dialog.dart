import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_field/providers/activity_provider.dart';

/// Bottom sheet page for creating a custom activity
/// Provides Material icon picker, color picker, title input, silence toggle, and goal minutes
class CreateCustomActivitySheet extends StatefulWidget {
  const CreateCustomActivitySheet({super.key});

  @override
  State<CreateCustomActivitySheet> createState() => _CreateCustomActivitySheetState();
}

class _CreateCustomActivitySheetState extends State<CreateCustomActivitySheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  IconData _selectedIcon = Icons.star;
  Color _selectedColor = const Color(0xFF6C5CE7);
  bool _requiresSilence = true;
  int _goalMinutes = 1;
  double _colorHue = 258.0; // Purple hue

  // Common Material icon options
  static const List<IconData> _commonIcons = [
    Icons.star, Icons.music_note, Icons.sports_soccer, Icons.book,
    Icons.edit, Icons.lightbulb, Icons.school, Icons.palette,
    Icons.restaurant, Icons.coffee, Icons.computer, Icons.phone,
    Icons.fitness_center, Icons.sports_esports, Icons.local_cafe,
    Icons.laptop, Icons.theater_comedy, Icons.mic, Icons.piano,
    Icons.headphones, Icons.camera, Icons.flight, Icons.language,
    Icons.home, Icons.work, Icons.favorite, Icons.psychology,
    Icons.self_improvement, Icons.spa, Icons.emoji_events,
  ];

  Color _getColorFromHue(double hue) {
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.55).toColor();
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = _getColorFromHue(_colorHue);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with drag handle
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Create Custom Activity',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Scrollable content + buttons kept inside the form for visibility
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + MediaQuery.of(context).viewPadding.bottom),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title input
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Activity Name',
                        hintText: 'e.g., Piano Practice',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        counterText: '${_titleController.text.length}/15',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      maxLength: 15,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an activity name';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 12),

                    // Icon picker
                    Text(
                      'Icon',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(6),
                      height: 140,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: _commonIcons.length,
                        itemBuilder: (context, index) {
                          final icon = _commonIcons[index];
                          final isSelected = icon == _selectedIcon;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedIcon = icon),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _selectedColor.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: isSelected
                                    ? Border.all(
                                        color: _selectedColor,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Icon(
                                icon,
                                color: isSelected ? _selectedColor : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Color slider (Hue gradient)
                    Text(
                      'Color',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _HueGradientSlider(
                            value: _colorHue,
                            onChanged: (v) => setState(() {
                              _colorHue = v;
                              _selectedColor = _getColorFromHue(v);
                            }),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Requires silence toggle
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.volume_off_outlined,
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Requires Silence',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Switch(
                            value: _requiresSilence,
                            onChanged: (value) => setState(() => _requiresSilence = value),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Goal minutes input (Material 3 slider like Settings > Basic)
                    _GoalMinutesSlider(
                      value: _goalMinutes,
                      min: 1,
                      max: 120,
                      onChanged: (m) => setState(() => _goalMinutes = m),
                    ),

                    const SizedBox(height: 16),

                    // Action buttons (inside the scrollable form)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _handleCreate,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Create'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
          // No separate bottom action bar; buttons are part of the form above
        ],
      ),
    );
  }

  void _handleCreate() {
    if (!_formKey.currentState!.validate()) return;

    final customActivity = CustomActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      iconCodePoint: _selectedIcon.codePoint,
      requiresSilence: _requiresSilence,
      defaultGoalMinutes: _goalMinutes,
      color: _selectedColor,
    );

    Navigator.of(context).pop(customActivity);
  }
}

/// A Slider with a full hue gradient track for selecting color hue (0..360)
class _HueGradientSlider extends StatelessWidget {
  final double value; // 0..360
  final ValueChanged<double> onChanged;
  const _HueGradientSlider({required this.value, required this.onChanged});

  List<Color> _hueColors() {
    final stops = List.generate(13, (i) => i * 30.0); // 0..360 every 30°
    return [
      for (final h in stops)
        HSLColor.fromAHSL(1.0, h == 360.0 ? 0.0 : h, 0.65, 0.55).toColor(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = _hueColors();
    return Stack(
      alignment: Alignment.center,
      children: [
        // Gradient track background
        Positioned.fill(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(colors: colors),
            ),
          ),
        ),
        // Transparent track slider overlaid to provide thumb & semantics
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 360,
            divisions: 36,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Compact goal minutes slider inspired by Settings > Basic > Session Duration
class _GoalMinutesSlider extends StatelessWidget {
  final int value; // minutes
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  const _GoalMinutesSlider({
    required this.value,
    this.min = 1,
    this.max = 120,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = value.clamp(min, max).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Daily Goal (${v.toInt()} min)',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text('$min min', style: theme.textTheme.bodySmall),
            Expanded(
              child: Slider(
                value: v,
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: (max - min),
                label: '${v.toInt()} min',
                onChanged: (d) => onChanged(d.round()),
              ),
            ),
            Text('$max min', style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
