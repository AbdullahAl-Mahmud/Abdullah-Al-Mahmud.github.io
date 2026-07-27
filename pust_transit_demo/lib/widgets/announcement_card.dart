import 'package:flutter/material.dart';

import '../models/announcement_model.dart';
import '../theme/app_colors.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announcement});

  final AnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (announcement.priority) {
      AnnouncementPriority.normal => AppColors.accent,
      AnnouncementPriority.important => AppColors.warning,
      AnnouncementPriority.urgent => AppColors.error,
    };
    final icon = switch (announcement.priority) {
      AnnouncementPriority.normal => Icons.campaign_outlined,
      AnnouncementPriority.important => Icons.info_outline_rounded,
      AnnouncementPriority.urgent => Icons.warning_amber_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(announcement.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
                    Text(announcement.dateLabel, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(announcement.message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
