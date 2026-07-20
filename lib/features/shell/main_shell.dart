import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav.dart';
import '../home/home_screen.dart';
import '../lexchat/lexchat_screen.dart';
import '../profile/profile_screen.dart';
import '../resources/resources_screen.dart';

/// Hosts the four bottom-navigation destinations shown across the mocks:
/// Home, LexChat, Resources, Profile.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  static const _screens = [
    HomeScreen(),
    LexChatScreen(),
    ResourcesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
