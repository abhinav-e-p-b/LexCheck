import 'package:flutter/material.dart';

import '../../core/theme/app_style.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import 'login_screen.dart';
import 'privacy_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: style.accentColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      transform: Matrix4.translationValues(4, 4, 0),
                      child: Container(
                        width: 88,
                        height: 88,
                        margin: const EdgeInsets.only(right: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: style.inkColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.verified_user_outlined,
                          color: style.accentColor,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          'LEXCHECK',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: style.inkColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(width: 60, height: 2, color: style.accentColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AppCard(
                alt: true,
                borderColor: style.accentColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.hourglass_bottom,
                            size: 14, color: style.inkColor),
                        const SizedBox(width: 6),
                        Text(
                          'SYSTEM INITIALIZATION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: style.inkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'DEMOCRATIZING LEGAL CLARITY FOR THE NEXT GENERATION OF INDIA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        color: style.inkColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Icons.shield_outlined,
                tag: 'v1.0.42',
                title: 'ZERO LOGS',
                description:
                    'End-to-end encrypted sessions. Your legal queries stay '
                    'between you and the machine.',
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Icons.translate,
                tag: 'Local Ready',
                title: 'MULTI-DIALECT',
                description:
                    'Available in 12+ Indian languages for rural and urban '
                    'legal accessibility.',
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Icons.bolt,
                tag: 'Realtime',
                title: 'INSTANT ANALYSIS',
                description:
                    'Complex case law simplified into actionable summaries '
                    'in under 30 seconds.',
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'START ANONYMOUSLY',
                icon: Icons.arrow_forward,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacySelectionScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'EXISTING USER LOGIN',
                icon: Icons.person_outline,
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
              ),
              const SizedBox(height: 24),
              Divider(color: style.inkMutedColor.withValues(alpha: 0.3)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'SERVER:\nBNGALORE_NORTH_01',
                      style: TextStyle(fontSize: 10, color: style.inkMutedColor),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'LAT: 12.9716° N\nLON: 77.59° E',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10, color: style.inkMutedColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'WHITEPAPER   PUBLIC REGISTRY',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: style.inkMutedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String tag;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: style.inkColor, size: 20),
              Text(
                tag,
                style: TextStyle(color: style.inkMutedColor, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: style.inkColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: style.inkMutedColor,
            ),
          ),
        ],
      ),
    );
  }
}
