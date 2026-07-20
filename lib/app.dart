import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/onboarding/welcome_screen.dart';

class LexCheckApp extends StatelessWidget {
  const LexCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, controller, _) {
          return MaterialApp(
            title: 'LexCheck',
            debugShowCheckedModeBanner: false,
            themeMode: controller.mode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
