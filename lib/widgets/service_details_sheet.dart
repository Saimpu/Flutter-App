import 'package:flutter/material.dart';

import '../models/city_service.dart';

class ServiceDetailsSheet extends StatefulWidget {
  const ServiceDetailsSheet({
    super.key,
    required this.service,
    required this.city,
    required this.isSaved,
    required this.onToggleFavorite,
    required this.onRequest,
  });

  final CityService service;
  final String city;
  final bool isSaved;
  final VoidCallback onToggleFavorite;
  final VoidCallback onRequest;

  @override
  State<ServiceDetailsSheet> createState() => _ServiceDetailsSheetState();
}

class _ServiceDetailsSheetState extends State<ServiceDetailsSheet> {
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
  }

  Color _conditionColor(BuildContext context) {
    return switch (widget.service.condition) {
      ServiceCondition.operational => const Color(0xFF30A477),
      ServiceCondition.attention => const Color(0xFFE39B27),
      ServiceCondition.planned => Theme.of(context).colorScheme.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    final colors = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        width < 600 ? 22 : 32,
        8,
        width < 600 ? 22 : 32,
        28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: service.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(service.icon, color: service.color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.category,
                            style: TextStyle(
                                color: colors.onSurfaceVariant, fontSize: 12)),
                        const SizedBox(height: 3),
                        Text(
                          service.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _conditionColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 10, color: _conditionColor(context)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.conditionLabel,
                              style: TextStyle(
                                color: _conditionColor(context),
                                fontWeight: FontWeight.w800,
                              )),
                          const SizedBox(height: 3),
                          Text(service.statusMessage,
                              style: TextStyle(color: colors.onSurface)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text('About this service',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              Text(service.details,
                  style: TextStyle(
                      color: colors.onSurfaceVariant, height: 1.5)),
              const SizedBox(height: 22),
              Text('Service information',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.support_agent_rounded,
                      label: 'Contact',
                      value: service.contact,
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 14),
                    _InfoRow(
                      icon: Icons.schedule_rounded,
                      label: 'Response time',
                      value: service.responseTime,
                    ),
                    const Divider(height: 1, indent: 56, endIndent: 14),
                    _InfoRow(
                      icon: Icons.location_city_rounded,
                      label: 'City',
                      value: widget.city,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _isSaved = !_isSaved);
                      widget.onToggleFavorite();
                    },
                    icon: Icon(_isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded),
                    label: Text(_isSaved ? 'Saved' : 'Save service'),
                  ),
                  FilledButton.icon(
                    onPressed: widget.onRequest,
                    icon: const Icon(Icons.add_task_rounded),
                    label: const Text('Request help'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'This service directory is a demo. Availability and response '
                'times are examples.',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: colors.onSurfaceVariant, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
