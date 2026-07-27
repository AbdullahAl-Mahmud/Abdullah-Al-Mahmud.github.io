import 'package:flutter/material.dart';

class QuickActionCard extends StatefulWidget {
  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        child: Material(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _hovering
                      ? widget.color.withValues(alpha: .65)
                      : scheme.outlineVariant.withValues(alpha: .55),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: _hovering ? .15 : .06),
                    blurRadius: _hovering ? 22 : 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(widget.icon, color: widget.color),
                  ),
                  const Spacer(),
                  Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
