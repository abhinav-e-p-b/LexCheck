import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/shell_provider.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../home/home_screen.dart';
import '../lexchat/lexchat_screen.dart';
import '../profile/profile_screen.dart';
import '../resources/resources_screen.dart';

/// Hosts the four bottom-navigation destinations shown across the mocks:
/// Home, LexChat, Resources, Profile.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    LexChatScreen(),
    ResourcesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(shellIndexProvider);

    return Scaffold(
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: index,
        onTap: (i) => ref.read(shellIndexProvider.notifier).state = i,
      ),
    );
  }
}
