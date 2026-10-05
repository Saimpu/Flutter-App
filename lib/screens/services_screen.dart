import 'package:flutter/material.dart';

import '../models/city_service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.services,
    required this.city,
    required this.favoriteIds,
    required this.onOpenService,
    required this.onToggleFavorite,
    this.showCityOverview = false,
    this.showQuickActions = false,
    this.savedOnly = false,
    this.onEmergencyHelp,
    this.onQuickRequest,
    this.onBrowseServices,
  });

  final String title;
  final String subtitle;
  final List<CityService> services;
  final String city;
  final Set<String> favoriteIds;
  final ValueChanged<CityService> onOpenService;
  final ValueChanged<CityService> onToggleFavorite;
  final bool showCityOverview;
  final bool showQuickActions;
  final bool savedOnly;
  final VoidCallback? onEmergencyHelp;
  final VoidCallback? onQuickRequest;
  final VoidCallback? onBrowseServices;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedCondition = 'Any status';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CityService> _filteredServices() {
    final query = _searchController.text.trim().toLowerCase();
    return widget.services.where((service) {
      final matchesCategory = _selectedCategory == 'All' ||
          service.category == _selectedCategory;
      final matchesCondition = switch (_selectedCondition) {
        'Operational' => service.condition == ServiceCondition.operational,
        'Service notice' => service.condition == ServiceCondition.attention,
        'Planned' => service.condition == ServiceCondition.planned,
        _ => true,
      };
      final searchable =
          '${service.title} ${service.category} ${service.description} ${service.details}'
              .toLowerCase();
      return matchesCategory && matchesCondition && searchable.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final columns = screenWidth < 600
        ? 2
        : screenWidth < 1024
            ? 3
            : 4;
    final pagePadding = screenWidth < 600 ? 20.0 : 32.0;
    final visibleServices = _filteredServices();
    final categories = <String>{
      'All',
      ...widget.services.map((service) => service.category),
    }.toList();
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(pagePadding, 28, pagePadding, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.9,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.subtitle,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${visibleServices.length} ${visibleServices.length == 1 ? 'service' : 'services'}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (widget.showCityOverview) ...[
                _CityOverview(city: widget.city),
                const SizedBox(height: 18),
              ],
              if (widget.showQuickActions) ...[
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.add_task_rounded, size: 18),
                      label: const Text('Request a service'),
                      onPressed: widget.onQuickRequest,
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.help_outline_rounded, size: 18),
                      label: const Text('Get help'),
                      onPressed: widget.onEmergencyHelp,
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.notifications_active_outlined,
                          size: 18),
                      label: const Text('City updates'),
                      onPressed: () => ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                          content: Text('Open the bell above for city updates.'),
                          behavior: SnackBarBehavior.floating,
                        )),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search services, topics or keywords',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
              ),
              if (!widget.savedOnly && widget.services.isNotEmpty) ...[
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Browse by category',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCondition,
                        borderRadius: BorderRadius.circular(12),
                        items: const [
                          'Any status',
                          'Operational',
                          'Service notice',
                          'Planned',
                        ]
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) => setState(
                          () => _selectedCondition = value ?? 'Any status',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final category in categories) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) => setState(
                              () => _selectedCategory = category,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ] else
                const SizedBox(height: 18),
              if (visibleServices.isEmpty)
                _EmptyServices(
                  savedOnly: widget.savedOnly,
                  onBrowseServices: widget.onBrowseServices,
                  onClearFilters: () {
                    _searchController.clear();
                    setState(() {
                      _selectedCategory = 'All';
                      _selectedCondition = 'Any status';
                    });
                  },
                )
              else
                GridView.builder(
                  itemCount: visibleServices.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: screenWidth < 600
                        ? 0.94
                        : screenWidth < 1024
                            ? 1.05
                            : 1.12,
                  ),
                  itemBuilder: (context, index) {
                    final service = visibleServices[index];
                    return _ServiceCard(
                      service: service,
                      isSaved: widget.favoriteIds.contains(service.id),
                      onTap: () => widget.onOpenService(service),
                      onFavorite: () => widget.onToggleFavorite(service),
                    );
                  },
                ),
              const SizedBox(height: 26),
              Center(
                child: Text(
                  'City information is provided as a helpful guide. '
                  'For emergencies, contact local emergency services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityOverview extends StatelessWidget {
  const _CityOverview({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF176E60), Color(0xFF145B58)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: wide
          ? Row(
              children: [
                Expanded(child: _OverviewMessage(city: city)),
                const SizedBox(width: 28),
                const _OverviewMetric(
                    icon: Icons.wb_cloudy_rounded,
                    value: '24°',
                    label: 'Partly cloudy'),
                const SizedBox(width: 30),
                Container(width: 1, height: 48, color: Colors.white24),
                const SizedBox(width: 30),
                const _OverviewMetric(
                    icon: Icons.air_rounded, value: 'Good', label: 'Air quality'),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OverviewMessage(city: city),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: _OverviewMetric(
                        icon: Icons.wb_cloudy_rounded,
                        value: '24°',
                        label: 'Partly cloudy',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _OverviewMetric(
                        icon: Icons.air_rounded,
                        value: 'Good',
                        label: 'Air quality',
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _OverviewMessage extends StatelessWidget {
  const _OverviewMessage({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_rounded,
                color: Color(0xFFBFE8DD), size: 16),
            const SizedBox(width: 4),
            Text(city,
                style: const TextStyle(
                    color: Color(0xFFD6F3E8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 11),
        const Text(
          'Your city is in balance.',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3),
        ),
        const SizedBox(height: 4),
        const Text(
          'Local services are ready when you need them.',
          style: TextStyle(color: Color(0xFFD2E7E2), fontSize: 13),
        ),
      ],
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFBFE8DD), size: 22),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFFD2E7E2), fontSize: 11)),
          ],
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.isSaved,
    required this.onTap,
    required this.onFavorite,
  });

  final CityService service;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  Color _statusColor(BuildContext context) {
    return switch (service.condition) {
      ServiceCondition.operational => const Color(0xFF30A477),
      ServiceCondition.attention => const Color(0xFFE39B27),
      ServiceCondition.planned => Theme.of(context).colorScheme.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = _statusColor(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 155;
            return Padding(
              padding: EdgeInsets.all(compact ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: compact ? 40 : 44,
                        height: compact ? 40 : 44,
                        decoration: BoxDecoration(
                          color: service.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(service.icon,
                            color: service.color, size: compact ? 21 : 23),
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints.tightFor(
                          width: 40,
                          height: 40,
                        ),
                        tooltip: isSaved ? 'Remove saved service' : 'Save service',
                        onPressed: onFavorite,
                        icon: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isSaved
                              ? colors.primary
                              : colors.onSurfaceVariant,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    service.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    compact ? service.category : service.description,
                    maxLines: compact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.25,
                        ),
                  ),
                  SizedBox(height: compact ? 7 : 11),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          service.statusMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyServices extends StatelessWidget {
  const _EmptyServices({
    required this.savedOnly,
    required this.onBrowseServices,
    required this.onClearFilters,
  });

  final bool savedOnly;
  final VoidCallback? onBrowseServices;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Column(
            children: [
              Icon(
                savedOnly ? Icons.bookmark_border_rounded : Icons.search_off_rounded,
                color: colors.primary,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                savedOnly ? 'No saved services yet' : 'No matching services',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Text(
                savedOnly
                    ? 'Save a service with the bookmark icon to find it here.'
                    : 'Try a different search or clear your filters.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              if (savedOnly && onBrowseServices != null)
                FilledButton.tonal(
                  onPressed: onBrowseServices,
                  child: const Text('Explore services'),
                )
              else if (!savedOnly)
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  label: const Text('Clear filters'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
