import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  static const _contacts = <_EmergencyContact>[
    _EmergencyContact('PUST Transport Office', '+880 1700-100001', Icons.directions_bus_rounded, AppColors.primary),
    _EmergencyContact('Campus Security', '+880 1700-100002', Icons.security_rounded, AppColors.accent),
    _EmergencyContact('University Medical Center', '+880 1700-100003', Icons.medical_services_rounded, AppColors.error),
    _EmergencyContact('Local Emergency Service', '999', Icons.emergency_rounded, AppColors.warning),
    _EmergencyContact('Current Bus Driver', '+880 1700-000001', Icons.person_pin_circle_rounded, Color(0xFF7C4DFF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency contacts')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassCard(
                    color: AppColors.error.withValues(alpha: .08),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Demo information only. Except for Bangladesh’s 999 service, the numbers below are placeholders and must be replaced before production use.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final contact in _contacts) ...[
                    _ContactCard(contact: contact),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact});

  final _EmergencyContact contact;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: contact.color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(contact.icon, color: contact.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(contact.phone, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Call ${contact.name}?'),
                content: Text('Web demo: calling is disabled. Number: ${contact.phone}'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                ],
              ),
            ),
            icon: const Icon(Icons.call_rounded),
            label: const Text('Call'),
          ),
        ],
      ),
    );
  }
}

class _EmergencyContact {
  const _EmergencyContact(this.name, this.phone, this.icon, this.color);

  final String name;
  final String phone;
  final IconData icon;
  final Color color;
}
