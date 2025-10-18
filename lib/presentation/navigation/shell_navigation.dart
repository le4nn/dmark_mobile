import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell навигация с нижним меню
/// Используется как обертка для основных разделов приложения
class ShellNavigationScaffold extends StatelessWidget {
  /// Навигационный шелл для управления вкладками
  final StatefulNavigationShell navigationShell;

  const ShellNavigationScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Товары',
          ),
          NavigationDestination(
            icon: Icon(Icons.warehouse_outlined),
            selectedIcon: Icon(Icons.warehouse_rounded),
            label: 'Склады',
          ),
        ],
      ),
    );
  }
}
