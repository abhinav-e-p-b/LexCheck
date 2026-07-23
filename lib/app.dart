import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/onboarding/splash_screen.dart';
import 'features/onboarding/welcome_screen.dart';

class LexCheckApp extends ConsumerWidget {
  const LexCheckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'LexCheck',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const _SplashEntry(),
    );
  }
}

/// Wrapper that provides the correct Navigator context to SplashScreen.
class _SplashEntry extends StatelessWidget {
  const _SplashEntry();

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onInitiate: () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomeScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: anim,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      },
    );
  }
}
