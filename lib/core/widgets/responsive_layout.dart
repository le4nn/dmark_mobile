import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/breakpoints.dart';

/// A widget that builds different layouts based on the screen width
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Breakpoints.mobile) {
          return mobileBody;
        } else if (constraints.maxWidth < Breakpoints.tablet) {
          return tabletBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}

/// A responsive scaffold that handles navigation based on screen size
class ResponsiveScaffold extends ConsumerWidget {
  final Widget body;
  final String currentRoute;
  final List<NavigationItem> navigationItems;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
    required this.navigationItems,
    this.title,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < Breakpoints.mobile;
    final isTablet = MediaQuery.of(context).size.width < Breakpoints.tablet;
    final currentIndex = navigationItems.indexWhere((item) => item.route == currentRoute).clamp(0, navigationItems.length - 1);

    if (isMobile) {
      return Scaffold(
        appBar: title != null
            ? AppBar(
                title: Text(title!),
                actions: actions,
                elevation: 0,
                scrolledUnderElevation: 2,
              )
            : null,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _navigateTo(context, navigationItems[index].route),
          destinations: navigationItems
              .map((item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.icon, color: theme.colorScheme.primary),
                    label: item.label,
                  ))
              .toList(),
          elevation: 3,
          animationDuration: Breakpoints.animationDuration,
        ),
      );
    }

    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
              elevation: 0,
              scrolledUnderElevation: 2,
            )
          : null,
      body: Row(
        children: [
          if (isTablet)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                    width: 1,))),
              child: NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) => _navigateTo(context, navigationItems[index].route),
                labelType: NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Breakpoints.paddingL),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 36,
                    color: theme.colorScheme.primary,)),
                destinations: navigationItems
                    .map((item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.icon),
                          label: Text(item.label),
                        ))
                    .toList(),
                backgroundColor: theme.colorScheme.surface,
                indicatorColor: theme.colorScheme.primaryContainer,
              ))
          else
            Container(
              width: Breakpoints.sidebarWidth,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                    width: 1,
                  ))),
              child: NavigationDrawer(
                elevation: 0,
                selectedIndex: currentIndex,
                onDestinationSelected: (index) => _navigateTo(context, navigationItems[index].route),
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: Breakpoints.paddingS),
                        Text(
                          'DMARK',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ))])),
                  ...navigationItems.map((item) {
                    return NavigationDrawerDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.icon),
                      label: Text(item.label),
                    );
                  }),
                ])),
          
          Expanded(
            child: body,
          )]),
      floatingActionButton: floatingActionButton,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    if (route != currentRoute) {
      context.go(route);
    }
  }
}

class NavigationItem {
  final String route;
  final String label;
  final IconData icon;

  const NavigationItem({
    required this.route,
    required this.label,
    required this.icon,
  });
}
