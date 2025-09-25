import 'package:alien_app/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/gallery/presentation/gallery_page.dart';
import '../features/profile/presentation/profile_page.dart';

class ResponsiveScaffold extends StatefulWidget {
  const ResponsiveScaffold({super.key});

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  int _selectedIndex = 0;

  final _pages = const [
    DashboardPage(),
    GalleryPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: const Text('Aeolians of Oakwood'),
      )
          : null,
      drawer: isMobile
          ? Drawer(
        child: ListView(
          children: [
             DrawerHeader(
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                      Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                    child: Icon(
                      Icons.account_circle,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                ),
                const SizedBox(height: 12),
                  Text(
                    "Aeolians",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    "Innovating the future",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(Icons.dashboard, "Dashboard", 0),
            _buildDrawerItem(Icons.image, "Gallery", 1),
            _buildDrawerItem(Icons.person, "Profile", 2),
            _buildDrawerItem(Icons.settings, "Settings", 3),
          ],
        ),
      )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text("Dashboard"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.image),
                  label: Text("Gallery"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text("Profile"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text("Settings"),
                ),
              ],
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
          child: Icon(icon, size: 24),
        ),
        title: Text(title),
        selected: _selectedIndex == index,
        onTap: () {
          _onTap(index);
          Navigator.pop(context);
        },
        selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
    );
  }

}
