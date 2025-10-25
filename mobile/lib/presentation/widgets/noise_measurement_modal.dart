import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/utils/haptic_feedback.dart';

enum NoiseMeasurementType {
  noiseMeasure,
  noiseLevel,
  venueMeasures,
  complaints,
}

class NoiseMeasurementModal extends StatefulWidget {
  final Function(NoiseMeasurementType) onTypeSelected;

  const NoiseMeasurementModal({
    super.key,
    required this.onTypeSelected,
  });

  @override
  State<NoiseMeasurementModal> createState() => _NoiseMeasurementModalState();
}

class _NoiseMeasurementModalState extends State<NoiseMeasurementModal>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  NoiseMeasurementType? _selectedType;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AppConstants.animationGentle,
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleController.value,
              child: Container(
                margin: const EdgeInsets.all(AppConstants.paddingXL),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.deepBlue.withValues(alpha: 0.2),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      _buildHeader(),

                      // Options Grid - Make it flexible
                      Flexible(
                        child: _buildOptionsGrid(),
                      ),

                      // Action Buttons
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).animate(controller: _fadeController).fadeIn();
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        children: [
          // Icon with gradient background
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryTeal.withValues(alpha: 0.1),
                  AppConstants.primaryTeal.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryTeal.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.mic,
              size: 32,
              color: AppConstants.primaryTeal,
            ),
          ),

          const SizedBox(height: AppConstants.paddingL),

          // Title
          Text(
            'Choose Measurement Type',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
          ),

          const SizedBox(height: AppConstants.paddingS),

          // Subtitle
          Text(
            'Select the type of noise measurement you want to perform',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid() {
    final options = [
      _MeasurementOption(
        type: NoiseMeasurementType.noiseMeasure,
        title: 'Noise Measure',
        subtitle: 'General ambient noise',
        icon: Icons.volume_up,
        color: AppConstants.primaryTeal,
        gradient: [AppConstants.primaryTeal, AppConstants.deepBlue],
      ),
      _MeasurementOption(
        type: NoiseMeasurementType.noiseLevel,
        title: 'Noise Level',
        subtitle: 'Specific decibel levels',
        icon: Icons.graphic_eq,
        color: AppConstants.secondaryColor,
        gradient: [AppConstants.secondaryColor, AppConstants.successColor],
      ),
      _MeasurementOption(
        type: NoiseMeasurementType.venueMeasures,
        title: 'Venue Measures',
        subtitle: 'Location-specific data',
        icon: Icons.store,
        color: AppConstants.accentGold,
        gradient: [AppConstants.accentGold, AppConstants.accentOrange],
      ),
      _MeasurementOption(
        type: NoiseMeasurementType.complaints,
        title: 'Complaints',
        subtitle: 'Report noise issues',
        icon: Icons.report_problem,
        color: AppConstants.errorColor,
        gradient: [AppConstants.errorColor, AppConstants.warningColor],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppConstants.paddingS,
            mainAxisSpacing: AppConstants.paddingS,
            childAspectRatio: 1,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            return _MeasurementOptionCard(
              option: options[index],
              isSelected: _selectedType == options[index].type,
              onTap: () {
                HushHaptics.lightTap();
                setState(() {
                  _selectedType = options[index].type;
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: PremiumButton(
              text: 'Cancel',
              onPressed: () {
                HushHaptics.lightTap();
                Navigator.of(context).pop();
              },
              style: PremiumButtonStyle.secondary,
            ),
          ),

          const SizedBox(width: AppConstants.paddingM),

          // Confirm Button
          Expanded(
            child: PremiumButton(
              text: 'Start',
              icon: Icons.play_arrow,
              onPressed: _selectedType != null
                  ? () {
                      HushHaptics.mediumTap();
                      widget.onTypeSelected(_selectedType!);
                      Navigator.of(context).pop();
                    }
                  : null,
              style: PremiumButtonStyle.primary,
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementOption {
  final NoiseMeasurementType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  _MeasurementOption({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}

class _MeasurementOptionCard extends StatelessWidget {
  final _MeasurementOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _MeasurementOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationNormal,
        curve: AppConstants.easeInOutCubic,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: option.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
            color: isSelected ? option.color : AppConstants.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? option.color.withValues(alpha: 0.3)
                  : AppConstants.deepBlue.withValues(alpha: 0.08),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingS),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon
              AnimatedContainer(
                duration: AppConstants.animationNormal,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : option.color.withValues(alpha: 0.1),
                ),
                child: Icon(
                  option.icon,
                  color: isSelected ? Colors.white : option.color,
                  size: AppConstants.iconSizeM,
                ),
              ),

              const SizedBox(height: AppConstants.paddingXS),

              // Title
              Text(
                option.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : AppConstants.textPrimary,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppConstants.paddingXS),

              // Subtitle
              Text(
                option.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppConstants.textSecondary,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
