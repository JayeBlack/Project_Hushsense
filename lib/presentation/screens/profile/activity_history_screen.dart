import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';

class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppConstants.textPrimary),
        ),
        title: const Text(
          'Activity History',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        itemCount: 12,
        separatorBuilder: (context, i) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          return _buildActivityItem(i);
        },
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {
        'icon': Icons.mic,
        'title': 'Noise Measurement',
        'subtitle': 'Downtown SF, 72 dB',
        'date': 'Sep 12, 2025 14:31',
        'points': '+10',
      },
      {
        'icon': Icons.location_on,
        'title': 'Venue Check-in',
        'subtitle': 'Blue Bottle Cafe',
        'date': 'Sep 12, 2025 13:02',
        'points': '+50',
      },
      {
        'icon': Icons.map,
        'title': 'Noise Map Contribution',
        'subtitle': 'Mission District',
        'date': 'Sep 11, 2025 20:15',
        'points': '+15',
      },
      {
        'icon': Icons.stars,
        'title': 'Daily Streak',
        'subtitle': '13 days in a row',
        'date': 'Sep 11, 2025 00:01',
        'points': '+5',
      },
    ];
    final a = activities[index % activities.length];
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: AppConstants.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppConstants.primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(a['icon'] as IconData, color: AppConstants.primaryTeal, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimary,
                    fontFamily: 'Funnel Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a['subtitle'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                    fontFamily: 'Funnel Sans',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  a['date'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textSecondary.withValues(alpha: 0.8),
                    fontFamily: 'Funnel Sans',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppConstants.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              a['points'] as String,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppConstants.accentGold,
                fontFamily: 'Funnel Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
