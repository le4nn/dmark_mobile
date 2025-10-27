import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Shell навигация с адаптивным меню
/// На мобильных - BottomNavigationBar
/// На планшетах и десктопах - NavigationRail
class ShellNavigationScaffold extends StatelessWidget {
  /// Навигационный шелл для управления вкладками
  final StatefulNavigationShell navigationShell;

  const ShellNavigationScaffold({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Мобильная версия - BottomNavigationBar
        if (sizingInformation.isMobile) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
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

        // Планшет/Десктоп - NavigationRail
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onDestinationSelected,
                labelType: sizingInformation.isDesktop 
                    ? NavigationRailLabelType.all 
                    : NavigationRailLabelType.selected,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 36,
                    color: theme.colorScheme.primary,
                  ),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.inventory_2_outlined),
                    selectedIcon: Icon(Icons.inventory_2_rounded),
                    label: Text('Товары'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.warehouse_outlined),
                    selectedIcon: Icon(Icons.warehouse_rounded),
                    label: Text('Склады'),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: navigationShell),
            ],
          ),
        );
      },
    );
  }
}
