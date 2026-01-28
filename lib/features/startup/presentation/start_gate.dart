import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/background_layer.dart';
import '../../auth/presentation/auth_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../onboarding/presentation/onboarding_flow.dart';

class StartGate extends StatelessWidget {
  const StartGate({super.key});

  Future<_StartRoute> _resolveStartRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final authed = prefs.getBool('auth_complete') ?? false;
    final onboarded = prefs.getBool('onboarding_complete') ?? false;
    if (!authed) {
      return _StartRoute.auth;
    }
    if (!onboarded) {
      return _StartRoute.onboarding;
    }
    return _StartRoute.home;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_StartRoute>(
      future: _resolveStartRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const _SplashScreen();
        }
        final route = snapshot.data ?? _StartRoute.auth;
        switch (route) {
          case _StartRoute.auth:
            return const AuthScreen();
          case _StartRoute.onboarding:
            return const OnboardingFlow();
          case _StartRoute.home:
            return const SummarixHome();
        }
      },
    );
  }
}

enum _StartRoute { auth, onboarding, home }

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundLayer(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  size: 56,
                  color: Color(0xFF1A6FA3),
                ),
                const SizedBox(height: 12),
                Text(
                  'Summarix',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
