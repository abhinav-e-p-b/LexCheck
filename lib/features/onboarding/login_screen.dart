import 'package:flutter/material.dart';

import '../../core/theme/app_style.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../shell/main_shell.dart';
import 'user_info_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: style.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isDark ? 'LEGAL_CORE_v1.0' : 'LEXCHECK',
          style: TextStyle(
            color: isDark ? style.accentColor : style.inkColor,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        iconTheme: IconThemeData(color: style.inkColor),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              isDark ? Icons.shield_outlined : Icons.help_outline,
              color: isDark ? style.accentColor : style.inkColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                borderColor: isDark ? style.borderColor : style.inkColor,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'SYSTEM LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: style.inkColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDark) ...[
                            Icon(Icons.warning_amber_rounded,
                                size: 14, color: style.accentColor),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            'AUTHORIZED ACCESS ONLY',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 0.6,
                              color: style.inkMutedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _FieldLabel(isDark ? 'USER_ID_TERMINAL' : '@ EMAIL TERMINAL'),
                    const SizedBox(height: 8),
                    _TerminalField(hint: isDark ? 'Email Terminal' : 'user@lexcheck.sys'),
                    const SizedBox(height: 20),
                    _FieldLabel(isDark ? 'ENCRYPTED_PASSPHRASE' : '⚷ PASSPHRASE'),
                    const SizedBox(height: 8),
                    _TerminalField(hint: 'Passphrase', obscure: true),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'EXECUTE LOGIN',
                      icon: isDark ? Icons.bolt : null,
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                        (route) => false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: style.inkMutedColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('OR',
                              style: TextStyle(color: style.inkMutedColor)),
                        ),
                        Expanded(child: Divider(color: style.inkMutedColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Sign in with Google',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                        (route) => false,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        isDark ? 'RECOVER_PASSPHRASE' : 'RECOVER_LOST_PASSPHRASE',
                        style: TextStyle(
                          color: style.accentColor,
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UserInfoScreen(),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: style.inkMutedColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isDark
                                ? 'CREATE_NEW_INSTANCE'
                                : 'NEW HERE? CONTINUE ANONYMOUSLY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: style.inkColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  isDark
                      ? 'GLOBAL ENCRYPTION ACTIVE\nBY ENTERING THIS PORTAL, YOU AGREE TO DATA\nSOVEREIGNTY PROTOCOL v4.2. UNLAWFUL ENTRY IS\nLOGGED BY NODE_SENTINEL.'
                      : '© 1998 LEXCHECK OPERATING SYSTEMS. ALL RIGHTS\nRESERVED.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: style.inkMutedColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: style.inkMutedColor,
      ),
    );
  }
}

class _TerminalField extends StatelessWidget {
  const _TerminalField({required this.hint, this.obscure = false});
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      obscureText: obscure,
      style: TextStyle(color: style.inkColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: style.inkMutedColor),
        filled: true,
        fillColor: isDark ? Colors.black26 : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(style.cardRadius),
          borderSide: BorderSide(color: style.borderColor, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(style.cardRadius),
          borderSide: BorderSide(color: style.borderColor, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(style.cardRadius),
          borderSide: BorderSide(color: style.accentColor, width: 1.8),
        ),
      ),
    );
  }
}
