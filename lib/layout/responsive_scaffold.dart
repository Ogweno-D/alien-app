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
        title: const Text('Flutter Web App'),
      )
          : null,
      drawer: isMobile
          ? Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Navigation"),
            ),
            _buildDrawerItem(Icons.dashboard, "Dashboard", 0),
            _buildDrawerItem(Icons.image, "Gallery", 1),
            _buildDrawerItem(Icons.person, "Profile", 2),
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
              ],
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () {
        _onTap(index);
        Navigator.pop(context); // close drawer
      },
    );
  }
}
