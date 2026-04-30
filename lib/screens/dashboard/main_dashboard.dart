import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/page_loading_state.dart';
import 'equipment_list_screen.dart';
import 'home_screen.dart';
import 'my_requests_screen.dart';
import 'profile_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  bool _isSwitchingPage = false;
  Timer? _pageSwitchTimer;

  @override
  void initState() {
    super.initState();
    _startPageLoading();
  }

  @override
  void dispose() {
    _pageSwitchTimer?.cancel();
    super.dispose();
  }

  void _startPageLoading() {
    setState(() {
      _isSwitchingPage = true;
    });

    _pageSwitchTimer?.cancel();
    _pageSwitchTimer = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSwitchingPage = false;
      });
    });
  }

  void _navigateToPage(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
    _startPageLoading();
  }

  Widget _currentPage() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          onOpenEquipment: () => _navigateToPage(1),
          onOpenRequests: () => _navigateToPage(2),
        );
      case 1:
        return EquipmentListScreen(onStateUpdate: () => setState(() {}));
      case 2:
        return MyRequestsScreen(onStateUpdate: () => setState(() {}));
      case 3:
        return ProfileScreen(onProfileUpdated: () => setState(() {}));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EasyBorrow San Ramon',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          _QuickNavigationMenu(
            currentIndex: _currentIndex,
            onSelect: _navigateToPage,
            onLogout: widget.onLogout,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _isSwitchingPage
                  ? PageLoadingState(
                      key: ValueKey('loading$_currentIndex'),
                      label: 'Loading section...',
                    )
                  : KeyedSubtree(
                      key: ValueKey('page$_currentIndex'),
                      child: _currentPage(),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _navigateToPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Equipment',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'My Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _QuickNavigationMenu extends StatelessWidget {
  const _QuickNavigationMenu({
    required this.currentIndex,
    required this.onSelect,
    required this.onLogout,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menuItems = const [
      _MenuItem(label: 'Home', icon: Icons.home_outlined),
      _MenuItem(label: 'Available Equipment', icon: Icons.inventory_2_outlined),
      _MenuItem(label: 'My Requests', icon: Icons.assignment_outlined),
      _MenuItem(label: 'Profile', icon: Icons.person_outline),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            for (int index = 0; index < menuItems.length; index++)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _QuickNavButton(
                  label: menuItems[index].label,
                  icon: menuItems[index].icon,
                  isActive: currentIndex == index,
                  onTap: () => onSelect(index),
                ),
              ),
            _LogoutButton(onLogout: onLogout),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _QuickNavButton extends StatelessWidget {
  const _QuickNavButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.white : AppColors.primary,
        backgroundColor: isActive ? AppColors.primary : const Color(0xFFEFF6FF),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onLogout,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.danger,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.logout_rounded, size: 18),
      label: const Text('Logout'),
    );
  }
}
