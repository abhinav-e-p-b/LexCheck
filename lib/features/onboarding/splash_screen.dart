import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SplashScreen
//
// The mascot is now a static illustration (assets/images/lawyer_mascot.png)
// instead of a hand-painted CustomPainter. It still gets a gentle, premium
// idle treatment — nothing here ever moves like a walk cycle:
//   • _idleCtrl – one continuous looping controller (sine-based) drives a
//                 very subtle breathing scale on the mascot and an inverse
//                 floating-shadow pulse underneath it.
//   • _iconCtrls – three independent controllers (different periods/phases)
//                 driving the slow float + fade of the floating legal icons
//                 (scales, shield, gavel) — unchanged from before.
// ─────────────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  final VoidCallback onInitiate;
  const SplashScreen({super.key, required this.onInitiate});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _idleCtrl;
  late final List<AnimationController> _iconCtrls;

  @override
  void initState() {
    super.initState();

    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();

    _iconCtrls = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 3600 + i * 900),
      )..repeat();
    });
  }

  @override
  void dispose() {
    _idleCtrl.dispose();
    for (final c in _iconCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3D7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 36),
            _buildHeader(),
            const SizedBox(height: 8),
            _buildSubtitle(),
            Expanded(child: _buildStage()),
            _buildButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.verified_user_outlined,
                  color: Color(0xFFFFC107), size: 22),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'LEXCHECK: YOUR\nLEGAL PARTNER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              height: 1.15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: Text(
        'Privacy-first precedent analysis & secure case\nmanagement. We carry the load for you.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.5,
          color: Color(0xFF453500),
          height: 1.55,
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Stage: soft backdrop glow, floating legal icons, and the static mascot
  // image with a gentle breathing/float idle treatment.
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildStage() {
    return LayoutBuilder(builder: (context, constraints) {
      final sw = constraints.maxWidth;
      final sh = constraints.maxHeight;

      const spriteW = 230.0;
      const spriteH = 320.0;
      final centerX = sw / 2 - spriteW / 2;
      final baseTop = sh * 0.5 - spriteH / 2;

      return Stack(clipBehavior: Clip.none, children: [
        // Soft radial backdrop glow behind the mascot.
        Positioned(
          left: sw / 2 - sw * 0.42,
          top: sh * 0.5 - sw * 0.42,
          width: sw * 0.84,
          height: sw * 0.84,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFE9A8).withOpacity(0.9),
                  const Color(0xFFFFE9A8).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

        // Floating legal icons — unchanged.
        _floatingIcon(
          controller: _iconCtrls[0],
          icon: Icons.balance, // scales of justice
          color: const Color(0xFF1E293B),
          left: centerX - spriteW * 0.30,
          top: baseTop + spriteH * 0.04,
          size: 30,
          floatRange: 10,
          phase: 0,
        ),
        _floatingIcon(
          controller: _iconCtrls[1],
          icon: Icons.shield_outlined,
          color: const Color(0xFF9B0000),
          left: centerX + spriteW * 0.92,
          top: baseTop + spriteH * 0.22,
          size: 26,
          floatRange: 8,
          phase: math.pi / 2,
        ),
        _floatingIcon(
          controller: _iconCtrls[2],
          icon: Icons.gavel,
          color: const Color(0xFFFFC107),
          left: centerX + spriteW * 0.10,
          top: baseTop - spriteH * 0.10,
          size: 24,
          floatRange: 9,
          phase: math.pi,
        ),

        // Static mascot image with a subtle breathing lift + floating shadow.
        AnimatedBuilder(
          animation: _idleCtrl,
          builder: (context, _) {
            final cycle = math.sin(_idleCtrl.value * 2 * math.pi); // -1..1
            final breathe = (cycle + 1) / 2; // 0..1
            final lift = breathe * 6.0;
            final scale = 1.0 + (breathe - 0.5) * 0.012;

            return Stack(clipBehavior: Clip.none, children: [
              // Soft floating shadow tied to the same breathing cycle.
              Positioned(
                left: centerX + spriteW * 0.22,
                top: baseTop + spriteH * 0.96 - lift * 0.15,
                width: spriteW * 0.56,
                height: 16,
                child: Opacity(
                  opacity: 0.22 - breathe * 0.07,
                  child: Transform.scale(
                    scale: 1.0 - breathe * 0.08,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9B8B6B),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: centerX,
                top: baseTop - lift,
                width: spriteW,
                height: spriteH,
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/lawyer_mascot.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ]);
          },
        ),
      ]);
    });
  }

  Widget _floatingIcon({
    required AnimationController controller,
    required IconData icon,
    required Color color,
    required double left,
    required double top,
    required double size,
    required double floatRange,
    required double phase,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value * 2 * math.pi + phase;
        final dy = math.sin(t) * floatRange;
        final opacity = 0.45 + (math.sin(t) + 1) / 2 * 0.4; // 0.45..0.85
        return Positioned(
          left: left,
          top: top + dy,
          child: Opacity(
            opacity: opacity,
            child: Icon(icon, size: size, color: color),
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: widget.onInitiate,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 5),
              )
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'I N I T I A T E   S Y S T E M',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}