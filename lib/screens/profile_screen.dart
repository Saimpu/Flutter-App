import 'package:flutter/material.dart';

import '../models/city_request.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.city,
    required this.savedCount,
    required this.requests,
    required this.darkMode,
    required this.onThemeChanged,
    required this.onChooseCity,
    required this.onShowHelp,
  });

  final String city;
  final int savedCount;
  final List<CityRequest> requests;
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onChooseCity;
  final VoidCallback onShowHelp;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your profile',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      )),
              const SizedBox(height: 6),
              Text(
                'Manage your city preferences and app settings.',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: colors.primaryContainer,
                        child: Text(
                          'KS',
                          style: TextStyle(
                            color: colors.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Karthik Saimpu',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text('City resident · $city',
                                style: TextStyle(color: colors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      if (savedCount > 0 && MediaQuery.sizeOf(context).width >= 520)
                        Chip(
                          avatar: const Icon(Icons.bookmark_rounded, size: 16),
                          label: Text('$savedCount saved'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('Preferences',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      value: darkMode,
                      onChanged: onThemeChanged,
                      secondary: Icon(darkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded),
                      title: const Text('Dark appearance'),
                      subtitle: const Text('Use a darker colour scheme'),
                    ),
                    const Divider(height: 1, indent: 18, endIndent: 18),
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: const Text('Selected city'),
                      subtitle: Text(city),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: onChooseCity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text('Recent requests (${requests.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(height: 8),
              Card(
                child: requests.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(Icons.inbox_outlined),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your service requests will appear here during this session.',
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          for (final request in requests.take(4))
                            ListTile(
                              leading: const Icon(Icons.assignment_turned_in_outlined),
                              title: Text(request.serviceTitle),
                              subtitle: Text(
                                '${request.reference} · ${request.details}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                '${request.createdAt.hour.toString().padLeft(2, '0')}:${request.createdAt.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 18),
              Text('Support',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.support_agent_rounded),
                      title: const Text('Contact city help'),
                      subtitle: const Text('Find non-emergency city support'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: onShowHelp,
                    ),
                    const Divider(height: 1, indent: 18, endIndent: 18),
                    const ListTile(
                      leading: Icon(Icons.info_outline_rounded),
                      title: Text('About Civicly'),
                      subtitle: Text('A simple guide to local city services'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  'Civicly · Smart city services',
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
