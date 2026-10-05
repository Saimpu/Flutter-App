import 'package:flutter/material.dart';

import '../data/city_services.dart';
import '../models/city_request.dart';
import '../models/city_service.dart';
import '../widgets/service_details_sheet.dart';
import 'profile_screen.dart';
import 'services_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  String _city = 'Riverside City';
  final Set<String> _favoriteIds = <String>{};
  final List<CityRequest> _requests = <CityRequest>[];
  int _nextRequestNumber = 1042;

  static const _destinations = <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore_rounded),
      label: Text('Explore'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.bookmark_border_rounded),
      selectedIcon: Icon(Icons.bookmark_rounded),
      label: Text('Saved'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: Text('Profile'),
    ),
  ];

  void _toggleFavorite(CityService service) {
    setState(() {
      if (!_favoriteIds.add(service.id)) {
        _favoriteIds.remove(service.id);
      }
    });
    _showMessage(
      _favoriteIds.contains(service.id)
          ? '${service.title} saved to your list'
          : '${service.title} removed from your list',
    );
  }

  void _openService(CityService service) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) => ServiceDetailsSheet(
        service: service,
        city: _city,
        isSaved: _favoriteIds.contains(service.id),
        onToggleFavorite: () => _toggleFavorite(service),
        onRequest: () {
          Navigator.of(sheetContext).pop();
          _showRequestDialog(service);
        },
      ),
    );
  }

  void _showQuickRequestChooser() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
                child: Text('What do you need help with?',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cityServices.length,
                  itemBuilder: (context, index) {
                    final service = cityServices[index];
                    return ListTile(
                      leading: Icon(service.icon, color: service.color),
                      title: Text(service.title),
                      subtitle: Text(service.category),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _showRequestDialog(service);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRequestDialog(CityService service) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _RequestDialog(
        service: service,
        onSubmit: (details) {
          final reference = 'SC-${_nextRequestNumber++}';
          setState(() {
            _requests.insert(
              0,
              CityRequest(
                reference: reference,
                serviceTitle: service.title,
                details: details,
                createdAt: DateTime.now(),
              ),
            );
          });
          Navigator.of(dialogContext).pop();
          _showMessage('Demo request $reference saved for this session.');
        },
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  void _chooseCity() {
    const cities = ['Riverside City', 'Maplewood', 'Harbour Point'];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose your city',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final city in cities)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_city_rounded),
                  title: Text(city),
                  trailing: city == _city
                      ? Icon(Icons.check_circle_rounded,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    setState(() => _city = city);
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('City updates',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              _NoticeTile(
                icon: Icons.construction_rounded,
                color: const Color(0xFFCF9B2E),
                title: 'Roadworks on River Street',
                message: 'Allow a few extra minutes for your commute today.',
              ),
              _NoticeTile(
                icon: Icons.recycling_rounded,
                color: const Color(0xFF30A477),
                title: 'Collection reminder',
                message: 'Recycling pickup is scheduled for today.',
              ),
              _NoticeTile(
                icon: Icons.park_rounded,
                color: const Color(0xFF4C9B68),
                title: 'Free community events',
                message: 'Three neighbourhood events are coming up this week.',
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmergencyContacts() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get help', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'For immediate danger, contact your local emergency number.',
              ),
              const SizedBox(height: 18),
              const _ContactLine(
                icon: Icons.support_agent_rounded,
                title: 'City information',
                detail: 'Call 311 for non-emergency city services',
              ),
              const _ContactLine(
                icon: Icons.medical_services_outlined,
                title: 'Health support',
                detail: 'Find a public clinic in Health & clinics',
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentPage() {
    switch (_selectedIndex) {
      case 1:
        return ServicesScreen(
          key: const ValueKey('explore'),
          title: 'Explore services',
          subtitle: 'Browse city services and find what you need.',
          services: cityServices,
          city: _city,
          favoriteIds: _favoriteIds,
          onOpenService: _openService,
          onToggleFavorite: _toggleFavorite,
        );
      case 2:
        return ServicesScreen(
          key: const ValueKey('saved'),
          title: 'Saved services',
          subtitle: 'Your shortcuts to the services you use most.',
          services: cityServices
              .where((service) => _favoriteIds.contains(service.id))
              .toList(),
          city: _city,
          favoriteIds: _favoriteIds,
          onOpenService: _openService,
          onToggleFavorite: _toggleFavorite,
          savedOnly: true,
          onBrowseServices: () => setState(() => _selectedIndex = 1),
        );
      case 3:
        return ProfileScreen(
          city: _city,
          savedCount: _favoriteIds.length,
          requests: _requests,
          darkMode: widget.darkMode,
          onThemeChanged: widget.onThemeChanged,
          onChooseCity: _chooseCity,
          onShowHelp: _showEmergencyContacts,
        );
      default:
        return ServicesScreen(
          key: const ValueKey('home'),
          title: 'Good morning, Karthik',
          subtitle: 'Your city, all in one place.',
          services: cityServices,
          city: _city,
          favoriteIds: _favoriteIds,
          showCityOverview: true,
          showQuickActions: true,
          onOpenService: _openService,
          onToggleFavorite: _toggleFavorite,
          onEmergencyHelp: _showEmergencyContacts,
          onQuickRequest: _showQuickRequestChooser,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wideLayout = width >= 900;
    final destinations = _destinations;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: width < 600 ? 16 : 24,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BrandMark(),
            SizedBox(width: 10),
            Text(
              'civicly',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.7),
            ),
          ],
        ),
        actions: [
          if (width >= 480)
            TextButton.icon(
              onPressed: _chooseCity,
              icon: const Icon(Icons.location_on_outlined, size: 18),
              label: Text(_city),
            )
          else
            IconButton(
              onPressed: _chooseCity,
              tooltip: 'Choose city',
              icon: const Icon(Icons.location_city_outlined),
            ),
          IconButton(
            onPressed: _showNotifications,
            tooltip: 'City updates',
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                'KS',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: wideLayout
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  extended: width >= 1200,
                  labelType: width >= 1200 ? null : NavigationRailLabelType.all,
                  onDestinationSelected: (value) =>
                      setState(() => _selectedIndex = value),
                  destinations: destinations,
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: _currentPage()),
              ],
            )
          : _currentPage(),
      bottomNavigationBar: wideLayout
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (value) =>
                  setState(() => _selectedIndex = value),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore_rounded),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bookmark_border_rounded),
                  selectedIcon: Icon(Icons.bookmark_rounded),
                  label: 'Saved',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.location_city_rounded,
          color: Colors.white, size: 21),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.12),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(message),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(detail),
    );
  }
}

class _RequestDialog extends StatefulWidget {
  const _RequestDialog({required this.service, required this.onSubmit});

  final CityService service;
  final ValueChanged<String> onSubmit;

  @override
  State<_RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends State<_RequestDialog> {
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Request ${widget.service.title.toLowerCase()} help'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.service.description),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'How can the city help?',
                hintText: 'Add a few details about your request',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _detailsController.text.trim().isEmpty
              ? null
              : () => widget.onSubmit(_detailsController.text.trim()),
          icon: const Icon(Icons.send_rounded, size: 17),
          label: const Text('Send request'),
        ),
      ],
    );
  }
}
